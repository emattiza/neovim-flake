{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./coverage.nix
    ./neotest.nix
  ];
}
