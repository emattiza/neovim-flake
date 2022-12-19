{
  description = "Jordan's Neovim Configuration";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    neovimUnwrapped = {
      url = "github:neovim/neovim/v0.8.1?dir=contrib";
    };

    # LSP plugins
    nvim-lspconfig = {
      url = "github:neovim/nvim-lspconfig?ref=master";
      flake = false;
    };
    nvim-treesitter = {
      url = "github:nvim-treesitter/nvim-treesitter";
      flake = false;
    };
    lspsaga = {
      url = "github:tami5/lspsaga.nvim";
      flake = false;
    };
    lspkind = {
      url = "github:onsails/lspkind-nvim";
      flake = false;
    };
    trouble = {
      url = "github:folke/trouble.nvim";
      flake = false;
    };
    nvim-treesitter-context = {
      url = "github:lewis6991/nvim-treesitter-context";
      flake = false;
    };
    nvim-treesitter-playground = {
      url = "github:nvim-treesitter/playground";
      flake = false;
    };
    nvim-lightbulb = {
      url = "github:kosayoda/nvim-lightbulb";
      flake = false;
    };

    nvim-code-action-menu = {
      url = "github:weilbith/nvim-code-action-menu";
      flake = false;
    };
    lsp-signature = {
      url = "github:ray-x/lsp_signature.nvim";
      flake = false;
    };
    null-ls = {
      url = "github:jose-elias-alvarez/null-ls.nvim";
      flake = false;
    };
    sqls-nvim = {
      url = "github:nanotee/sqls.nvim";
      flake = false;
    };
    rust-tools = {
      url = "github:simrat39/rust-tools.nvim";
      flake = false;
    };

    vim-terraform = {
      url = "github:hashivim/vim-terraform";
      flake = false;
    };

    # Copying/Registers
    registers = {
      url = "github:tversteeg/registers.nvim";
      flake = false;
    };
    nvim-neoclip = {
      url = "github:AckslD/nvim-neoclip.lua";
      flake = false;
    };

    # Telescope
    telescope = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };

    # Langauge server (use master instead of nixpkgs)
    rnix-lsp.url = "github:nix-community/rnix-lsp";

    # Filetrees
    nvim-tree-lua = {
      url = "github:kyazdani42/nvim-tree.lua";
      flake = false;
    };

    # Tablines
    nvim-bufferline-lua = {
      url = "github:akinsho/nvim-bufferline.lua?ref=v3.1.0";
      flake = false;
    };

    # Statuslines
    lualine = {
      url = "github:hoob3rt/lualine.nvim";
      flake = false;
    };

    # Autocompletes
    nvim-compe = {
      url = "github:hrsh7th/nvim-compe";
      flake = false;
    };
    nvim-cmp = {
      url = "github:hrsh7th/nvim-cmp";
      flake = false;
    };
    cmp-buffer = {
      url = "github:hrsh7th/cmp-buffer";
      flake = false;
    };
    cmp-nvim-lsp = {
      url = "github:hrsh7th/cmp-nvim-lsp";
      flake = false;
    };
    cmp-vsnip = {
      url = "github:hrsh7th/cmp-vsnip";
      flake = false;
    };
    cmp-path = {
      url = "github:hrsh7th/cmp-path";
      flake = false;
    };
    cmp-treesitter = {
      url = "github:ray-x/cmp-treesitter";
      flake = false;
    };

    # snippets
    vim-vsnip = {
      url = "github:hrsh7th/vim-vsnip";
      flake = false;
    };

    # Autopairs
    nvim-autopairs = {
      url = "github:windwp/nvim-autopairs";
      flake = false;
    };
    nvim-ts-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };

    # Commenting
    kommentary = {
      url = "github:b3nj5m1n/kommentary";
      flake = false;
    };
    todo-comments = {
      url = "github:folke/todo-comments.nvim";
      flake = false;
    };

    # Buffer tools
    bufdelete-nvim = {
      url = "github:famiu/bufdelete.nvim";
      flake = false;
    };

    # Themes
    tokyonight = {
      url = "github:folke/tokyonight.nvim";
      flake = false;
    };

    onedark = {
      url = "github:navarasu/onedark.nvim";
      flake = false;
    };

    nightfox = {
      url = "github:EdenEast/nightfox.nvim";
      flake = false;
    };

    # Rust crates
    crates-nvim = {
      url = "github:Saecki/crates.nvim";
      flake = false;
    };

    # Visuals
    nvim-cursorline = {
      url = "github:yamatsum/nvim-cursorline";
      flake = false;
    };
    indent-blankline = {
      url = "github:lukas-reineke/indent-blankline.nvim";
      flake = false;
    };
    nvim-web-devicons = {
      url = "github:kyazdani42/nvim-web-devicons";
      flake = false;
    };
    gitsigns-nvim = {
      url = "github:lewis6991/gitsigns.nvim";
      flake = false;
    };

    # Key binding help
    which-key = {
      url = "github:folke/which-key.nvim";
      flake = false;
    };

    # Markdown
    glow-nvim = {
      url = "github:ellisonleao/glow.nvim";
      flake = false;
    };

    # Plenary (required by crates-nvim)
    plenary-nvim = {
      url = "github:nvim-lua/plenary.nvim";
      flake = false;
    };

    undotree = {
      url = "github:mbbill/undotree";
      flake = false;
    };

    nvim-coverage = {
      url = "github:andythigpen/nvim-coverage";
      flake = false;
    };
    nvim-neotest = {
      url = "github:nvim-neotest/neotest";
      flake = false;
    };
    neotest-python = {
      url = "github:nvim-neotest/neotest-python";
      flake = false;
    };
  };

  outputs = {
    nixpkgs,
    flake-utils,
    neovimUnwrapped,
    ...
  } @ inputs:
    flake-utils.lib.eachDefaultSystem (system: let
      # Plugin must be same as input name
      plugins = [
        "nvim-treesitter-context"
        "nvim-treesitter-playground"
        "gitsigns-nvim"
        "plenary-nvim"
        "nvim-lspconfig"
        "nvim-treesitter"
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
        "undotree"
        "nvim-coverage"
        "nvim-neotest"
        "neotest-python"
      ];

      pluginOverlay = lib.buildPluginOverlay;

      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        overlays = [
          neovimUnwrapped.overlay
          pluginOverlay
          (final: prev: {
            rnix-lsp = inputs.rnix-lsp.defaultPackage.${system};
          })
        ];
      };

      lib =
        import
        ./lib
        {inherit pkgs inputs plugins;};

      neovimBuilder = lib.neovimBuilder;
      baseConfig = {
        vim.viAlias = false;
        vim.vimAlias = true;
        vim.lsp = {
          enable = true;
          formatOnSave = true;
          lightbulb.enable = true;
          lspsaga.enable = true;
          nvimCodeActionMenu.enable = true;
          trouble.enable = true;
          lspSignature.enable = true;
          rust.enable = false;
          nix = false;
          python = false;
          shell = false;
          terraform = false;
          clang = false;
          sql = false;
          ts = false;
          deno = false;
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
        };
        vim.statusline.lualine = {
          enable = true;
          theme = "jellybeans";
        };
        vim.theme = {
          enable = true;
          name = "nightfox";
          style = "terafox";
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
        buildInputs = [packages.neovimEM];
      };

      overlays.default = final: prev: {
        inherit neovimBuilder;
        neovimEM = packages.neovimEM;
        neovimPlugins = pkgs.neovimPlugins;
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
                clang = true;
                sql = true;
                ts = true;
                deno = true;
                elm = true;
                go = true;
                hare = false;
              };
            };
        };
      };
    });
}
