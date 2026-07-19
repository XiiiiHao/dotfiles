return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    opts = function()
      local transparent = vim.g.neovide ~= true

      return {
        transparent_background = transparent,
        float = {
          transparent = transparent,
        },
      }
    end,
  },
  {
    "olimorris/onedarkpro.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "tokyonight",
      colorscheme = "vaporwave",
    },
  },
}
