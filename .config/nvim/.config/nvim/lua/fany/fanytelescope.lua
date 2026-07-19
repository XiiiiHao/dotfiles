local telescope = require("telescope")

telescope.setup({
  defaults = {
    -- 性能优化：忽略大型目录和缓存
    file_ignore_patterns = {
      "node_modules/",
      ".git/",
      "%.cache/",
      "Code/",
      "Code - OSS/",
      "Cursor/",
      "Windsurf/",
      "google-chrome/",
      "QQ/",
      "baidunetdisk/",
      "nvm/",
      "obsidian/",
      "cfg_backups/",
      "hyde/Cache/",
      "%.o$",
      "%.a$",
      "%.out$",
      "%.class$",
      "%.pdf$",
      "%.mkv$",
      "%.mp4$",
      "%.zip$",
    },
    -- 使用更好的排序算法
    sorting_strategy = "ascending",
    layout_config = {
      prompt_position = "top",
    },
    -- 使用vimgrep参数优化
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",
      "--glob=!.git/",
      "--glob=!node_modules/",
      "--glob=!.cache/",
      "--glob=!Code/",
      "--glob=!QQ/",
      "--glob=!google-chrome/",
      "--glob=!nvm/",
    },
    mappings = {
      i = {
        ["<C-j>"] = require("telescope.actions").cycle_history_next,
        ["<C-k>"] = require("telescope.actions").cycle_history_prev,
      },
    },
  },
  pickers = {
    find_files = {
      -- 使用fd提升速度
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--exclude", "node_modules", "--exclude", ".cache", "--exclude", "Code", "--exclude", "QQ", "--exclude", "google-chrome", "--exclude", "nvm" },
    },
  },
})
