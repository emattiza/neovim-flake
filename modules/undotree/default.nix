{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.undotree;
in {
  options.vim.undotree = {
    enable = mkEnableOption "enable undotree";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      undotree
    ];
    vim.nnoremap = {
      "<leader>u" = "<cmd> UndotreeToggle<CR>";
    };
  };
}
