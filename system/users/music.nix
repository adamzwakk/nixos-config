{ pkgs, ... }: {
  users.users.music = {
    initialPassword = "music";
    isNormalUser = true;
    shell = pkgs.bash;
  };
}
