-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  { 'tpope/vim-fugitive' },

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
    event = 'VeryLazy',
    opts = {},
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
      }
    end,
  },
}
