{
  pkgs,
  inputs,
  plugins,
  ...
}: final: prev: let
  inherit (prev.vimUtils) buildVimPlugin;

  buildPlug = name:
    buildVimPlugin {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
    };
in {
  neovimPlugins =
    builtins.listToAttrs
    (map (name: {
        inherit name;
        value = buildPlug name;
      })
      plugins);
}
