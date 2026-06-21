vim.pack.add { 'https://github.com/DrKJeff16/project.nvim' }

-- Build a "<parent>/<dir>" label from a directory path, falling back to just
-- "<dir>" at/near the filesystem root where the parent is empty.
local function tab_label(dir)
  -- Strip any trailing slash so `:t` resolves to the directory name, not ''.
  dir = dir:gsub('/+$', '')
  local name = vim.fn.fnamemodify(dir, ':t')
  local parent = vim.fn.fnamemodify(dir, ':h:t')
  if parent ~= '' and parent ~= name then name = parent .. '/' .. name end
  return name
end

-- Rename the current Zellij tab. Only runs when Neovim is inside a Zellij
-- session (the `ZELLIJ` env var is set) and the `zellij` binary is available.
local function rename_tab(name)
  if not (vim.env.ZELLIJ and vim.fn.executable 'zellij' == 1) then return end
  -- `wait` lets the command finish before Neovim exits on VimLeave.
  vim.system({ 'zellij', 'action', 'rename-tab', name }):wait()
end

require('project').setup {
  -- Treat a `.projectile` file as a project-root marker, in addition to the
  -- plugin defaults (`.git`, `Makefile`, `package.json`, etc.).
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.projectile' },
  on_attach = function(dir)
    -- Rename the Zellij tab to "<parent>/<dir>" of the project root that
    -- project.nvim just switched to.
    rename_tab(tab_label(dir))
  end,
}

-- Fallback for buffers that do not belong to a project: rename the Zellij tab
-- to "<parent>/<dir>" of the buffer's file directory (when the buffer is backed
-- by a real file on disk). project.nvim's `on_attach` only fires for buffers
-- inside a detected project root, so this covers everything else.
vim.api.nvim_create_autocmd('BufEnter', {
  group = vim.api.nvim_create_augroup('custom-project-tab', { clear = true }),
  callback = function(args)
    -- Oil buffers: rename to "<parent>/<dir>" of the directory Oil is showing.
    if vim.bo[args.buf].filetype == 'oil' then
      local dir = require('oil').get_current_dir(args.buf)
      if dir then rename_tab(tab_label(dir)) end
      return
    end

    -- Skip if this buffer belongs to a project (handled by `on_attach`).
    if require('project').get_project_root(args.buf) then return end

    -- Only act on normal buffers backed by a real file.
    if vim.bo[args.buf].buftype ~= '' then return end
    local file = vim.api.nvim_buf_get_name(args.buf)
    if file == '' or vim.fn.filereadable(file) == 0 then return end

    rename_tab(tab_label(vim.fn.fnamemodify(file, ':h')))
  end,
})
