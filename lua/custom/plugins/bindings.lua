-- Escape terminal mode first so the window commands below work from a terminal buffer.
local t = '<C-\\><C-n>'

vim.keymap.set({ 'n', 'i', 'v' }, '<D-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set({ 'n', 'i', 'v' }, '<D-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set({ 'n', 'i', 'v' }, '<D-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set({ 'n', 'i', 'v' }, '<D-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('t', '<D-h>', t .. '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('t', '<D-l>', t .. '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('t', '<D-j>', t .. '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('t', '<D-k>', t .. '<C-w><C-k>', { desc = 'Move focus to the upper window' })

vim.keymap.set({ 'n', 'i', 'v' }, '<D-s>', '<Cmd>write<CR><Esc>', { desc = 'Save file' })
vim.keymap.set('t', '<D-s>', t .. '<Cmd>write<CR>', { desc = 'Save file' })

vim.keymap.set({ 'n', 'i', 'v' }, '<D-w>', '<C-w>c', { desc = 'Close window split' })
vim.keymap.set('t', '<D-w>', t .. '<C-w>c', { desc = 'Close window split' })

vim.keymap.set({ 'n', 'i', 'v' }, '<D-n>', ':vsplit<CR>', { desc = 'Split window vertically' })
vim.keymap.set('t', '<D-n>', t .. ':vsplit<CR>', { desc = 'Split window vertically' })

vim.keymap.set({ 'n', 'i', 'v' }, '<S-D-]>', ':only<CR>', { desc = 'Close the other windows' })
vim.keymap.set('t', '<S-D-]>', t .. ':only<CR>', { desc = 'Close the other windows' })

vim.keymap.set({ 'n', 'i', 'v' }, '<S-D-[>', '<C-w>r', { desc = 'Rotate windows' })
vim.keymap.set('t', '<S-D-[>', t .. '<C-w>r', { desc = 'Rotate windows' })

vim.keymap.set({ 'n', 'i', 'v', 't' }, '<D-t>', function()
  vim.cmd 'vsplit' -- Open the vertical split
  vim.cmd 'terminal fish' -- Launch the terminal in the new split
  vim.cmd 'startinsert' -- Immediately switch to terminal/insert mode
end, { silent = true, desc = 'Open terminal in vsplit and enter insert mode' })
