{
  pkgs,
  inputs,
  plugins,
  npins,
  ...
}: {
  neovimBuilder = import ./neovimBuilder.nix {inherit pkgs;};

  buildPluginOverlay = import ./buildPlugin.nix {
    inherit pkgs plugins;
    inputs = inputs // npins;
  };
}
