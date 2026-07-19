return {
  "nvim-neo-tree/neo-tree.nvim",
  enabled = true ,  -- 禁用 neo-tree
  cmd = "Neotree",
  opts = {
    window = {
      width = 28,
      position = "left",
    },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      hijack_netrw_behavior = "open_current",
    },
  },
  keys = {
    {
      "<leader>fe",
      function()
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = LazyVim.root() })
      end,
      desc = "Explorer NeoTree (Root Dir)",
    },
    {
      "<leader>fE",
      function()
        local current_file_dir = vim.fn.expand("%:p:h")
        if current_file_dir == "" then
          current_file_dir = vim.uv.cwd()
        end
        require("neo-tree.command").execute({ toggle = true, reveal = true, dir = current_file_dir })
      end,
      desc = "Explorer NeoTree (Current File Dir)",
    },
    { "<leader>e", "<leader>fE", desc = "Explorer NeoTree (Current File Dir)", remap = true },
    { "<leader>E", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    {
      "<leader>ge",
      function()
        require("neo-tree.command").execute({ source = "git_status", toggle = true })
      end,
      desc = "Git Explorer",
    },
    {
      "<leader>be",
      function()
        require("neo-tree.command").execute({ source = "buffers", toggle = true })
      end,
      desc = "Buffer Explorer",
    },
  },
}
