return {

  { -- Linting
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'

      -- Configure golangci-lint (prefer PATH, fallback to GOPATH bin)
      lint.linters.golangcilint.cmd = vim.fn.exepath 'golangci-lint'
      if lint.linters.golangcilint.cmd == '' then
        lint.linters.golangcilint.cmd = vim.fn.expand '$HOME/go/bin/golangci-lint'
      end
      local function go_mod_dir()
        local bufname = vim.api.nvim_buf_get_name(0)
        if bufname == '' then
          return nil
        end

        local dir = vim.fn.fnamemodify(bufname, ':p:h')
        local found = vim.fs.find('go.mod', { path = dir, upward = true })[1]
        if found then
          return vim.fn.fnamemodify(found, ':h')
        end

        return nil
      end

      lint.linters_by_ft = {
        go = { 'golangcilint' },
        -- lua = {'luacheck'},
        javascript = { 'eslint_d' },
        javascriptreact = { 'eslint_d' },
        typescript = { 'eslint_d' },
        typescriptreact = { 'eslint_d' },
        c = { 'clangtidy' },
        -- markdown = { 'markdownlint' }, -- Disabled: markdownlint not installed
      }

      -- To allow other plugins to add linters to require('lint').linters_by_ft,
      -- instead set linters_by_ft like this:
      -- lint.linters_by_ft = lint.linters_by_ft or {}
      -- lint.linters_by_ft['markdown'] = { 'markdownlint' }
      --
      -- However, note that this will enable a set of default linters,
      -- which will cause errors unless these tools are available:
      -- {
      --   clojure = { "clj-kondo" },
      --   dockerfile = { "hadolint" },
      --   inko = { "inko" },
      --   janet = { "janet" },
      --   json = { "jsonlint" },
      --   markdown = { "vale" },
      --   rst = { "vale" },
      --   ruby = { "ruby" },
      --   terraform = { "tflint" },
      --   text = { "vale" }
      -- }
      --
      -- You can disable the default linters by setting their filetypes to nil:
      -- lint.linters_by_ft['clojure'] = nil
      -- lint.linters_by_ft['dockerfile'] = nil
      -- lint.linters_by_ft['inko'] = nil
      -- lint.linters_by_ft['janet'] = nil
      -- lint.linters_by_ft['json'] = nil
      -- lint.linters_by_ft['markdown'] = nil
      -- lint.linters_by_ft['rst'] = nil
      -- lint.linters_by_ft['ruby'] = nil
      -- lint.linters_by_ft['terraform'] = nil
      -- lint.linters_by_ft['text'] = nil

      -- Create autocommand which carries out the actual linting
      -- on the specified events.
      local lint_augroup = vim.api.nvim_create_augroup('lint', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = lint_augroup,
        callback = function()
          -- Only run the linter in buffers that you can modify in order to
          -- avoid superfluous noise, notably within the handy LSP pop-ups that
          -- describe the hovered symbol using Markdown.
          -- Skip Netrw buffers to avoid conflicts.
          if vim.bo.modifiable and vim.bo.filetype ~= 'netrw' then
            local opts = nil
            if vim.bo.filetype == 'go' then
              local root = go_mod_dir()
              if root then
                opts = { cwd = root }
              end
            end
            lint.try_lint(nil, opts)
          end
        end,
      })
    end,
  },
}
