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
  mkPiaScript = name: file: pkgs.writeShellApplication {
    inherit name;
    runtimeInputs = with pkgs; [ curl jq iptables coreutils wireguard-tools ];
    text = ''
      export CA="${./pia/ca.rsa.4096.crt}"
      ${builtins.readFile file}
    '';
  };
  
  piaGen = mkPiaScript "pia-wg-gen" ./pia/pia-gen.sh;
  piaPortForward = mkPiaScript "pia-portforward" ./pia/pia-portforward.sh;
  piaPfRefresh   = mkPiaScript "pia-pf-refresh"  ./pia/pia-pf-refresh.sh;

  accessibleHosts = [
    { cidr = "127.0.0.1";       glob = "127.0.0.1"; }
    { cidr = "192.168.10.0/24"; glob = "192.168.10.*"; }
    { cidr = "192.168.1.0/24";  glob = "192.168.1.*"; }
  ];

  torrentRPCPort = 9091;
in
{
  options.lv426.hoarding.transmission.enable = mkOption {
    type = types.bool;
    default = false;
    description = "Whether to enable transmission";
  };

  imports = [
    flake-inputs.vpn-confinement.nixosModules.default
  ];

  config = mkIf config.lv426.hoarding.transmission.enable {
    sops.secrets."pia/env" = { };

    ## Transmission/VPN Confinement

    environment.systemPackages = with pkgs; [ wireguard-tools ]; ## Just making sure we have it
    vpnNamespaces.wg = {
      enable = true;
      wireguardConfigFile = "/var/lib/pia/wg.conf";
      accessibleFrom = map (n: n.cidr) accessibleHosts;
      portMappings = [ { from = torrentRPCPort; to = torrentRPCPort; } ];
    };

    systemd = {
      services = {
        transmission = {
          vpnConfinement = {
            enable = true;
            vpnNamespace = "wg";
          };

          serviceConfig.ExecStartPre = lib.mkAfter [
            ("+" + pkgs.writeShellScript "transmission-peerport" ''
              port=$(cat /var/lib/pia/port)
              f=${config.services.transmission.home}/.config/transmission-daemon/settings.json
              ${pkgs.jq}/bin/jq --argjson p "$port" '."peer-port" = $p' "$f" > "$f.tmp"
              install -m 600 -o ${config.services.transmission.user} -g ${config.services.transmission.group} "$f.tmp" "$f"
              rm -f "$f.tmp"
            '')
          ];
        };

        pia-wg-gen = {
          description = "Generate PIA WireGuard config";
          after = [ "network-online.target" ];
          wants = [ "network-online.target" ];
          before = [ "wg.service" ];
          requiredBy = [ "wg.service" ];
          serviceConfig = {
            Type = "oneshot";
            StateDirectory = "pia";
            RemainAfterExit = true;
            EnvironmentFile = config.sops.secrets."pia/env".path;
            ExecStart = "${piaGen}/bin/pia-wg-gen";
          };
        };

        pia-portforward = {
          description = "Acquire PIA forwarded port";
          vpnConfinement = { enable = true; vpnNamespace = "wg"; };
          after = [ "wg.service" ];
          requires = [ "wg.service" ];
          before = [ "transmission.service" ];
          requiredBy = [ "transmission.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            EnvironmentFile = config.sops.secrets."pia/env".path;
            ExecStart = "${piaPortForward}/bin/pia-portforward";
          };
        };

        pia-pf-refresh = {
          vpnConfinement = { enable = true; vpnNamespace = "wg"; };
          after = [ "pia-portforward.service" ];
          requires = [ "pia-portforward.service" ];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${piaPfRefresh}/bin/pia-pf-refresh";
          };
        };
      };

      timers.pia-pf-refresh = {
        wantedBy = [ "timers.target" ];
        timerConfig = { OnBootSec = "5m"; OnUnitActiveSec = "15m"; };
      };

      tmpfiles.rules = [
        "d ${config.lv426.hoarding.downloadBaseDir}                 2775 root    hoarding - -"
        "d ${config.lv426.hoarding.downloadBaseDir}/Torrents   2775 sabnzbd hoarding - -"
      ];
    };

    ## Access with http://192.168.15.1:9091/transmission/web locally
    services.transmission = {
      enable = true;
      group = "hoarding";
      settings = {
        rpc-port = torrentRPCPort;
        rpc-bind-address = "0.0.0.0";
        rpc-whitelist = lib.concatStringsSep "," (map (n: n.glob) accessibleHosts ++ [ "192.168.15.5" ]);

        download-dir = "${config.lv426.hoarding.downloadBaseDir}/Torrents";
        incomplete-dir-enabled = false;
        
        download-queue-size = 5;
        
        speed-limit-down-enabled =  true;
        speed-limit-down = 2500;

        speed-limit-up-enabled = true;
        speed-limit-up = 25;
        
        peer-port-random-on-start = false;
        peer-port = 50000;

        alt-speed-enabled = false;
        alt-speed-down = 9000;
        alt-speed-time-begin = 60; # 1am
        alt-speed-time-day = 62; # weekdays
        alt-speed-time-enabled = true;
        alt-speed-time-end = 1020;
        alt-speed-up = 50;

        umask = 000;
      };
    };
  };
}