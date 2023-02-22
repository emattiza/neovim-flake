#!/usr/bin/env nix-shell
#!nix-shell -p skopeo -i bash
# shellcheck shell=bash
set -eu

nix run .#containers.copyTo -- "${IMAGE_URI:-docker://emattiza/neovim-flake:latest}"
