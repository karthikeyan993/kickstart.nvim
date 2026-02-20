# Repository Guidelines

## Project Structure & Module Organization
- `init.lua`: primary Neovim configuration entry point (options, keymaps, plugin setup).
- `lua/kickstart/plugins/`: core plugin modules loaded by `require 'kickstart.plugins.*'`.
- `lua/custom/plugins/`: local/custom plugin specs and overrides.
- `doc/kickstart.txt`: Vim help-style project documentation.
- `.github/workflows/stylua.yml`: CI formatting check.
- `lazy-lock.json`: lockfile for plugin versions managed by `lazy.nvim`.

## Build, Test, and Development Commands
- `nvim`: start Neovim; first launch installs plugins.
- `nvim --headless "+Lazy! sync" +qa`: sync/install plugins in headless mode.
- `stylua --check .`: run formatting check used in CI.
- `stylua .`: format all Lua files.
- `nvim --headless "+checkhealth kickstart" +qa`: run Kickstart health checks for required tools.

## Coding Style & Naming Conventions
- Language: Lua.
- Formatting is defined by `.stylua.toml`: 2-space indentation, Unix line endings, line width 160, and preferred single quotes.
- Keep modules focused and small: one plugin/feature concern per file where practical.
- Use descriptive lowercase module filenames (examples: `lint.lua`, `render-markdown.lua`).
- Follow existing import patterns in `init.lua` (`require 'kickstart.plugins.<name>'` and `{ import = 'custom.plugins' }`).

## Testing Guidelines
- This repository does not include a standalone unit-test suite.
- Validate changes with this minimum checklist:
  1. `stylua --check .`
  2. `nvim --headless "+Lazy! sync" +qa`
  3. Open `nvim`, run `:checkhealth kickstart`, and verify affected workflows/keymaps.
- For behavior changes, document manual reproduction/verification steps in the PR.

## Commit & Pull Request Guidelines
- Prefer concise, imperative commit messages; Conventional Commit prefixes are common in history (`feat:`, `fix:`, `perf:`, `docs:`).
- Keep subjects scoped when useful (example: `feat(lint): add markdown linter`).
- Include issue references when relevant (example: `#1530`).
- PRs should include: clear summary, rationale, testing notes, and environment details for bug fixes (OS, terminal, Neovim version).
- Confirm the PR base repository is correct before opening.
