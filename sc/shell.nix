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

  vim-floaterm = pkgs.vimUtils.buildVimPlugin {
    name = "vim-floaterm";
    src = pkgs.fetchFromGitHub {
      owner = "voldikss";
      repo = "vim-floaterm";
      rev = "0e3f28e2532a04b8aeeb77dde4648ed77f07fa4a";
      sha256 = "06gzmwxhy4vaqdwdszq00d3lc5c83align37dmqx5fpm03fhyafq";
    };
  };

  terminus = pkgs.vimUtils.buildVimPlugin {
    name = "terminus";
    src = pkgs.fetchFromGitHub {
      owner = "wincent";
      repo = "terminus";
      rev = "e47679a48852b12c6c150e006125f813ed9a81b1";
      sha256 = "00514pr5ds6v3qfsal84ma6hgsnq2ci20yk8pq0i00fx2k8v2pr9";
    };
  };

  context = pkgs.vimUtils.buildVimPlugin {
    name = "context";
    src = pkgs.fetchFromGitHub {
      owner = "wellle";
      repo = "context.vim";
      rev = "e38496f1eb5bb52b1022e5c1f694e9be61c3714c";
      sha256 = "1iy614py9qz4rwk9p4pr1ci0m1lvxil0xiv3ymqzhqrw5l55n346";
    };
  };

  # neovim_for_supercollider = unstable.neovim.override {
  neovim_for_supercollider = pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = builtins.readFile ../.vimrc;
      packages.myVimPackage = with unstable.vimPlugins; {
        start = [
          scnvim

          luasnip
          nvim-cmp
          nvim-lspconfig
          cmp-nvim-lsp
          cmp_luasnip
          cmp-git
          cmp-nvim-tags
          cmp-treesitter

          # nvim-treesitter
          (nvim-treesitter.withPlugins (
            plugins: with plugins; [
              nix
              python
              supercollider
              lua
              rust
            ]
          ))
          onedarkpro-nvim
          onedark-nvim

          context

          vim-floaterm # floating term
          terminus # improve terminal support

          # Base vim plugins from tpope
          vim-commentary
          vim-repeat
          vim-unimpaired
          vim-surround
          vim-sneak

          lightline-vim   # status bar
          vim-nix         # nix-shell file support
          gitgutter       # show changes in gutter
          fzfWrapper      # fzf
          fzf-vim         # common commands bound to fzf
          lexima-vim      # paren/quotes wrapping, TODO: look for replacement?
          fugitive        # Git stuff
          colorsamplerpack # all the colors
          vim-which-key   # menu for <leader> commands
          ranger-vim      # ranger in vim
          neoterm         # manage terminals
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

      # supercollider
    ];
  }
