return {
  {
    'mfussenegger/nvim-jdtls',
    ft = { 'java' },
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    config = function()
      local function start_jdtls(bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()
        if vim.bo[bufnr].filetype ~= 'java' then return end
        if vim.fn.executable 'java' == 0 then
          if not vim.g.java_jdtls_runtime_warned then
            vim.g.java_jdtls_runtime_warned = true
            vim.schedule(function()
              vim.notify('Java runtime was not found in PATH. Install a JDK to run jdtls.', vim.log.levels.WARN)
            end)
          end
          return
        end

        local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', 'build.gradle.kts', 'settings.gradle', 'settings.gradle.kts' }
        local root_dir = require('jdtls.setup').find_root(root_markers)
        if root_dir == nil or root_dir == '' then return end

        local mason_path = vim.fn.stdpath 'data' .. '/mason'
        local jdtls_path = mason_path .. '/packages/jdtls'
        local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
        if launcher_jar == '' then
          vim.notify('jdtls launcher was not found. Install jdtls with :Mason', vim.log.levels.WARN)
          return
        end

        local os_config = 'linux'
        if vim.fn.has 'mac' == 1 then
          os_config = 'mac'
        elseif vim.fn.has 'win32' == 1 or vim.fn.has 'win64' == 1 then
          os_config = 'win'
        end

        local project_name = vim.fn.fnamemodify(root_dir, ':p:t')
        local workspace_dir = vim.fn.stdpath 'data' .. '/site/java/workspace-root/' .. project_name

        local bundles = {}
        local bundle_patterns = {
          mason_path .. '/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar',
          mason_path .. '/packages/java-test/extension/server/*.jar',
        }
        for _, pattern in ipairs(bundle_patterns) do
          local matches = vim.fn.glob(pattern, true, true)
          if type(matches) == 'table' and #matches > 0 then vim.list_extend(bundles, matches) end
        end

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local ok_blink, blink = pcall(require, 'blink.cmp')
        if ok_blink then capabilities = blink.get_lsp_capabilities() end

        local cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xms1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          '-jar',
          launcher_jar,
          '-configuration',
          jdtls_path .. '/config_' .. os_config,
          '-data',
          workspace_dir,
        }

        local lombok_jar = jdtls_path .. '/lombok.jar'
        if vim.uv.fs_stat(lombok_jar) then
          table.insert(cmd, 7, '-javaagent:' .. lombok_jar)
          table.insert(cmd, 8, '-Xbootclasspath/a:' .. lombok_jar)
        end

        local function detect_java_home()
          local java_home = vim.env.JAVA_HOME
          if java_home and java_home ~= '' and vim.uv.fs_stat(java_home) then return java_home end

          local java_bin = vim.fn.exepath 'java'
          if java_bin == '' then return nil end

          local resolved_java_bin = vim.uv.fs_realpath(java_bin) or java_bin
          local bin_dir = vim.fs.dirname(resolved_java_bin)
          if not bin_dir then return nil end

          return vim.fs.dirname(bin_dir)
        end

        local java_settings = {
          configuration = {
            updateBuildConfiguration = 'automatic',
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
          references = {
            includeDecompiledSources = true,
          },
          signatureHelp = {
            enabled = true,
          },
          contentProvider = {
            preferred = 'fernflower',
          },
          format = {
            enabled = true,
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
        }

        local java_home = detect_java_home()
        if java_home and java_home ~= '' then
          java_settings.configuration.runtimes = {
            {
              name = 'JavaSE-21',
              path = java_home,
              default = true,
            },
          }
        end

        local jdtls = require 'jdtls'
        jdtls.start_or_attach {
          cmd = cmd,
          root_dir = root_dir,
          capabilities = capabilities,
          init_options = {
            bundles = bundles,
          },
          settings = {
            java = java_settings,
          },
          on_attach = function(client, _)
            if client.name == 'jdtls' then
              jdtls.setup_dap { hotcodereplace = 'auto' }
              require('jdtls.dap').setup_dap_main_class_configs()
            end
          end,
        }
      end

      local java_augroup = vim.api.nvim_create_augroup('custom-java-jdtls', { clear = true })
      vim.api.nvim_create_autocmd('FileType', {
        group = java_augroup,
        pattern = { 'java' },
        callback = function(args)
          start_jdtls(args.buf)
        end,
      })

      start_jdtls(vim.api.nvim_get_current_buf())
    end,
  },
}
