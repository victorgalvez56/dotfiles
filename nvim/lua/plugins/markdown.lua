return {
  -- Treesitter: syntax highlighting for all languages + markdown
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = "BufReadPost",
    opts = {
      ensure_installed = {
        "lua", "javascript", "typescript", "tsx", "json",
        "html", "css", "bash", "markdown", "markdown_inline",
        "yaml", "toml", "swift", "python",
      },
      highlight = { enable = true },
      indent = { enable = true },
    },
  },

  -- Render markdown inline: headings, checkboxes, links, code blocks
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },
    opts = {
      heading = {
        icons = { "# ", "## ", "### ", "#### ", "##### ", "###### " },
        sign = false,
      },
      checkbox = {
        unchecked = { icon = "☐ " },
        checked = { icon = "☑ " },
      },
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      pipe_table = { enabled = true },
    },
    keys = {
      { "<leader>mr", "<cmd>RenderMarkdown toggle<CR>", desc = "Toggle markdown render" },
    },
  },
}
