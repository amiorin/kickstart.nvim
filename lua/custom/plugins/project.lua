vim.pack.add { 'https://github.com/DrKJeff16/project.nvim' }

require('project').setup {
  -- Treat a `.projectile` file as a project-root marker, in addition to the
  -- plugin defaults (`.git`, `Makefile`, `package.json`, etc.).
  patterns = { '.git', '_darcs', '.hg', '.bzr', '.svn', 'Makefile', 'package.json', '.projectile' },
  on_attach = function(dir)
    -- Rename the Zellij tab to "<parent>/<dir>" of the project root that
    -- project.nvim just switched to. Only runs when Neovim is inside a Zellij
    -- session (the `ZELLIJ` env var is set) and the `zellij` binary is available.
    if not (vim.env.ZELLIJ and vim.fn.executable 'zellij' == 1) then return end

    local name = vim.fn.fnamemodify(dir, ':t')
    local parent = vim.fn.fnamemodify(dir, ':h:t')
    -- Handle paths at/near the filesystem root where parent is empty.
    if parent ~= '' and parent ~= name then name = parent .. '/' .. name end

    -- `wait` lets the command finish before Neovim exits on VimLeave.
    vim.system({ 'zellij', 'action', 'rename-tab', name }):wait()
  end,
}
