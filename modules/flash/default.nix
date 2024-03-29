{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.flash;
in {
  options.vim.flash = {
    enable = mkOption {
      type = types.bool;
      description = "Adds flash.nvim for easier label navigation";
    };
  };

  config =
    mkIf cfg.enable
    {
      vim.startPlugins = with pkgs.neovimPlugins; [
        flash-nvim
      ];
      vim.luaConfigRC =
        /*
        lua
        */
        ''
          wk.register({
            ["<leader>s"] = {
              s = {
                "<cmd>lua require(\"flash\").jump()<CR>",
                "Flash"
              },
              S = {
                "<cmd>lua require(\"flash\").treesitter()<CR>",
                "Flash Treesitter"
              }
            }
          })
        '';
    };
}
