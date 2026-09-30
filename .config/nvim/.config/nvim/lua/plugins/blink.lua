-- LazyVim currently selects blink.cmp; nvim-cmp overrides are inactive.
return {
  "saghen/blink.cmp",
  opts = {
    keymap = {
      preset = "enter",
      ["<C-n>"] = { "show", "fallback" },
      ["<C-,>"] = { "show", "fallback" },
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-y>"] = { "select_and_accept", "fallback" },
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
      ["<Esc>"] = { "cancel", "fallback" },
      ["<Tab>"] = { "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "fallback" },
    },
    completion = {
      list = { max_items = 20, selection = { preselect = false, auto_insert = false } },
      ghost_text = { enabled = false },
    },
    sources = {
      min_keyword_length = 2,
      providers = {
        buffer = { min_keyword_length = 3, max_items = 8 },
        path = { min_keyword_length = 0, max_items = 8 },
        snippets = { max_items = 5 },
      },
    },
  },
}
