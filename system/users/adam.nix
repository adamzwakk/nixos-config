{ pkgs, config, lib, ... }: {
  users.users.adam = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "kvm" ]
      ++ lib.optionals config.networking.networkmanager.enable [
        "networkmanager"
      ]
      ++ lib.optionals config.programs.adb.enable [
        "adbusers"
      ]
      ++ lib.optionals config.virtualisation.docker.enable [
        "docker"
      ];
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      builtins.readFile ../keys/id_zwakktower.pub
    ];
  };
}
