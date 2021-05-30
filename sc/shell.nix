let
  pkgs = import <nixpkgs> {};
  unstable = import <nixpkgs-unstable> {};

  scnvim = pkgs.vimUtils.buildVimPlugin {
    name = "scnvim";
    src = pkgs.fetchFromGitHub {
      owner = "davidgranstrom";
      repo = "scnvim";
      rev = "58416e80e225a4aa896886fd92b8c3580524210a";
      sha256 = "033dsi5cgy5w9sqyjan7sr37c0kbmisw51fq1vz8767r6z8jbv40";
      # experimental branch
      # rev = "5159f7edad91edd0647c1825fedb83d441d9790d";
      # sha256 = "193laxq1c8lil4hpa229r69fk7n8gxr9ajiyms37p1ql03lz6dcl";
    };
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
      customRC = builtins.readFile .vim/vimrc;
      packages.myVimPackage = with unstable.vimPlugins; {
        start = [
          scnvim
          ultisnips
          context
          deoplete-nvim

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

      # supercollider
    ];
  }
