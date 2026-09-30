return {
  "mason-org/mason-lspconfig.nvim",
  -- LazyVim calls setup with server exclusions and automatic_enable.
  -- Only extend its options; do not run a second setup here.
  opts = {
    ensure_installed = { "lua_ls", "pyright", "html", "clangd" },
  },
}
