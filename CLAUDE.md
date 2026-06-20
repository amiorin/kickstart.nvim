# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A personal Neovim configuration derived from [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim). The bulk of the config lives in a single, heavily-commented `init.lua`; personal additions go in `lua/custom/plugins/`. Plugins are managed by Neovim's **built-in `vim.pack`** (not lazy.nvim/packer) — there is no separate bootstrap step.

## Formatting

Lua is formatted with **StyLua** (`.stylua.toml`): 2-space indent, 160 column width, `AutoPreferSingle` quotes, **no call parentheses** (`require 'foo'`, not `require('foo')`), single-statement collapse. Run `stylua .` before considering a change done. Note: existing files in `lua/custom/plugins/` predate this style (double quotes, explicit parens) — match the StyLua style for new code.

## Testing changes

There is no test suite. Validate by launching Neovim and checking it loads cleanly:

```sh
nvim --headless "+checkhealth" +qa      # run health checks
nvim --headless "+qa"                   # smoke test: load config, exit
```

In an interactive session, `:checkhealth` (and `lua/kickstart/health.lua`) reports config/dependency problems. Plugin issues are usually visible as startup errors.

## Architecture

### `init.lua` — single-file core
Organized into numbered `SECTION` blocks, each wrapped in a `do ... end` scope:
1. **OPTIONS** — `vim.o` settings, leader = `<Space>`, `vim.g.have_nerd_font`, OSC 52 clipboard (single clipboard so yank/paste works over SSH)
2. **KEYMAPS** — global keymaps and autocommands
3. **PLUGIN MANAGER INTRO** — `vim.pack` setup; `gh '<user>/<repo>'` is a local helper that expands to a GitHub URL
4. **UI / CORE UX** — guess-indent, gitsigns, which-key, **doom-one** colorscheme (recently swapped from tokyonight), todo-comments, mini.nvim modules + statusline
5. **SEARCH & NAVIGATION** — Telescope
6. **LSP** — mason + mason-lspconfig + mason-tool-installer; the `servers` table (~line 706) is where you add/configure language servers, and `ensure_installed` controls what Mason installs
7. **FORMATTING** — conform.nvim
8. **AUTOCOMPLETE & SNIPPETS** — blink.cmp + LuaSnip
9. **TREESITTER** — `nvim-treesitter` (`main` branch) with an autocmd that auto-installs parsers on demand
10. **OPTIONAL EXAMPLES** — commented `require 'kickstart.plugins.*'` lines, then `require 'custom.plugins'`

### `lua/custom/plugins/` — personal additions
`init.lua` here auto-loads every other `*.lua` file in the directory via `vim.fs.dir`, so **adding a new plugin = dropping a new file in this folder** (no central registration). Each file is self-contained: it calls `vim.pack.add { '<git url>' }`, runs `setup`, and sets its own keymaps. Current files: `oil`, `neogit`, `project` (project.nvim), `mini-icons`, `bindings`.

- **`bindings.lua`** — `<D-*>` (Cmd/Super) window-management keymaps. These are defined for `n/i/v` **and** terminal mode; terminal-mode variants prefix `<C-\><C-n>` (the `t` local) to first escape terminal mode so window commands work.
- **`project.lua`** — `on_attach` renames the **Zellij** tab to the project root's `parent/dir` when switching projects (only if `$ZELLIJ` is set and the `zellij` binary exists).

### `lua/kickstart/plugins/` — opt-in extras
Upstream kickstart modules (debug, lint, autopairs, neo-tree, gitsigns, indent_line). **Disabled by default** — enable by uncommenting the matching `require` in init.lua SECTION 10.

## Plugin management (`vim.pack`)
- Add: `vim.pack.add { 'https://github.com/user/repo' }` (or `gh 'user/repo'` inside init.lua).
- `nvim-pack-lock.json` is the lockfile. It is **gitignored** in this fork (kept ignored to match upstream and avoid merge conflicts), so plugin versions are not pinned in git.
- Update plugins from inside nvim: `:lua vim.pack.update()` (add `{ offline = true }` to update from already-fetched data). See `:help vim.pack`.
