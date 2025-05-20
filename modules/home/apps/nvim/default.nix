{
  options,
  config,
  lib,
  pkgs,
  namespace,
  ...
}:
with lib;
with lib.${namespace};
let
  cfg = config.${namespace}.apps.neovim;
in
{
  options.${namespace}.apps.neovim = with types; {
    enable = mkBoolOpt false "Enable Neovim";
  };

  config = mkIf cfg.enable { 
    programs.nixvim = {
      enable = true;
      
      globals = {
        mapleader = " ";
        maplocalleader = " ";
      };
      
      plugins = {
        barbar.enable = true; # top bar
        comment.enable = true; # Commenting
        colorizer.enable = true; # Automatic bg colors on hex/color strings
        gitsigns.enable = true;
        lint.enable = true;
        lualine.enable = true; # Fancier status line
        neo-tree.enable = true; # File tree
        nvim-autopairs.enable = true;
        telescope.enable = true; # Fuzzy finder
        toggleterm = { # Terminal access
          enable = true;
          settings = {
            direction = "horizontal";
          };
		    };
        transparent.enable = true;
        treesitter.enable = true;
        web-devicons.enable = true; # Fun icons
        which-key.enable = true;
      };

      opts =
        let
          indentsize = 4;
        in {
          number = true;
          relativenumber = true;

          shiftwidth = indentsize;
          softtabstop = indentsize;
          tabstop = indentsize;

          wrap = false;
      };

      keymaps =
      let
        normal =
          lib.mapAttrsToList
            (key: action: {
              mode = "n";
              inherit action key;
            })
            {
              "<Space>" = "<NOP>";

              # Esc to clear search results
              "<esc>" = ":noh<CR>";

              # fix Y behaviour
              Y = "y$";

              # back and fourth between the two most recent files
              "<C-c>" = ":b#<CR>";

              # close by Ctrl+x
              "<C-x>" = ":close<CR>";

              # save by Space+s or Ctrl+s
              "<leader>s" = ":w<CR>";
              "<C-s>" = ":w<CR>";

              # navigate to left/right window
              "<leader>h" = "<C-w>h";
              "<leader>l" = "<C-w>l";

              # Press 'H', 'L' to jump to start/end of a line (first/last character)
              L = "$";
              H = "^";

              # resize with arrows
              "<C-Up>" = ":resize -2<CR>";
              "<C-Down>" = ":resize +2<CR>";
              "<C-Left>" = ":vertical resize +2<CR>";
              "<C-Right>" = ":vertical resize -2<CR>";

              # move current line up/down
              # M = Alt key
              "<M-k>" = ":move-2<CR>";
              "<M-j>" = ":move+<CR>";

              "<leader><leader>" = ":Telescope buffers<CR>";
              "<leader>n" = ":Neotree action=focus reveal toggle<CR>";
			  "<leader>t" = ":ToggleTerm<CR>";
            };
        visual =
          lib.mapAttrsToList
            (key: action: {
              mode = "v";
              inherit action key;
            })
            {
              # better indenting
              ">" = ">gv";
			  "<" = "<gv";
			  "<TAB>" = ">gv";
              "<S-TAB>" = "<gv";

              # move selected line / block of text in visual mode
			  "K" = ":m '<-2<CR>gv=gv";
              "J" = ":m '>+1<CR>gv=gv";

              # sort
              "<leader>s" = ":sort<CR>";
            };
      in
      config.lib.nixvim.keymaps.mkKeymaps { options.silent = true; } (normal ++ visual);
    };

    stylix.targets.nixvim = {
      enable = true;
      transparentBackground.main = true;
    };

    home.sessionVariables.EDITOR = lib.mkForce "nvim";
  };
}
