-- Create this file at ~/.config/nvim/lua/plugins/jdtls.lua

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "folke/which-key.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
    },
  },
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local jdtls = require("jdtls")
      local jdtls_dap = require("jdtls.dap")
      local jdtls_setup = require("jdtls.setup")
      local home = os.getenv("HOME")
      
      -- File types that signify a Java project's root directory
      local root_markers = { "gradlew", "mvnw", ".git", "pom.xml", "build.gradle" }
      local root_dir = jdtls_setup.find_root(root_markers)
      
      -- Find JDTLS installation via the system path
      local cmd = vim.fn.systemlist("which jdtls")[1]
      local cmd_dir = vim.fn.fnamemodify(cmd, ":h")
      local install_dir = vim.fn.fnamemodify(cmd_dir, ":h") -- Get parent directory of bin
      
      -- Set directories for JDTLS components based on system installation
      local config_dir = install_dir .. "/etc"
      local plugins_dir = install_dir .. "/plugins"
      local path_to_jar = plugins_dir .. "/org.eclipse.equinox.launcher_*.jar"
      local lombok_path = install_dir .. "/lombok.jar"
      
      -- Check if lombok exists, if not use Mason's path as fallback
      if vim.fn.filereadable(lombok_path) == 0 then
        lombok_path = home .. "/.local/share/nvim/mason/packages/jdtls/lombok.jar"
      end
      
      -- Check if the jar exists, if not fall back to usual path
      local jar_exists = vim.fn.glob(path_to_jar) ~= ""
      if not jar_exists then
        local mason_jdtls_dir = home .. "/.local/share/nvim/mason/packages/jdtls"
        config_dir = mason_jdtls_dir .. "/config_linux"
        plugins_dir = mason_jdtls_dir .. "/plugins"
        path_to_jar = plugins_dir .. "/org.eclipse.equinox.launcher_*.jar"
      end
      
      -- Project-specific settings
      local project_name = vim.fn.fnamemodify(root_dir or vim.fn.getcwd(), ":p:h:t")
      local workspace_dir = home .. "/.cache/jdtls/workspace/" .. project_name
      
      -- Print debug information
      print("JDTLS config_dir: " .. config_dir)
      print("JDTLS launcher JAR: " .. vim.fn.glob(path_to_jar))
      
      -- See: https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line
      local config = {
        cmd = {
          "java",
          "-Declipse.application=org.eclipse.jdt.ls.core.id1",
          "-Dosgi.bundles.defaultStartLevel=4",
          "-Declipse.product=org.eclipse.jdt.ls.core.product",
          "-Dlog.protocol=true",
          "-Dlog.level=ALL",
          "-Xmx2g",
          "--add-modules=ALL-SYSTEM",
          "--add-opens", "java.base/java.util=ALL-UNNAMED",
          "--add-opens", "java.base/java.lang=ALL-UNNAMED",
          
          -- Include lombok if the file exists
          "-javaagent:" .. lombok_path,
          
          "-jar", vim.fn.glob(path_to_jar),
          "-configuration", config_dir,
          "-data", workspace_dir,
        },
        
        -- Setup LSP features
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        
        -- Configure Java file system settings
        root_dir = root_dir,
        
        -- Here you can configure eclipse.jdt.ls settings
        settings = {
          java = {
            -- Configure JDK paths
            home = os.getenv("JAVA_HOME"),
            -- Or use: 
            -- home = "/usr/lib/jvm/java-17-openjdk-amd64",
            
            eclipse = {
              downloadSources = true,
            },
            configuration = {
              updateBuildConfiguration = "interactive",
              runtimes = {
                {
                  name = "JavaSE-1.8",
                  path = "/usr/lib/jvm/java-8-openjdk-amd64",
                },
                {
                  name = "JavaSE-11",
                  path = "/usr/lib/jvm/java-11-openjdk-amd64",
                },
                {
                  name = "JavaSE-17",
                  path = "/usr/lib/jvm/java-17-openjdk-amd64",
                },
              },
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
            format = {
              enabled = true,
              settings = {
                url = home .. "/.local/share/nvim/mason/packages/jdtls/google_formatter.xml",
                profile = "GoogleStyle",
              },
            },
          },
          signatureHelp = { enabled = true },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*",
            },
            importOrder = {
              "java",
              "javax",
              "com",
              "org"
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999,
              staticStarThreshold = 9999,
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
            },
            useBlocks = true,
          },
        },
        
        -- Specify handlers for LSP actions
        on_attach = function(client, bufnr)
          -- Enable completion triggered by <c-x><c-o>
          vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        
          -- Set up keybindings
          local bufopts = { noremap=true, silent=true, buffer=bufnr }
          vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
          vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
          vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
          vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
          vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
          vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
          vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
          vim.keymap.set('n', '<leader>wl', function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, bufopts)
          vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
          vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
          vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
          vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
          vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)
          
          -- Set up additional jdtls-specific keybindings
          vim.keymap.set('n', '<leader>di', jdtls.organize_imports, bufopts)
          vim.keymap.set('n', '<leader>dt', jdtls.test_class, bufopts)
          vim.keymap.set('n', '<leader>dn', jdtls.test_nearest_method, bufopts)
          vim.keymap.set('n', '<leader>dm', jdtls.extract_method, bufopts)
          vim.keymap.set('v', '<leader>dm', function() jdtls.extract_method(true) end, bufopts)
          vim.keymap.set('n', '<leader>dc', jdtls.extract_constant, bufopts)
          vim.keymap.set('v', '<leader>dc', function() jdtls.extract_constant(true) end, bufopts)
          vim.keymap.set('v', '<leader>dv', function() jdtls.extract_variable(true) end, bufopts)
          vim.keymap.set('n', '<leader>dv', jdtls.extract_variable, bufopts)
          
          jdtls_dap.setup_dap_main_class_configs()
          local cmp = require("cmp")
          cmp.setup({
            sources = {
              { name = "nvim_lsp" },
            },
            mapping = cmp.mapping.preset.insert({
                ['<Tab>'] = cmp.mapping(function(fallback)
                  if cmp.visible() then
                    cmp.select_next_item()
                  else
                    fallback()
                  end
                end, { 'i', 's' }),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
              }),
          })          -- Setup which-key mappings to show available commands

          if pcall(require, "which-key") then
            local wk = require("which-key")
            local opts = {
              mode = "n",
              prefix = "<leader>",
              buffer = bufnr,
              silent = true,
              noremap = true,
              nowait = true,
            }
            local vopts = {
              mode = "v",
              prefix = "<leader>",
              buffer = bufnr,
              silent = true,
              noremap = true,
              nowait = true,
            }
            
            local mappings = {
              d = {
                name = "Java",
                i = { jdtls.organize_imports, "Organize Imports" },
                t = { jdtls.test_class, "Test Class" },
                n = { jdtls.test_nearest_method, "Test Method" },
                m = { jdtls.extract_method, "Extract Method" },
                c = { jdtls.extract_constant, "Extract Constant" },
                v = { jdtls.extract_variable, "Extract Variable" },
              },
            }
            
            local vmappings = {
              d = {
                name = "Java",
                m = { function() jdtls.extract_method(true) end, "Extract Method" },
                c = { function() jdtls.extract_constant(true) end, "Extract Constant" },
                v = { function() jdtls.extract_variable(true) end, "Extract Variable" },
              },
            }
            
            wk.register(mappings, opts)
            wk.register(vmappings, vopts)
          end
        end,
        
        -- Attach jdtls-specific handlers
        init_options = {
          bundles = {
            vim.fn.glob(home .. "/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", true),
          },
        },
      }
      
      -- Check if we actually found a root directory
      if not root_dir then
        print("Warning: No Java project root found. Using current directory.")
      end
      
      -- Start the server on java file open
      jdtls.start_or_attach(config)
    end,
  }
}


