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
      -- Conform runs `zig fmt` on save, so keep zig.vim to syntax/ftplugin support.
      vim.g.zig_fmt_autosave = 0
    end,
  },
}
