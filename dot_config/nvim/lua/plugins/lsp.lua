local M = {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Mappings
      local opts = { noremap = true, silent = true }

vim.lsp.config("lua_ls", {
   settings = {
      Lua = {
         runtime = { version = "LuaJIT" },
         diagnostics = { globals = { "vim", "require" } },
         workspace = { library = vim.api.nvim_get_runtime_file("", true) },
         telemetry = { enable = false },
      },
   },
})

vim.lsp.config("clangd", {
   cmd = { "clangd", "--background-index", "--clang-tidy" },
   capabilities = vim.lsp.protocol.make_client_capabilities(),
})

vim.lsp.config("pyright", {
   settings = {
      python = {
         analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "workspace",
         },
      },
   },
})

vim.lsp.config("rust_analyzer", {
   settings = {
      ["rust-analyzer"] = {
         cargo = { allFeatures = true },
         check = { command = "clippy" },
      },
   },
})

vim.lsp.config("qmlls", {
   cmd = { "qmlls" },
   filetypes = { "qml" },
   root_markers = { ".git", "CMakeLists.txt" },
})

vim.lsp.config("cmake", {
   cmd = { "cmake-language-server" },
   filetypes = { "cmake" },
   init_options = {
      buildDirectory = "build",
   },
})

vim.lsp.enable({ "pyright", "qmlls", "clangd" })
    end,
  },

  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer", -- source for buffer words
      "hrsh7th/cmp-path", -- source for file system paths
      "hrsh7th/cmp-cmdline", -- source for vim's cmdline
      "hrsh7th/cmp-nvim-lsp", -- source for neovim's built-in LSP
      "L3MON4D3/LuaSnip", -- snippet engine
      "saadparwaiz1/cmp_luasnip", -- for autocompletion
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Custom styling for the completion menu
      vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#3b4261" })
      vim.api.nvim_set_hl(0, "CmpDocBorder", { fg = "#3b4261" })
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#282c34", fg = "NONE" })
      vim.api.nvim_set_hl(0, "Pmenu", { bg = "#1a1b26", fg = "#c0caf5" })
      vim.api.nvim_set_hl(0, "CmpItemAbbr", { fg = "#abb2bf", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { fg = "#61afef", bg = "NONE", bold = true })
      vim.api.nvim_set_hl(0, "CmpItemKind", { fg = "#c678dd", bg = "NONE" })
      vim.api.nvim_set_hl(0, "CmpItemMenu", { fg = "#7f849c", bg = "NONE", italic = true })

      local window_bordered = cmp.config.window.bordered({
        border = "single",
        winhighlight = "Normal:Normal,FloatBorder:CmpBorder,CursorLine:PmenuSel,Search:None",
      })

      -- Kind icons
      local kind_icons = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
      }

      cmp.setup({
        window = {
          completion = window_bordered,
          documentation = window_bordered,
        },
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },

          { name = "copilot" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
          { name = "path" },
        }),
        formatting = {
          format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)

            -- Source
            vim_item.menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snippet]",
              path = "[Path]",
            })[entry.source.name]
            return vim_item
          end,
        },
        experimental = {
          ghost_text = true,
        },
      })
      local has_words_before = function()
        if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then
          return false
        end
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match("^%s*$") == nil
      end
      cmp.setup({
        mapping = {
          ["<Tab>"] = vim.schedule_wrap(function(fallback)
            if cmp.visible() and has_words_before() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end),
        },
      })

      -- Set configuration for specific filetype.
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "git" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Use buffer source for `/` and `?`
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Use cmdline & path source for ':'
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    build = "make install_jsregexp",
    dependencies = {
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()
    end,
  },
  {
    "saghen/blink.cmp",
    enabled = false,
  },
  {
    "rachartier/tiny-inline-diagnostic.nvim",
    event = "VeryLazy", -- Or `LspAttach`
    priority = 1000, -- needs to be loaded in first
    config = function()
      require("tiny-inline-diagnostic").setup({
        signs = {
          left = "",
          right = "",
          diag = "●",
          arrow = "    ",
          up_arrow = "    ",
          vertical = " │",
          vertical_end = " └",
        },
        blend = {
          factor = 0.22,
        },
      })
    end,
  },
}



return M
