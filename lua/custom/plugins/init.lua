-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
---@module 'lazy'
---@type LazySpec
return {
  { 'tpope/vim-fugitive' },

  -- Diffview: VSCode-like "Source Control" panel for viewing all changes
  {
    'sindrets/diffview.nvim',
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewFileHistory' },
    keys = {
      { '<leader>gv', '<cmd>DiffviewOpen<CR>', desc = '[G]it diff [V]iew' },
      { '<leader>gx', '<cmd>DiffviewClose<CR>', desc = '[G]it diff close' },
      { '<leader>gh', '<cmd>DiffviewFileHistory %<CR>', desc = '[G]it file [H]istory' },
    },
  },

  -- Supermaven AI completion
  {
    'supermaven-inc/supermaven-nvim',
    config = function()
      require('supermaven-nvim').setup {}
    end,
  },

  -- Amp Plugin
  {
    'sourcegraph/amp.nvim',
    branch = 'main',
    lazy = false,
    opts = { auto_start = true, log_level = 'info' },
  },

  -- Test runner for Go and other languages
  {
    'vim-test/vim-test',
    keys = {
      { '<leader>tt', ':TestNearest<CR>', desc = '[T]est Nearest' },
      { '<leader>tf', ':TestFile<CR>', desc = '[T]est [F]ile' },
      { '<leader>ts', ':TestSuite<CR>', desc = '[T]est [S]uite' },
      { '<leader>tl', ':TestLast<CR>', desc = '[T]est [L]ast' },
    },
    config = function()
      vim.g['test#strategy'] = 'neovim'
      vim.g['test#go#runner'] = 'gotest'
    end,
  },

  -- Web development quality-of-life plugins
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = function()
      local filetypes = {
        'html',
        'xml',
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
        'vue',
        'svelte',
        'astro',
        'php',
      }
      local installed = {}
      for _, parser in ipairs(require('nvim-treesitter').get_installed 'parsers') do
        installed[parser] = true
      end

      local per_filetype = {}
      for _, filetype in ipairs(filetypes) do
        local language = vim.treesitter.language.get_lang(filetype) or filetype
        if not installed[language] then
          per_filetype[filetype] = {
            enable_close = false,
            enable_close_on_slash = false,
            enable_rename = false,
          }
        end
      end

      return { per_filetype = per_filetype }
    end,
  },
  {
    'mattn/emmet-vim',
    ft = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
    init = function()
      vim.g.user_emmet_leader_key = '<C-z>'
    end,
  },
  {
    'NvChad/nvim-colorizer.lua',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('colorizer').setup {
        filetypes = {
          'css',
          'scss',
          'sass',
          'less',
          'html',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
        user_default_options = {
          names = false,
          tailwind = true,
        },
        suppress_deprecation = true,
      }
    end,
  },
}
