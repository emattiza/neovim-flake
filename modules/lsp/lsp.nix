{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
with builtins; let
  cfg = config.vim.lsp;
in {
  options.vim.lsp = {
    enable = mkEnableOption "neovim lsp support";
    formatOnSave = mkEnableOption "Format on save";
    nix = mkEnableOption "Nix LSP";
    rust = {
      enable = mkEnableOption "Rust LSP";
      rustAnalyzerOpts = mkOption {
        type = types.str;
        default = ''
          ["rust-analyzer"] = {
            experimental = {
              procAttrMacros = true,
            },
          },
        '';
        description = "options to pass to rust analyzer";
      };
    };
    shell = mkEnableOption "Shell LSP";
    terraform = mkEnableOption "Terraform LSP";
    python = mkEnableOption "Python LSP";
    clang = mkEnableOption "C language LSP";
    sql = mkEnableOption "SQL Language LSP";
    go = mkEnableOption "Go language LSP";
    ts = mkEnableOption "TS language LSP";
    deno = mkEnableOption "Deno LSP";
    purescript = mkEnableOption "Purescript LSP";
    dhall = mkEnableOption "Dhall LSP";
    hare = mkEnableOption "Hare plugin (not LSP)";
    elm = mkEnableOption "Elm LSP";
  };

  config = mkIf cfg.enable (
    let
      writeIf = cond: msg:
        if cond
        then msg
        else "";
    in {
      vim = {
        startPlugins = with pkgs.neovimPlugins;
          [
            (
              if (cfg.dhall)
              then dhall-vim
              else null
            )
            (
              if (cfg.purescript)
              then purescript-vim
              else null
            )
            nvim-lspconfig
            null-ls
            (
              if (config.vim.autocomplete.enable && (config.vim.autocomplete.type == "nvim-cmp"))
              then cmp-nvim-lsp
              else null
            )
            (
              if cfg.sql
              then sqls-nvim
              else null
            )
            (
              if cfg.terraform
              then vim-terraform
              else null
            )
          ]
          ++ (
            if cfg.rust.enable
            then [
              crates-nvim
              rust-tools
              (
                if cfg.hare
                then hare-vim
                else null
              )
            ]
            else []
          );

        configRC = ''
          ${
            if cfg.nix
            then ''
              autocmd filetype nix setlocal tabstop=2 shiftwidth=2 softtabstop=2
            ''
            else ""
          }

          ${
            if cfg.clang
            then ''
              " c syntax for header (otherwise breaks treesitter highlighting)
              " https://www.reddit.com/r/neovim/comments/orfpcd/question_does_the_c_parser_from_nvimtreesitter/
              let g:c_syntax_for_h = 1
            ''
            else ""
          }
        '';
        luaConfigRC = ''

          local attach_keymaps = function(client, bufnr)
            local opts = { noremap=true, silent=true }

            wk.register({
              ["<leader>l"] = {
                g = {
                  d = {
                    "<cmd>lua vim.lsp.buf.definition()<CR>",
                    "Go to Definition",
                  },
                  D = {
                    "<cmd>lua vim.lsp.buf.declaration()<CR>",
                    "Go to Declaration",
                  },
                  t = {
                    "<cmd>lua vim.lsp.buf.type_definition()<CR>",
                    "Go to Type Definition",
                  },
                  n = {
                    "<cmd>lua vim.diagnostic.goto_next()<CR>",
                    "Go to next"
                  },
                  p = {
                    "<cmd>lua vim.diagnostic.goto_prev()<CR>",
                    "Go to previous"
                  },
                },
                w = {
                  a = {
                    "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>",
                    "Add Workspace Folder"
                  },
                  r = {
                    "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
                    "Remove Workspace folder"
                  },
                  l = {
                    "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
                    "List Workspace folders"
                  }
                },
                h = {
                  "<cmd>lua vim.lsp.buf.hover()<CR>",
                  "Hover"
                },
                s = {
                  "<cmd>lua vim.lsp.buf.signature_help()<CR>",
                  "Signature"
                },
                n = {
                  "<cmd>lua vim.lsp.buf.rename()<CR>",
                  "Rename"
                },
              },
            }, {mode="n", noremap=true, silent=true, buffer=bufnr})
          end

          local null_ls = require("null-ls")
          local null_helpers = require("null-ls.helpers")
          local null_methods = require("null-ls.methods")

          local ls_sources = {
            ${writeIf cfg.shell
            ''
              null_ls.builtins.code_actions.shellcheck.with({
                command = "${pkgs.shellcheck}/bin/shellcheck",
              }),
              null_ls.builtins.diagnostics.shellcheck.with({
                command = "${pkgs.shellcheck}/bin/shellcheck",
              }),
            ''}
            ${writeIf cfg.python
            ''
              null_ls.builtins.formatting.black.with({
                command = "${pkgs.black}/bin/black",
              }),
            ''}
            -- Commented out for now
            --${writeIf (config.vim.git.enable && config.vim.git.gitsigns.enable) ''
            --  null_ls.builtins.code_actions.gitsigns,
            --''}
            ${writeIf cfg.sql
            ''
              null_helpers.make_builtin({
                method = null_methods.internal.FORMATTING,
                filetypes = { "sql" },
                generator_opts = {
                  to_stdin = true,
                  ignore_stderr = true,
                  suppress_errors = true,
                  command = "${pkgs.sqlfluff}/bin/sqlfluff",
                  args = {
                    "fix",
                    "-",
                  },
                },
                factory = null_helpers.formatter_factory,
              }),

              null_ls.builtins.diagnostics.sqlfluff.with({
                command = "${pkgs.sqlfluff}/bin/sqlfluff",
                extra_args = {"--dialect", "postgres"}
              }),
            ''}
            ${writeIf cfg.nix
            ''
              null_ls.builtins.formatting.alejandra.with({
                command = "${pkgs.alejandra}/bin/alejandra"
              }),
            ''}

            ${writeIf cfg.ts
            ''
              null_ls.builtins.diagnostics.eslint,
              null_ls.builtins.formatting.prettier,
            ''}
            ${
            writeIf cfg.elm
            ''
              null_ls.builtins.formatting.elm_format,
            ''
          }
          }

          vim.g.formatsave = ${
            if cfg.formatOnSave
            then "true"
            else "false"
          };

          -- Enable formatting
          format_callback = function(client, bufnr)
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = augroup,
              buffer = bufnr,
              callback = function()
                if vim.g.formatsave then
                    local params = require'vim.lsp.util'.make_formatting_params({})
                    client.request('textDocument/formatting', params, nil, bufnr)
                end
              end
            })
          end

          default_nofmt_on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
          end

          default_on_attach = function(client, bufnr)
            attach_keymaps(client, bufnr)
            format_callback(client, bufnr)
          end

          -- Enable null-ls
          require('null-ls').setup({
            diagnostics_format = "[#{m}] #{s} (#{c})",
            debounce = 250,
            default_timeout = 5000,
            sources = ls_sources,
            on_attach=default_on_attach
          })

          -- Enable lspconfig
          local lspconfig = require('lspconfig')

          local capabilities = vim.lsp.protocol.make_client_capabilities()

          ${let
            cfg = config.vim.autocomplete;
          in
            writeIf cfg.enable
            (
              if cfg.type == "nvim-compe"
              then ''
                vim.capabilities.textDocument.completion.completionItem.snippetSupport = true
                capabilities.textDocument.completion.completionItem.resolveSupport = {
                  properties = {
                    'documentation',
                    'detail',
                    'additionalTextEdits',
                  }
                }
              ''
              else ''
                capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
              ''
            )}

          ${writeIf cfg.rust.enable ''
            -- Rust config
            require('crates').setup {
              null_ls = {
                enabled = true,
                name = "crates.nvim",
              }
            }

            local rt = require('rust-tools')
            rust_on_attach = function(client, bufnr)
              default_on_attach(client, bufnr)
              local opts = { noremap=true, silent=true, buffer = bufnr }
              vim.keymap.set("n", "<leader>ris", rt.inlay_hints.set, opts)
              vim.keymap.set("n", "<leader>riu", rt.inlay_hints.unset, opts)
              vim.keymap.set("n", "<leader>rr", rt.runnables.runnables, opts)
              vim.keymap.set("n", "<leader>rp", rt.parent_module.parent_module, opts)
              vim.keymap.set("n", "<leader>rm", rt.expand_macro.expand_macro, opts)
              vim.keymap.set("n", "<leader>rc", rt.open_cargo_toml.open_cargo_toml, opts)
              vim.keymap.set("n", "<leader>rg", function() rt.crate_graph.view_crate_graph("x11", nil) end, opts)
            end
            local rustopts = {
              tools = {
                autoSetHints = false,
                hover_with_actions = false,
                inlay_hints = {
                  only_current_line = false,
                }
              },
              server = {
                capabilities = capabilities,
                on_attach = rust_on_attach,
              }
            }
            rt.setup(rustopts)
          ''}

          ${writeIf cfg.terraform ''
            -- Terraform config
            simple_format_callback = function(client, bufnr)
              vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                  if vim.g.formatsave then
                      vim.api.nvim_command("TerraformFmt")
                  end
                end
            })
            end
            lspconfig.terraform_lsp.setup{
              capabilities = capabilities;
              on_attach = function (client, bufnr)
                attach_keymaps(client, bufnr)
                simple_format_callback(client, bufnr)
              end;
            }
          ''}
          ${writeIf cfg.python ''
            -- Python config
            lspconfig.pyright.setup{
              capabilities = capabilities;
              on_attach= default_nofmt_on_attach;
              cmd = {"${pkgs.nodePackages.pyright}/bin/pyright-langserver", "--stdio"}
            }
          ''}

          ${writeIf cfg.nix ''
            -- Nix config
            lspconfig.nil_ls.setup{
              capabilities = capabilities;
              on_attach = function(client, bufnr)
                attach_keymaps(client, bufnr)
              end,
              cmd = {"${pkgs.nil}/bin/nil"}
            }
          ''}

          ${writeIf cfg.clang ''
            -- CCLS (clang) config
            lspconfig.ccls.setup{
              capabilities = capabilities;
              on_attach=default_on_attach;
            }
          ''}

          ${writeIf cfg.sql ''
            -- SQLS config
            lspconfig.sqls.setup {
              on_attach = function(client)
                client.server_capabilities.execute_command = true
                on_attach_keymaps(client, bufnr)
                require'sqls'.setup{}
              end,
            }
          ''}

          ${writeIf cfg.go ''
            -- Go config
            lspconfig.gopls.setup {
              capabilities = capabilities;
              on_attach = default_on_attach;
            }
          ''}

          ${writeIf cfg.ts ''
            -- TS config
            lspconfig.tsserver.setup {
              capabilities = capabilities;
              root_dir = lspconfig.util.root_pattern("package.json");
              on_attach = function(client, bufnr)
                attach_keymaps(client, bufnr)
              end,
            }
          ''}
          ${writeIf cfg.purescript ''
            -- Deno Config
            lspconfig.purescriptls.setup{
              capabilities = capabilities;
              on_attach = function(client, bufnr)
                attach_keymaps(client, bufnr)
              end,
            }
          ''}

          ${writeIf cfg.dhall ''
            -- Deno Config
            lspconfig.dhall_lsp_server.setup{
              capabilities = capabilities;
              on_attach = function(client, bufnr)
                attach_keymaps(client, bufnr)
              end,
            }
          ''}
          ${writeIf cfg.deno ''
            -- Deno Config
            lspconfig.denols.setup{
              capabilities = capabilities;
              root_dir = lspconfig.util.root_pattern("deno.jsonc");
              on_attach = function(client, bufnr)
                attach_keymaps(client, bufnr)
              end,
            }
          ''}
          ${writeIf cfg.elm ''
            -- Elm Config
            lspconfig.elmls.setup{
              capabilities = capabilities;
              on_attach = function(client, bufnr)
                attach_keymaps(client, bufnr)
              end,
            }
          ''}
        '';
      };
    }
  );
}
