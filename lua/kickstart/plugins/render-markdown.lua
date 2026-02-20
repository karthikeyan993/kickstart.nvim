return {
  'MeanderingProgrammer/render-markdown.nvim',
  ft = { 'markdown', 'md' },
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-tree/nvim-web-devicons' },
  opts = {
    heading = {
      enabled = true,
      icons = { '󰲡 ', '󰲣 ', '󰲥 ', '󰲧 ', '󰲩 ', '󰲫 ' },
    },
    code = {
      enabled = true,
      style = 'full',
    },
    bullet = {
      enabled = true,
    },
    checkbox = {
      enabled = true,
    },
    link = {
      enabled = true,
    },
  },
  keys = {
    { '<leader>tm', '<cmd>RenderMarkdown toggle<cr>', desc = '[T]oggle [M]arkdown render' },
  },
}
