return {
  "HiPhish/rainbow-delimiters.nvim",
  init = function()
    vim.g.rainbow_delimiters = {
      condition = function(bufnr)
        if vim.bo[bufnr].buftype ~= "" then
          return false
        end

        local ft = vim.bo[bufnr].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
          return false
        end

        local ok, parser = pcall(vim.treesitter.get_parser, bufnr, lang)
        return ok and parser ~= nil
      end,
    }
  end,
}
