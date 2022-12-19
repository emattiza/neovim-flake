{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.testing;
in {
  options.vim.testing = {
    coverage = {
      enable = mkEnableOption "enable coverage";
    };
  };

  config = mkIf (cfg.enable && cfg.coverage.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      nvim-coverage
    ];
    vim.nnoremap = {
      "<leader>ttc" = "<cmd> Coverage<CR>";
      "<leader>tts" = "<cmd> CoverageShow<CR>";
      "<leader>tth" = "<cmd> CoverageHide<CR>";
    };
    vim.luaConfigRC = ''
      require("coverage").setup()
    '';
  };
}
