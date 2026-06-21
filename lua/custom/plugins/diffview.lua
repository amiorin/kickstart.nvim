vim.pack.add {
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/sindrets/diffview.nvim',
}

local close = { 'n', 'q', '<cmd>DiffviewClose<cr>', { desc = 'Close Diffview' } }

require('diffview').setup {
  keymaps = {
    view = { close },
    file_panel = { close },
    file_history_panel = { close },
  },
}
