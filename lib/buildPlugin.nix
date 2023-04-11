{
  pkgs,
  inputs,
  plugins,
  ...
}: final: prev: let
  inherit (prev.vimUtils) buildVimPluginFrom2Nix;

  treesitterGrammars = prev.tree-sitter.withPlugins (p: [
    p.tree-sitter-dockerfile
    p.tree-sitter-janet-simple
    p.tree-sitter-bash
    p.tree-sitter-hcl
    p.tree-sitter-elm
    p.tree-sitter-dot
    p.tree-sitter-fennel
    p.tree-sitter-haskell
    p.tree-sitter-graphql
    p.tree-sitter-lua
    p.tree-sitter-vim
    p.tree-sitter-sql
    p.tree-sitter-go
    p.tree-sitter-gomod
    p.tree-sitter-c
    p.tree-sitter-nix
    p.tree-sitter-python
    p.tree-sitter-rust
    p.tree-sitter-markdown
    p.tree-sitter-comment
    p.tree-sitter-toml
    p.tree-sitter-make
    p.tree-sitter-tsx
    p.tree-sitter-html
    p.tree-sitter-javascript
    p.tree-sitter-typescript
    p.tree-sitter-css
    p.tree-sitter-graphql
    p.tree-sitter-json
    p.tree-sitter-vue
    p.tree-sitter-regex
    p.tree-sitter-yaml
  ]);

  buildPlug = name:
    buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      postPatch =
        if (name == "nvim-treesitter")
        then ''
          rm -r parser
          ln -s ${treesitterGrammars} parser
        ''
        else "";
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
