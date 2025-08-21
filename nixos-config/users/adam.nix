{ pkgs, ... }: {
  users.users.adam = {
    initialPassword = "password";
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "kvm" "adbusers" ];
    shell = pkgs.bash;

    openssh.authorizedKeys.keys = [
      builtins.readFile ../keys/id_zwakktower.pub
    ];
  };
}
