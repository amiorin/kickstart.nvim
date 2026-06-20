vim.pack.add { 'https://github.com/neogitorg/neogit' }

require('neogit').setup({
  kind = 'replace',
})

vim.keymap.set('n', '<leader>gg', '<Cmd>Neogit<CR>', { desc = 'Open Neogit' })
