{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.theme;
  writeIf = cond: msg:
    if cond
    then msg
    else "";
in {
  options.vim.theme = {
    enable = mkOption {
      type = types.bool;
      description = "Enable Theme";
    };

    name = mkOption {
      type = types.enum ["onedark" "tokyonight" "jellybeans" "nightfox"];
      description = ''Name of theme to use: "onedark" "tokyonight" "jellybeans" "nightfox"'';
    };

    style = mkOption {
      type = with types; (
        if (cfg.name == "tokyonight")
        then (enum ["day" "night" "storm"])
        else if (cfg.name == "onedark")
        then (enum ["dark" "darker" "cool" "deep" "warm" "warmer"])
        else if (cfg.name == "nightfox")
        then (enum ["nightfox" "dayfox" "dawnfox" "duskfox" "nordfox" "terafox" "carbonfox"])
        else (enum [])
      );
      description = ''Theme style: "storm", darker variant "night", and "day"'';
    };
  };

  config =
    mkIf cfg.enable
    (
      let
        mkVimBool = val:
          if val
          then "1"
          else "0";
      in {
        vim.configRC = mkIf (cfg.name == "tokyonight") ''
          " need to set style before colorscheme to apply
          let g:${cfg.name}_style = "${cfg.style}"
          colorscheme ${cfg.name}
        '';

        vim.startPlugins = with pkgs.neovimPlugins;
          if (cfg.name == "tokyonight")
          then [tokyonight]
          else if (cfg.name == "nightfox")
          then [nightfox]
          else [onedark];

        vim.luaConfigRC = ''
          ${writeIf (cfg.name == "onedark") ''
            -- OneDark theme
            require('onedark').setup {
              style = "${cfg.style}"
            }
            require('onedark').load()
          ''}
          ${writeIf (cfg.name == "nightfox") ''
            -- Nightfox theme
            require('nightfox').setup({
            })
            vim.cmd("colorscheme ${cfg.style}")
          ''}
        '';
      }
    );
}
