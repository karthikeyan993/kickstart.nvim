return {
  {
    dir = vim.fn.expand '~/.local/share/pi-desktop/nvim',
    name = 'pi-desktop.nvim',
    lazy = false,
    config = function()
      require('pi-desktop').setup {
        auto_connect = true,
        debounce_ms = 80,
        reconnect_ms = 1500,
        notify = false,
      }
    end,
  },
}
