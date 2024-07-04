{
  description = "Evan's Neovim Configuration";
  nixConfig = {
    extra-substituters = "https://emattiza.cachix.org";
    extra-trusted-public-keys = "emattiza.cachix.org-1:DngCwMkBckEJbfnPU2/a01IgIczF1NmWmbNX4qoZK6w=";
  };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nix2container.url = "github:nlewo/nix2container";
    nixd.url = "github:nix-community/nixd/2.2.2";

    neovimUnwrapped = {
      url = "github:nix-community/neovim-nightly-overlay";
    };

    # LSP plugins
    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";
  };

  outputs = {
    nixpkgs,
    flake-utils,
    neovimUnwrapped,
    nixd,
    nix2container,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      npins = import ./npins;
      # Plugin must be same as input name
      plugins = [
        "nvim-treesitter-context"
        "nvim-treesitter-playground"
        "gitsigns-nvim"
        "fugitive"
        "plenary-nvim"
        "nvim-lspconfig"
        "lspsaga"
        "lspkind"
        "nvim-lightbulb"
        "lsp-signature"
        "nvim-tree-lua"
        "nvim-bufferline-lua"
        "lualine"
        "nvim-compe"
        "nvim-autopairs"
        "nvim-ts-autotag"
        "nvim-web-devicons"
        "tokyonight"
        "bufdelete-nvim"
        "nvim-cmp"
        "cmp-nvim-lsp"
        "cmp-buffer"
        "cmp-vsnip"
        "cmp-path"
        "cmp-treesitter"
        "crates-nvim"
        "vim-vsnip"
        "nvim-code-action-menu"
        "trouble"
        "null-ls"
        "which-key"
        "indent-blankline"
        "nvim-cursorline"
        "sqls-nvim"
        "glow-nvim"
        "telescope"
        "rust-tools"
        "onedark"
        "nightfox"
        "vim-terraform"
        "vim-jinja2-syntax"
        "undotree"
        "nvim-coverage"
        "neotest"
        "neotest-python"
        "purescript-vim"
        "dhall-vim"
        "cellular-automaton"
        "flash-nvim"
      ];

      pluginOverlay = lib.buildPluginOverlay;

      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          neovimUnwrapped.overlays.default
          nixd.overlays.default
          pluginOverlay
          (final: prev: {
            rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
          })
        ];
      };

      nix2containerPkgs = nix2container.packages.${system};

      lib =
        import
        ./lib
        {inherit pkgs inputs npins plugins;};

      neovimBuilder = lib.neovimBuilder;
      baseConfig = {
        vim.viAlias = false;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
          formatOnSave = true;
          lightbulb.enable = true;
          lspsaga.enable = false;
          nvimCodeActionMenu.enable = true;
          trouble.enable = true;
          lspSignature.enable = true;
          rust.enable = false;
          nix = false;
          python = false;
          shell = false;
          terraform = false;
          jinja = false;
          clang = false;
          sql = false;
          ts = false;
          deno = false;
          purescript = false;
          elm = false;
          go = false;
          hare = false;
        };
        vim.visuals = {
          enable = true;
          nvimWebDevicons.enable = true;
          lspkind.enable = true;
          indentBlankline = {
            enable = true;
            fillChar = "";
            eolChar = "";
            showCurrContext = true;
          };
          cursorWordline = {
            enable = true;
            lineTimeout = 0;
          };
          cellular-automaton = {
            enable = true;
          };
        };
        vim.statusline.lualine = {
          enable = true;
          theme = "jellybeans";
        };
        vim.theme = {
          enable = true;
          name = "nightfox";
          style = "terafox";
          transparent = true;
        };
        vim.autopairs.enable = true;
        vim.autocomplete = {
          enable = true;
          type = "nvim-cmp";
        };
        vim.filetree.nvimTreeLua.enable = true;
        vim.tabline.nvimBufferline.enable = true;
        vim.treesitter = {
          enable = true;
          autotagHtml = true;
          context.enable = true;
          playground.enable = true;
        };
        vim.keys = {
          enable = true;
          whichKey.enable = true;
        };
        vim.telescope = {
          enable = true;
        };
        vim.undotree = {
          enable = true;
        };
        vim.markdown = {
          enable = true;
          glow.enable = true;
        };
        vim.git = {
          enable = true;
          gitsigns.enable = true;
        };
        vim.testing = {
          enable = true;
          coverage.enable = true;
        };
        vim.flash = {
          enable = true;
        };
      };
    in rec {
      apps = rec {
        nvim = {
          type = "app";
          program = "${packages.default}/bin/nvim";
        };

        default = nvim;
      };

      devShells.default = pkgs.mkShell {
        buildInputs = [packages.neovimEM pkgs.npins];
      };

      overlays.default = final: prev: {
        inherit neovimBuilder;
        neovimEM = packages.neovimEM;
        neovimPlugins = pkgs.neovimPlugins ++ pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      };

      packages = rec {
        default = neovimEM;
        neovimPython = neovimBuilder {
          config =
            pkgs.lib.recursiveUpdate
            baseConfig
            {
              vim.lsp = {
                python = true;
                shell = true;
              };
            };
        };
        neovimLofty = neovimBuilder {
          config =
            pkgs.lib.recursiveUpdate
            baseConfig
            {
              vim.lsp = {
                python = true;
                shell = true;
                ts = true;
                sql = true;
              };
            };
        };
        neovimLoftyInfra = neovimBuilder {
          config =
            pkgs.lib.recursiveUpdate
            baseConfig
            {
              vim.lsp = {
                python = true;
                ts = true;
                sql = true;
                terraform = true;
                nix = true;
                shell = true;
              };
            };
        };
        neovimRust = neovimBuilder {
          config =
            pkgs.lib.recursiveUpdate
            baseConfig
            {
              vim.lsp = {
                rust.enable = true;
                nix = true;
                shell = true;
              };
            };
        };
        neovimEM = neovimBuilder {
          config =
            pkgs.lib.recursiveUpdate
            baseConfig
            {
              vim.lsp = {
                enable = true;
                formatOnSave = true;
                lightbulb.enable = true;
                lspsaga.enable = true;
                nvimCodeActionMenu.enable = true;
                trouble.enable = true;
                lspSignature.enable = true;
                rust.enable = true;
                nix = true;
                python = true;
                shell = true;
                terraform = true;
                jinja = true;
                clang = true;
                sql = true;
                ts = true;
                purescript = true;
                dhall = true;
                deno = true;
                elm = true;
                go = true;
                hare = false;
              };
            };
        };
        containers = nix2containerPkgs.nix2container.buildImage {
          name = "neovim";
          tag = "latest";
          copyToRoot = pkgs.buildEnv {
            name = "neovim-root";
            paths = [pkgs.gitFull packages.neovimEM];
            pathsToLink = ["/bin"];
          };
          config = {
            Cmd = ["${packages.neovimEM}/bin/nvim"];
          };
        };
      };
    });
}
