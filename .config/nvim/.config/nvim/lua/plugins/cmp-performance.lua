-- 补全性能优化配置
return {
  "hrsh7th/nvim-cmp",
  opts = function(_, opts)
    local cmp = require("cmp")
    
    -- 添加性能优化配置
    opts.performance = {
      debounce = 60,        -- 减少补全触发频率
      throttle = 30,        -- 限制补全更新频率
      fetching_timeout = 200, -- 减少获取超时时间
      confirm_resolve_timeout = 80,
      async_budget = 1,
      max_view_entries = 20, -- 限制显示的补全项数量
    }
    
    -- 添加条件判断，减少不必要的补全
    opts.enabled = function()
      -- 在注释中禁用补全
      local context = require("cmp.config.context")
      if context.in_treesitter_capture("comment") or context.in_syntax_group("Comment") then
        return false
      end
      
      -- 在字符串中只启用路径补全
      if context.in_treesitter_capture("string") then
        return false
      end
      
      -- 在超大文件中禁用buffer补全
      local bufnr = vim.api.nvim_get_current_buf()
      local line_count = vim.api.nvim_buf_line_count(bufnr)
      if line_count > 10000 then
        return false
      end
      
      return true
    end
    
    return opts
  end,
}
