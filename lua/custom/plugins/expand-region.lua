-- Emacs-style "expand region" via Treesitter.
--
-- Plain `v` still starts ordinary charwise visual mode. Once you are *in*
-- visual mode, pressing `v` again kicks off wildfire: the first press selects
-- the smallest Treesitter node under the cursor, and each further `v` grows the
-- selection to the enclosing node (word -> string -> call -> block -> ...).
-- `V` in visual mode shrinks the selection back one node.
vim.pack.add { 'https://github.com/sustech-data/wildfire.nvim' }

require('wildfire').setup {
  -- Disable wildfire's built-in keymaps; we wire up our own below so the very
  -- first `v` keeps Vim's default "start visual mode" behaviour.
  keymaps = {
    init_selection = false,
    node_incremental = false,
    node_decremental = false,
  },
}

-- Picks init (first press of the run) vs. expand (subsequent presses). Global so
-- the `:` command mapping below can reach it -- the `:` is required because it
-- flushes the `'<`/`'>` marks to the live selection before wildfire reads them
-- (a `<Cmd>`/Lua-callback mapping would see stale marks and expand wrongly).
function _G.__wildfire_expand()
  local wildfire = require 'wildfire'
  if vim.b.__wildfire_started then
    wildfire.node_incremental()
  else
    vim.b.__wildfire_started = true
    wildfire.init_selection()
  end
end

-- Normal-mode `v`: reset the session flag, then fall through to the built-in
-- charwise visual mode (expr returns a non-remapped `v`). Using a real `v`
-- press here -- rather than wildfire's internal `normal! v` re-entry -- is what
-- distinguishes "user started a new selection" from "wildfire grew the region".
vim.keymap.set('n', 'v', function()
  vim.b.__wildfire_started = false
  return 'v'
end, { expr = true, desc = 'Visual mode (resets expand-region)' })

-- Visual-mode `v` / `V`: grow / shrink the Treesitter selection.
vim.keymap.set('x', 'v', ':lua _G.__wildfire_expand()<CR>', { silent = true, desc = 'Expand region (Treesitter)' })
vim.keymap.set('x', 'V', ":lua require('wildfire').node_decremental()<CR>", { silent = true, desc = 'Shrink region (Treesitter)' })
