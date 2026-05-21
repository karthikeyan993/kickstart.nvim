-- Zig language support
--
-- zig.vim: file detection, syntax highlighting, `zig fmt` on save,
-- and `:make` / `:compiler` integration (zig build, zig test, etc.)
-- See https://codeberg.org/ziglang/zig.vim
--
-- The zls (Zig Language Server) is configured separately in init.lua's
-- LSP `servers` table and is installed automatically via mason-tool-installer.
-- See https://github.com/zigtools/zls
---@module 'lazy'
---@type LazySpec
return {
  {
    url = 'https://codeberg.org/ziglang/zig.vim',
    ft = { 'zig', 'zir' },
    init = function()
      -- Set to 0 to disable automatic `zig fmt` on save
      vim.g.zig_fmt_autosave = 1
    end,
  },
}
