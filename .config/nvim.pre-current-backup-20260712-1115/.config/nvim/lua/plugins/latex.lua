return {
  -- LaTeX support
  {
    "lervag/vimtex",
    lazy = false,
    config = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      
      -- 禁用自动清理，避免意外的清理操作
      vim.g.vimtex_compiler_latexmk_cleanup = 1
      
      -- 禁用自动编译，改为手动编译
      vim.g.vimtex_compiler_latexmk = {
        build_dir = "",
        callback = 1,
        continuous = 0,  -- 禁用连续编译
        executable = "latexmk",
        options = {
          "-xelatex",
          "-file-line-error",
          "-synctex=1",
          "-interaction=nonstopmode",
          "-shell-escape",
        },
      }
      -- 设置编译引擎优先级
      vim.g.vimtex_compiler_latexmk_engines = {
        _ = '-xelatex',
      }
      -- 启用正向搜索和反向搜索
      vim.g.vimtex_view_general_options = [[--unique file:@pdf\#src:@line@tex]]
      -- 启用自动打开PDF预览
      vim.g.vimtex_view_automatic = 1
    end,
  },
  -- Snippets support
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      "honza/vim-snippets",
    },
    config = function()
      require("luasnip").setup({
        history = true,
        update_events = "TextChanged,TextChangedI",
      })
      require("luasnip.loaders.from_snipmate").lazy_load()
      require("luasnip.loaders.from_lua").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  -- Snippets engine
  {
    "sirver/ultisnips",
    dependencies = {
      "honza/vim-snippets",
    },
    config = function()
      vim.g.UltiSnipsExpandTrigger = "<tab>"
      vim.g.UltiSnipsJumpForwardTrigger = "<tab>"
      vim.g.UltiSnipsJumpBackwardTrigger = "<s-tab>"
      vim.g.UltiSnipsSnippetDirectories = { "UltiSnips" }
    end,
  },
}
