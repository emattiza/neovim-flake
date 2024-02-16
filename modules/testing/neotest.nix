{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.testing;
  vcfg = config.vim;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
in {
  options.vim.testing = {
    enable = mkEnableOption "enable coverage";
  };

  config = mkIf (cfg.enable) {
    vim.startPlugins = with pkgs.neovimPlugins; [
      neotest
      neotest-python
    ];
    vim.nnoremap = {
      "<leader>ttr" = "<CR>";
    };
    vim.luaConfigRC = ''
      require("neotest").setup({
        adapters = {
      ${
        writeIf
        (vcfg.lsp.enable && vcfg.lsp.python)
        ''
          require("neotest-python")({}),
        ''
      }
        },
      })
    '';
  };
}
