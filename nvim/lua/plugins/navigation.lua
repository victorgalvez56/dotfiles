return {
  -- Fuzzy finder: files, grep, git commits, branches
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    keys = {
      { "<leader>f", "<cmd>Telescope find_files<CR>", desc = "Find files" },
      { "<leader>g", "<cmd>Telescope live_grep<CR>", desc = "Grep" },
      { "<leader>b", "<cmd>Telescope buffers<CR>", desc = "Buffers" },
      { "<leader>h", "<cmd>Telescope help_tags<CR>", desc = "Help" },
      { "<leader>o", "<cmd>Telescope oldfiles<CR>", desc = "Recent files" },
      -- Git
      { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Git commits" },
      { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "Git branches" },
      { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Git status" },
    },
    config = function()
      local telescope = require("telescope")
      telescope.setup({
        defaults = {
          layout_strategy = "horizontal",
          layout_config = { preview_width = 0.55 },
          file_ignore_patterns = { "node_modules", ".git/", "dist/", "build/" },
        },
      })
      telescope.load_extension("fzf")
    end,
  },

  -- File explorer: mini.files
  {
    "echasnovski/mini.files",
    version = false,
    keys = {
      { "-", function()
        local mf = require("mini.files")
        if not mf.close() then
          mf.open(vim.api.nvim_buf_get_name(0))
        end
      end, desc = "File explorer (current file)" },
      { "<leader>e", function()
        local mf = require("mini.files")
        if not mf.close() then
          mf.open(vim.uv.cwd())
        end
      end, desc = "File explorer (cwd)" },
    },
    opts = {
      mappings = {
        go_in = "l",
        go_in_plus = "L",
        go_out = "h",
        go_out_plus = "H",
        close = "q",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
      },
      windows = {
        preview = true,
        width_preview = 40,
      },
      options = {
        use_as_default_explorer = true,
      },
    },
  },
}
