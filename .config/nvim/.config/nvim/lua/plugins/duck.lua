return {
  "tamton-aquib/duck.nvim",
  config = function()
    vim.keymap.set("n", "<leader>dd", function() require("duck").hatch() end, { desc = "Duck Hatch" })
    vim.keymap.set("n", "<leader>dk", function() require("duck").cook() end, { desc = "Duck Cook" })
    vim.keymap.set("n", "<leader>db", function() require("duck").hatch("🦀") end, { desc = "Duck Hatch Crab" })
    vim.keymap.set("n", "<leader>dc", function() require("duck").hatch("🐈") end, { desc = "Duck Hatch Cat" })
    vim.keymap.set("n", "<leader>da", function() require("duck").cook_all() end, { desc = "Duck Cook All" })
  end,
}
