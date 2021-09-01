{ pkgs, config, lib, ... }:
with lib;
with builtins;

let
  cfg = config.vim.filetree.nvimTreeLua;
in {
  options.vim.filetree.nvimTreeLua = {
    enable = mkEnableOption "Enable nvim-tree-lua";

    treeSide = mkOption {
      default = "left";
      description = "Side the tree will appear on left or right";
      type = types.enum ["left" "right"];
    };

    treeWidth = mkOption {
      default = 25;
      description = "Width of the tree in charecters";
      type = types.int;
    };

    hideFiles = mkOption {
      default = [ ".git" "node_modules" ".cache" ];
      description = "Files to hide in the file view by default.";
      type = with types; listOf str;
    };

    hideIgnoredGitFiles = mkOption {
      default = false;
      description = "Hide files ignored by git";
      type = types.bool;
    };

    openOnDirectoryStart = mkOption {
      default = true;
      description = "Open when vim is started on a directory";
      type = types.bool;
    };

    closeOnLastWindow = mkOption {
      default = true;
      description = "Close when tree is last window open";
      type = types.bool;
    };

    ignoreFileTypes = mkOption {
      default = [ ];
      description = "Ignore file types";
      type = with types; listOf str;
    };

    closeOnFileOpen = mkOption {
      default = false;
      description = "Close the tree when a file is opened";
      type = types.bool;
    };

    followBufferFile = mkOption {
      default = true;
      description = "Follow file that is in current buffer on tree";
      type = types.bool;
    };

    indentMarkers = mkOption {
      default = true;
      description = "Show indent markers";
      type = types.bool;
    };

    hideDotFiles = mkOption {
      default = false;
      description = "Hide dotfiles";
      type = types.bool;
    };

    openTreeOnNewTab = mkOption {
      default = false;
      description = "Opens the tree view when opening a new tab";
      type = types.bool;
    };

    disableNetRW = mkOption {
      default = true;
      description = "Disables netrw and replaces it with tree";
      type = types.bool;
    };

    hijackNetRW = mkOption {
      default = true;
      description = "Prevents netrw from automatically opening when opening directories";
      type = types.bool;
    };

    trailingSlash = mkOption {
      default = true;
      description = "Add a trailing slash to all folders";
      type = types.bool;
    };

    groupEmptyFolders = mkOption {
      default = true;
      description = "Compact empty folders trees into a single item";
      type = types.bool;
    };

    lspDiagnostics = mkOption {
      default = true;
      description = "Shows lsp diagnostics in the tree";
      type = types.bool;
    };
  };

  config = mkIf cfg.enable (
    let
      mkVimBool = val: if val then 1 else 0;
    in {
      vim.startPlugins = with pkgs.neovimPlugins; [
        (assert config.vim.icons.nvimWebDevicons == true; nvim-tree-lua)
      ];

      vim.nnoremap = {
        "<C-n>" = ":NvimTreeToggle<CR>";
        "<leader>r" = ":NvimTreeRefresh<CR>";
        "<leader>n" = ":NvimTreeFindFile<CR>";
      };

      vim.globals = {
        "nvim_tree_side" = cfg.treeSide;
        "nvim_tree_width" = cfg.treeWidth;
        "nvim_tree_ignore" = cfg.hideFiles;
        "nvim_tree_gitignore" = mkVimBool cfg.hideIgnoredGitFiles;
        "nvim_tree_auto_open" = mkVimBool cfg.openOnDirectoryStart;
        "nvim_tree_auto_close" = mkVimBool cfg.closeOnLastWindow;
        "nvim_tree_auto_ignore_ft" = cfg.ignoreFileTypes;
        "nvim_tree_quit_on_open" = mkVimBool cfg.closeOnFileOpen;
        "nvim_tree_follow" = mkVimBool cfg.followBufferFile;
        "nvim_tree_indent_markers" = mkVimBool cfg.indentMarkers;
        "nvim_tree_hide_dotfiles" = mkVimBool cfg.hideDotFiles;
        "nvim_tree_tab_open" = mkVimBool cfg.openTreeOnNewTab;
        "nvim_tree_disable_netrw" = mkVimBool cfg.disableNetRW;
        "nvim_tree_hijack_netrw" = mkVimBool cfg.hijackNetRW;
        "nvim_tree_add_trailing" = mkVimBool cfg.trailingSlash;
        "nvim_tree_group_empty" = mkVimBool cfg.groupEmptyFolders;
        "nvim_tree_lsp_diagnostics" = mkVimBool cfg.lspDiagnostics;
      };
    }
  );
}
