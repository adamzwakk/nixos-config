{
  options,
  config,
  lib,
  pkgs,
  namespace,
  flake-inputs,
  ...
}:
{
  imports = [ flake-inputs.nvf.homeManagerModules.default ];
    
  programs.nvf = {
      enable = true;

      settings = {
            vim = {

                options = {
                    shiftwidth = 4;
                    smarttab = true;
                };

                statusline.lualine.enable = true;
                viAlias = false;
                vimAlias = true;
                lsp.enable = true;

                languages = {
                    enableTreesitter = true;
                    nix.enable = true;
                    rust.enable = true;
                    python.enable = true;
                };
            };
      };
  };

  stylix.targets.nvf = {
      enable = true;
      transparentBackground.main = true;
  };

  home.sessionVariables.EDITOR = lib.mkForce "nvim";
}
