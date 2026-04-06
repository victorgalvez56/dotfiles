return {
  -- Mason: installs and manages LSP servers, formatters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {
      ui = {
        icons = {
          package_installed = "",
          package_pending = "",
          package_uninstalled = "",
        },
      },
    },
  },

  -- mason-tool-installer: auto-installs formatters (prettier, black)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "prettier", "black" },
      auto_update = false,
      run_on_start = true,
    },
  },

  -- mason-lspconfig: bridges mason and nvim-lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = { "ts_ls", "lua_ls", "pyright" },
      automatic_installation = false,
    },
  },

  -- nvim-lspconfig: configures LSP servers (nvim 0.11 API)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Shared on_attach keymaps
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
        callback = function(event)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, desc = desc })
          end

          -- Navigation
          map("n", "gd",          vim.lsp.buf.definition,     "Go to definition")
          map("n", "gD",          vim.lsp.buf.declaration,    "Go to declaration")
          map("n", "gi",          vim.lsp.buf.implementation, "Go to implementation")
          map("n", "gr",          vim.lsp.buf.references,     "Go to references")
          map("n", "K",           vim.lsp.buf.hover,          "Hover docs")
          map("n", "<C-k>",       vim.lsp.buf.signature_help, "Signature help")

          -- Actions
          map("n", "<leader>lr",  vim.lsp.buf.rename,         "Rename symbol")
          map("n", "<leader>la",  vim.lsp.buf.code_action,    "Code action")
          map("v", "<leader>la",  vim.lsp.buf.code_action,    "Code action (visual)")
          map("n", "<leader>lf",  function()
            require("conform").format({ async = true, lsp_fallback = true })
          end, "Format file")

          -- Diagnostics
          map("n", "<leader>ld",  vim.diagnostic.open_float,  "Line diagnostics")
          map("n", "]d",          vim.diagnostic.goto_next,   "Next diagnostic")
          map("n", "[d",          vim.diagnostic.goto_prev,   "Prev diagnostic")
          map("n", "<leader>lq",  vim.diagnostic.setloclist,  "Diagnostics to loclist")

          -- Workspace
          map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder,    "Add workspace folder")
          map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("n", "<leader>lwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")
        end,
      })

      -- Diagnostic signs (Nerd Font icons)
      vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
          },
        },
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = "always" },
      })

      -- Configure servers using nvim 0.11 API
      vim.lsp.config("ts_ls", { capabilities = capabilities })
      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "openFilesOnly",
            },
          },
        },
      })
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = {
              checkThirdParty = false,
              library = { vim.env.VIMRUNTIME, "${3rd}/luv/library" },
            },
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      -- Swift (sourcekit-lsp — bundled with Xcode, not in mason)
      vim.lsp.config("sourcekit", {
        capabilities = capabilities,
        cmd = {
          "/Applications/Xcode.app/Contents/Developer/Toolchains/"
            .. "XcodeDefault.xctoolchain/usr/bin/sourcekit-lsp",
        },
        filetypes = { "swift", "objc", "objcpp" },
      })

      -- Enable all configured servers
      vim.lsp.enable({ "ts_ls", "lua_ls", "pyright", "sourcekit" })
    end,
  },

  -- nvim-cmp: completion engine
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp     = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion    = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          ["<C-b>"]     = cmp.mapping.scroll_docs(-4),
          ["<C-f>"]     = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"]     = cmp.mapping.abort(),
          ["<CR>"]      = cmp.mapping.confirm({ select = false }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
            else fallback() end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then luasnip.jump(-1)
            else fallback() end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp", priority = 1000 },
          { name = "luasnip",  priority = 750 },
          { name = "buffer",   priority = 500 },
          { name = "path",     priority = 250 },
        }),
        formatting = {
          format = function(entry, item)
            local labels = {
              nvim_lsp = "[LSP]",
              luasnip  = "[Snip]",
              buffer   = "[Buf]",
              path     = "[Path]",
            }
            item.menu = labels[entry.source.name]
            return item
          end,
        },
      })
    end,
  },

  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },
  { "L3MON4D3/LuaSnip", version = "v2.*", build = "make install_jsregexp" },
  { "saadparwaiz1/cmp_luasnip" },

  -- conform.nvim: formatter with format-on-save
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = {
        javascript      = { "prettier" },
        javascriptreact = { "prettier" },
        typescript      = { "prettier" },
        typescriptreact = { "prettier" },
        html            = { "prettier" },
        css             = { "prettier" },
        json            = { "prettier" },
        yaml            = { "prettier" },
        lua             = { "stylua" },
        python          = { "black" },
      },
      format_on_save = function(bufnr)
        if vim.b[bufnr].conform_disable then return end
        return { timeout_ms = 2000, lsp_fallback = true, async = true }
      end,
    },
  },
}
