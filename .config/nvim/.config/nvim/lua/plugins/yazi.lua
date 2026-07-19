return {
  "DreamMaoMao/yazi.nvim",
  enabled = false,
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>e", "<cmd>Yazi<CR>", desc = "打开 Yazi (根目录)" },
    { "<leader>E", function()
      vim.cmd("Yazi " .. vim.fn.expand("%:p:h"))
    end, desc = "打开 Yazi (当前文件目录)" },
  },
}
