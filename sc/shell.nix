let
  pkgs = import <nixpkgs> {};
  unstable = import <nixpkgs-unstable> {};

  scnvim = pkgs.vimUtils.buildVimPlugin {
    name = "scnvim";
    src = pkgs.fetchFromGitHub {
      owner = "davidgranstrom";
      repo = "scnvim";
      rev = "67eb22f5d913f6b8096427a0810a3ebc51156a74";
      hash = "sha256-FtGcW5CjYIW7717z3q+RC55k6cUEA0w6VSqvJSXgKrM=";
    };
    buildInputs = with pkgs; [ stylua lua53Packages.luacheck ];
  };

  # todo: update build so scnvim can access
  fzf-sc = pkgs.vimUtils.buildVimPlugin {
    name = "fzf-sc";
    src = pkgs.fetchFromGitHub {
      owner = "madskjeldgaard";
      repo = "fzf-sc";
      rev = "33859f2b419e74a84e5edca8741a84f6d5dc9f49";
      hash = "sha256-K2zWLnUYwgG3pMWffu7Hq66XMAV5lXDHYCFpsNSdkvA=";
    };
  };

  neovim_for_supercollider = unstable.neovim.override {
    vimAlias = true;
    configure = {
      customRC = ''
        ${builtins.readFile ../.vimrc}
        lua <<EOF
        ${builtins.readFile ../.vimrc.lua}
        EOF
      '';
      packages.myVimPackage = with unstable.vimPlugins; {
        start = [
          fzf-sc                  # supercollider fzf source
          scnvim                  # supercollider frontend
          luasnip                 # lua programmable snippets

          vim-commentary          # add/remove comments
          vim-repeat              # more commands are . repeatable
          vim-unimpaired          # extra keybindings
          vim-surround            # '' "" () []
          vim-sneak               # jump to 2 character
          nvim-treesitter-context # show current f(x) context
          vim-floaterm            # floating term
          terminus                # improve terminal support
          lualine-nvim            # status bar
          vim-nix                 # nix-shell file support
          gitgutter               # show changes in gutter
          fzfWrapper              # fzf
          fzf-vim                 # common commands bound to fzf
          lexima-vim              # paren/quotes wrapping, TODO: look for replacement?
          fugitive                # Git stuff
          which-key-nvim          # menu for <leader> commands
          ranger-vim              # ranger in vim

          nvim-cmp                # autocomplete
          nvim-lspconfig          # quick lsp configs
          # cmp sources
          cmp-nvim-lsp
          cmp_luasnip
          cmp-git
          cmp-nvim-tags
          cmp-treesitter

          # nvim-treesitter for better syntax
          (nvim-treesitter.withPlugins (
            plugins: with plugins; [
              nix
              python
              supercollider
              lua
              rust
            ]
          ))

          # color schemes
          onedarkpro-nvim
          onedark-nvim
        ];
        opt = [
          # add optionally loaded packages
        ];
      };
    };
  };
in
  with pkgs;
  stdenv.mkDerivation {
    name = "supercollider_with_vim";

    buildInputs = [ 
      neovim_for_supercollider

      pandoc # to convert sc help files to plain text

      python38
      python38Packages.msgpack

      sumneko-lua-language-server
      nil # nix language server
      nodePackages_latest.vim-language-server

      # supercollider
    ];
  }
