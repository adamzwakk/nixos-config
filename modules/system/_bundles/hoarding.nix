{
  options,
  config,
  lib,
  pkgs,
  namespace,
  flake-inputs,
  ...
}:
with lib;
let
  piaGen = pkgs.writeShellApplication {
    name = "pia-wg-gen";
    runtimeInputs = with pkgs; [ curl jq wireguard-tools ];
    text = ''
      export CA="${./pia/ca.rsa.4096.crt}"
      ${builtins.readFile ./pia/pia-gen.sh}
    '';
  };

  accessibleHosts = [
    { cidr = "127.0.0.1";       glob = "127.0.0.1"; }
    { cidr = "192.168.10.0/24"; glob = "192.168.10.*"; }
    { cidr = "192.168.1.0/24";  glob = "192.168.1.*"; }
  ];

  torrentRPCPort = 9091;
  sabnzbdPort = 8123;
in
{
  imports = [
    flake-inputs.vpn-confinement.nixosModules.default
  ];
  users.groups.hoarding = {};

  sops.secrets."pia/env" = { };
  sops.secrets."sabnzbd/server".owner = config.services.sabnzbd.user;
  sops.secrets."sabnzbd/user".owner = config.services.sabnzbd.user;
  sops.secrets."sabnzbd/password".owner = config.services.sabnzbd.user;

  ## Transmission/VPN Confinement

  environment.systemPackages = with pkgs; [ wireguard-tools ]; ## Just making sure we have it
  vpnNamespaces.wg = {
    enable = true;
    wireguardConfigFile = "/var/lib/pia/wg.conf";
    accessibleFrom = map (n: n.cidr) accessibleHosts;
    portMappings = [ { from = torrentRPCPort; to = torrentRPCPort; } ];
  };

  systemd.services.transmission.vpnConfinement = {
    enable = true;
    vpnNamespace = "wg";
  };

  systemd.services.pia-wg-gen = {
    description = "Generate PIA WireGuard config";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    before = [ "wg.service" ];
    requiredBy = [ "wg.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      EnvironmentFile = config.sops.secrets."pia/env".path;
      ExecStart = "${piaGen}/bin/pia-wg-gen";
    };
  };

  ## Access with http://192.168.15.1:9091/transmission/web locally
  services.transmission = {
    enable = true;
    settings = {
      rpc-port = torrentRPCPort;
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = lib.concatStringsSep "," (map (n: n.glob) accessibleHosts ++ [ "192.168.15.5" ]);
    };
  };

  services.sabnzbd = {
    enable = true;
    openFirewall = true;
    group = "hoarding";
    configFile = null;
    settings = {
      misc = {
        port = sabnzbdPort;
        bandwidth_max = "10MB/s";
        bandwidth_perc = 80;
      };
      servers.newsgroup-ninja = {
        name = "newsgroup-ninja";
        displayname = "Newsgroup Ninja";
        host = "@sab_server@";
        port = 563;
        connections = 20;
        ssl = true;
        priority = 0;
        username = "@sab_username@";
        password = "@sab_password@";
        expire_date = null;
      };
    };

    secretValues = {
      "@sab_server@" = config.sops.secrets."sabnzbd/server".path;
      "@sab_username@" = config.sops.secrets."sabnzbd/user".path;
      "@sab_password@" = config.sops.secrets."sabnzbd/password".path;
    };
  };
}