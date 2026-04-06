return {
  -- Colorscheme: easy on the eyes
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      transparent_background = true,
      integrations = {
        cmp       = true,
        nvim_dap  = true,
        mason     = true,
        which_key = true,
      },
    },
    config = function(_, opts)
      require("catppuccin").setup(opts)
      vim.cmd.colorscheme("catppuccin")
    end,
  },

  -- Status line: minimal
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "catppuccin",
          section_separators = "",
          component_separators = "|",
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "location" },
          lualine_z = {},
        },
      })
      -- Suppress the nerd font notice on startup
      local notices = require("lualine.utils.notices")
      notices.clear_notices()
    end,
  },

  -- Indent guides
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {
      indent = { char = "│" },
      scope = { enabled = true },
    },
  },

  -- Color previews inline (#ff0000, rgb(), hsl())
  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    opts = {
      "*",
      css = { css = true },
      html = { css = true },
    },
  },

  -- Buffer tabs at the top
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
      options = {
        mode = "buffers",
        diagnostics = false,
        show_close_icon = false,
        show_buffer_close_icons = false,
        separator_style = "thin",
        offsets = {
          { filetype = "minifiles", text = "Explorer", text_align = "center" },
        },
      },
    },
  },

  -- Smooth scrolling
  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    opts = {
      easing = "quadratic",
      duration_multiplier = 0.5,
    },
  },

  -- Which-key: see available keymaps after pressing leader
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      delay = 300,
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.add({
        { "<leader>d",  group = "diff" },
        { "<leader>g",  group = "git" },
        { "<leader>h",  group = "hunks" },
        { "<leader>m",  group = "markdown" },
        { "<leader>l",  group = "lsp" },
        { "<leader>lw", group = "workspace" },
        { "<leader>D",  group = "debug" },
      })
    end,
  },

  -- Noice: better command line, messages, notifications
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {
      cmdline = { view = "cmdline_popup" },
      messages = { enabled = true },
      popupmenu = { enabled = true },
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },

  -- Todo comments highlighting
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "BufReadPost",
    opts = {},
    keys = {
      { "<leader>st", "<cmd>TodoTelescope<CR>", desc = "Search TODOs" },
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next TODO" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Prev TODO" },
    },
  },
}
