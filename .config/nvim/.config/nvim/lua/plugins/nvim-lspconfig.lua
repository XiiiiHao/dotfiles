return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      -- Keep <leader>c available for buffer deletion; LSP actions use <leader>l.
      ["*"] = {
        keys = {
          { "<leader>ca", false, mode = { "n", "x" } },
          { "<leader>cc", false },
          { "<leader>cC", false },
          { "<leader>cR", false },
          { "<leader>cr", false },
          { "<leader>cA", false },
          { "<leader>cl", false },
          { "<leader>cs", false },
          { "<leader>cS", false },
        },
      },
      html = {},
      -- Ensure mason installs the server
      clangd = {
        keys = {
          { "<leader>cR", false },
        },
      },
    },
  },
}
