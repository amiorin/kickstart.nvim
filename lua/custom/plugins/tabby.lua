vim.pack.add {
  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/nanozuki/tabby.nvim',
  'https://github.com/LukasPietzschmann/telescope-tabs',
}

require('tabby').setup {
  preset = 'active_wins_at_tail',
}

-- Telescope picker for tabpages. Show tabby's tab name (the one set by
-- `Tabby rename_tab`, falling back to the active window's filename) so the
-- picker lines up with what the tabline displays.
local tab_name = require 'tabby.feature.tab_name'
require('telescope-tabs').setup {
  entry_formatter = function(tab_id, _, _, _, is_current)
    local name = tab_name.get(tab_id)
    return string.format('%d: %s%s', vim.api.nvim_tabpage_get_number(tab_id), name, is_current and ' *' or ''), name
  end,
}
pcall(require('telescope').load_extension, 'telescope-tabs')

-- Tab management lives under <leader><Tab> ('<leader>t' is the [T]oggle group).
local ok, wk = pcall(require, 'which-key')
if ok then wk.add { { '<leader><Tab>', group = '[Tab]page' } } end

local map = function(lhs, rhs, desc) vim.keymap.set('n', lhs, rhs, { desc = desc }) end

map('<leader><Tab>n', '<cmd>tabnew<cr>', 'Tab [n]ew')
map('<leader><Tab>c', '<cmd>tabclose<cr>', 'Tab [c]lose')
map('<leader><Tab>r', '<cmd>Tabby rename_tab<cr>', 'Tab [r]ename')
map('<leader><Tab><Tab>', function() require('telescope-tabs').list_tabs() end, 'Tab [s]earch (Telescope)')
