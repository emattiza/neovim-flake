{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.treesitter;
in {
  options.vim.treesitter.playground.enable = mkOption {
    type = types.bool;
    description = "enable treesitter playground";
  };

  config = mkIf (cfg.enable && cfg.playground.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-treesitter-playground
    ];
    vim.nnoremap = {
      "<leader>sp" = "<cmd> TSPlaygroundToggle<CR>";
    };
    vim.luaConfigRC = ''
        require "nvim-treesitter.configs".setup {
          playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
              toggle_query_editor = 'o',
              toggle_hl_groups = 'i',
              toggle_injected_languages = 't',
              toggle_anonymous_nodes = 'a',
              toggle_language_display = 'I',
              focus_language = 'f',
              unfocus_language = 'F',
              update = 'R',
              goto_node = '<cr>',
              show_help = '?',
            },
          }
      }
    '';
  };
}
