return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts_extend = { "spec" },
  opts = {
    preset = "classic",
    triggers = {
      { "<auto>", mode = "nxso" },
      { "<leader>", mode = "nv" },
      { "<localleader>", mode = "nv" },
    },
    spec = {
      { "<leader><leader>", group = "Hop / Quick Actions", mode = "nv" },
      { "<leader>b", group = "Buffers" },
      { "<leader>c", desc = "Delete Buffer" },
      { "<leader>d", group = "Duck / Debug" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>h", desc = "Clear Search Highlight" },
      { "<leader>l", group = "LSP" },
      { "<leader>L", group = "LeetCode" },
      { "<leader>p", group = "Python" },
      { "<leader>q", group = "Quit / Session" },
      { "<leader>r", group = "Run" },
      { "<leader>s", group = "Search" },
      { "<leader>t", group = "Terminal / Tabs" },
      { "<leader>u", group = "UI" },
      { "<leader>v", desc = "Close Current Buffer" },
      { "<leader>w", desc = "Save Current File" },
      { "<leader>x", group = "Diagnostics" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
  end,
}
