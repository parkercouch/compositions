with import <nixpkgs> {};

let
  moz_overlay = import (builtins.fetchTarball https://github.com/mozilla/nixpkgs-mozilla/archive/master.tar.gz);
  nixpkgs = import <nixpkgs> { overlays = [ moz_overlay ]; };
  unstable = import <nixpkgs-unstable> { overlays = [moz_overlay ]; };

  # rustnightly = ((nixpkgs.rustChannelOf { date = "2020-01-18"; channel = "nightly"; }).rust.override {
  #   extensions = rust_extensions;
  #   targets = rust_targets;
  # });

  # Define the version of Rust we want to use + any extensions/components
  ruststable = ((nixpkgs.rustChannelOf { channel = "1.52.1"; }).rust.override {
    extensions = rust_extensions;
    targets = rust_targets;
  });

  rust_extensions = [
      "rust-src"
      "rust-analysis"
      "rustfmt-preview"
      "rust-std"
      "clippy-preview"
      # "rls-preview"
      # "miri-preview"
  ];

  rust_targets = [
    "wasm32-unknown-unknown"
    "x86_64-unknown-linux-gnu"
    # "x86_64-unknown-linux-musl"
    # "x86_64-apple-darwin"
  ];

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


  neovim_for_rust = pkgs.neovim.override {
    vimAlias = true;
    configure = {
      customRC = builtins.readFile .vim/vimrc;
      packages.myVimPackage = with unstable.vimPlugins; {
        start = [
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
          rust-vim        # basic rust support
          typescript-vim  # basic typescript support
          fzfWrapper      # fzf
          fzf-vim         # common commands bound to fzf
          lexima-vim      # paren/quotes wrapping, TODO: look for replacement?
          fugitive        # Git stuff
          coc-nvim        # LSP
          coc-fzf         # use fzf for coclist
          colorsamplerpack # all the colors
          vim-which-key   # menu for <leader> commands
          # TODO: use base config to speed up load
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
  with nixpkgs;
  llvmPackages_10.stdenv.mkDerivation {
    name = "rust_with_vim";

    buildInputs = [ 
      ruststable
      # rustnightly

      cargo-watch

      rustup

      neovim_for_rust
      neovim-remote

      cargo-audit

      # Compiled assets caching
      # sccache

      # For WASM
      # nodejs-12_x
      # wasm-pack
      # nodePackages.prettier
      # nodePackages.eslint

      dbus
      # dbus_libs

      # ncurses


      # jdk8

      # For compiling C dependencies
      # llvmPackages_10.libclang
      # binutils
      # gcc
      # gnumake
      # cmake
      pkgconfig
      pkg-config

      # DB stuff
      # libmysqlclient
      # mysql
      # mysql-client
      # python
      # cppdb
      # sqlite

      # Libs that are needed for some builds
      # zlib
      # zstd
      openssl 
    ];

    # Environment Variables
    LIBCLANG_PATH="${llvmPackages_10.libclang}/lib";

    # Needed to use paths in the Cargo.toml
    NIX_ENFORCE_PURITY=0;

    # RUST_BACKTRACE = 1;
    # RUST_FAILURE_BACKTRACE=1;
  }
