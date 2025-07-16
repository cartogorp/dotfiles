return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    defaults = {
      hidden = true,
      file_ignore_patterns = {
        "%.git/",
        "node_modules",
        "%.cache",
        "__pycache__",
      },
    },
    pickers = {
      find_files = {
        hidden = true,
      },
      live_grep = {
        hidden = true,
      },
    },
  },
}
