vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  -- Delete buffers without disrupting the window layout.
  bufdelete = { enabled = true },
}

-- Close the current buffer while keeping its window/split open.
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete buffer' })
