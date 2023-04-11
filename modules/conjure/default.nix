{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.vim.conjure;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
in
  with lib; {
    options = {
      vim = {
        conjure = {
          enable = mkEnableOption "enable Conjure";
        };
      };
    };
    config = mkIf (cfg.enable) {
      vim.startPlugins = with pkgs.neovimPlugins; [
        conjure
      ];
      vim.luaConfigRC = ''
      '';
    };
  }
