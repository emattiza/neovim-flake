{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.visuals;
in {
  options.vim.visuals = {
    cellular-automaton = {
      enable = mkOption {
        type = types.bool;
        description = "some fun for your neovim";
      };
    };
  };

  config =
    mkIf cfg.enable
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        (
          if cfg.cellular-automaton.enable
          then cellular-automaton
          else null
        )
      ];
      vim.luaConfigRC = ''
        ${
          if cfg.cellular-automaton.enable
          then ''
            vim.keymap.set("n", "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>")
          ''
          else ""
        }
      '';
    };
}
