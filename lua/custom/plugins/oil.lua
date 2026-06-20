vim.pack.add { 'https://github.com/stevearc/oil.nvim' }

require("oil").setup({
  columns = {
    "permissions",
    "user",
    "group",
    "size",
    "mtime",
    "icon",
  },
  keymaps = {
    ["l"] = "actions.select",
    ["h"] =  "actions.parent",
    ["-"] = { "actions.parent", mode = "n" },
    ["."] = { "actions.toggle_hidden", mode = "n" },
  }
})

vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

