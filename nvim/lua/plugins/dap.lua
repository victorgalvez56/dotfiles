return {
  -- nvim-dap: core Debug Adapter Protocol client
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<leader>Db", function() require("dap").toggle_breakpoint() end,                         desc = "Toggle breakpoint" },
      { "<leader>DB", function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end, desc = "Conditional breakpoint" },
      { "<leader>Dl", function() require("dap").set_breakpoint(nil, nil, vim.fn.input("Log: ")) end, desc = "Logpoint" },
      { "<leader>Dc", function() require("dap").continue() end,                                  desc = "Continue / Start" },
      { "<leader>Dn", function() require("dap").step_over() end,                                 desc = "Step over" },
      { "<leader>Di", function() require("dap").step_into() end,                                 desc = "Step into" },
      { "<leader>Do", function() require("dap").step_out() end,                                  desc = "Step out" },
      { "<leader>Dr", function() require("dap").run_last() end,                                  desc = "Run last" },
      { "<leader>Dq", function() require("dap").terminate() end,                                 desc = "Terminate" },
      { "<leader>Du", function() require("dapui").toggle() end,                                  desc = "Toggle DAP UI" },
      { "<leader>De", function() require("dapui").eval() end,                                    desc = "Eval expression" },
      { "<leader>De", function() require("dapui").eval() end, mode = "v",                        desc = "Eval selection" },
      { "<leader>Dp", function() require("dap").repl.open() end,                                 desc = "Open REPL" },
    },
  },

  -- nvim-dap-ui: visual debugger panes
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dapui.setup({
        icons = { expanded = "", collapsed = "", current_frame = "" },
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "breakpoints", size = 0.20 },
              { id = "stacks",      size = 0.25 },
              { id = "watches",     size = 0.15 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            size = 12,
            position = "bottom",
          },
        },
        floating = { max_height = 0.9, max_width = 0.9, border = "rounded" },
      })

      -- Auto-open/close dapui with debug session
      dap.listeners.after.event_initialized["dapui_config"]  = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"]  = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"]      = function() dapui.close() end
    end,
  },

  { "nvim-neotest/nvim-nio" },

  -- mason-nvim-dap: auto-installs debug adapters
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = { "js" },
      automatic_setup = true,
      handlers = {
        js = function(config)
          require("mason-nvim-dap").default_setup(config)
          local dap = require("dap")
          local js_configs = {
            {
              type    = "pwa-node",
              request = "launch",
              name    = "Launch file (Node)",
              program = "${file}",
              cwd     = "${workspaceFolder}",
            },
            {
              type      = "pwa-node",
              request   = "attach",
              name      = "Attach to process",
              processId = require("dap.utils").pick_process,
              cwd       = "${workspaceFolder}",
            },
            {
              type            = "pwa-node",
              request         = "launch",
              name            = "Debug Jest test",
              runtimeExecutable = "node",
              runtimeArgs     = { "./node_modules/.bin/jest", "--runInBand", "--testTimeout=30000" },
              rootPath        = "${workspaceFolder}",
              cwd             = "${workspaceFolder}",
              console         = "integratedTerminal",
              internalConsoleOptions = "neverOpen",
            },
          }
          dap.configurations.javascript      = js_configs
          dap.configurations.typescript      = js_configs
          dap.configurations.typescriptreact = js_configs
          dap.configurations.javascriptreact = js_configs
        end,
      },
    },
  },
}
