{ pkgs, config, lib, ... }: {
  users.users.adam = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "kvm" "adbusers" ]
    
    ++ lib.optionals networking.networkmanager.enable [
      "networkmanager"
    ]
    
    ++ lib.optionals programs.adb.enable [
      "adbusers"
    ];
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      builtins.readFile ../keys/id_zwakktower.pub
    ];
  };
}
