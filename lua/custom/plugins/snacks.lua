vim.pack.add { 'https://github.com/folke/snacks.nvim' }

require('snacks').setup {
  -- Delete buffers without disrupting the window layout.
  bufdelete = { enabled = true },
}

local ok, wk = pcall(require, 'which-key')
if ok then wk.add { { '<leader>b', group = '[B]uffer' } } end

-- Close the current buffer while keeping its window/split open.
vim.keymap.set('n', '<leader>bd', function() Snacks.bufdelete() end, { desc = 'Delete buffer' })

-- Create a new empty buffer in the current window.
vim.keymap.set('n', '<leader>bn', '<cmd>enew<cr>', { desc = 'New buffer' })
