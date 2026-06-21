vim.pack.add { 'https://github.com/neogitorg/neogit' }

require('neogit').setup {
  kind = 'replace',
  disable_hint = true,
  integrations = { diffview = true },
}

vim.keymap.set('n', '<leader>gg', '<Cmd>Neogit<CR>', { desc = 'Open Neogit' })

-- Make `q` close Neogit buffers via Snacks.bufdelete, preserving the window layout.
-- Neogit installs its own buffer-local `q` mapping after FileType fires, so defer
-- ours with vim.schedule to run last and win.
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'Neogit*',
  callback = function(args)
    vim.schedule(function()
      if not vim.api.nvim_buf_is_valid(args.buf) then return end
      vim.keymap.set('n', 'q', function() Snacks.bufdelete() end, { buffer = args.buf, desc = 'Delete buffer' })
      vim.keymap.set('n', '-', '<Cmd>Oil<CR>', { buffer = args.buf, desc = 'Open parent directory' })
    end)
  end,
})
