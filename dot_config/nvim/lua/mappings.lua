require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<", ",", { desc = "CMD enter command mode" })
map("n", ",", ";", { desc = "CMD enter command mode" })
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map("i", "W", "w")


-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map({ "n", "t" }, "<A-i>", function()
    require("nvchad.term").toggle { pos = "float", id = "floatTerm", float_opts={
        row = 0.35,
        col = 0.05,
        width = 0.9,
        height = 0.8
    }}
end, { desc = "terminal toggle floating term" })

map("n", "<A-j>", "<cmd>cnext<CR>", {desc = "quickfix next"})
map("n", "<A-k>", "<cmd>cprev<CR>", {desc = "quickfix previous"})
map("n", "<A-o>", "<cmd>copen<CR>", {desc = "quickfix open"})
map("n", "<A-x>", "<cmd>cclose<CR>", {desc = "quickfix close"})


local util = require 'lspconfig.util'

local function switch_source_header(bufnr)
  local method_name = 'textDocument/switchSourceHeader'
  bufnr = 0
  -- bufnr = util.validate_bufnr(bufnr)
  local client = util.get_active_client_by_name(bufnr, 'clangd')
  if not client then
    return vim.notify(('method %s is not supported by any servers active on the current buffer'):format(method_name))
  end
  local params = vim.lsp.util.make_text_document_params(bufnr)
  client.request(method_name, params, function(err, result)
    if err then
      error(tostring(err))
    end
    if not result then
      vim.notify('corresponding file cannot be determined')
      return
    end
    vim.cmd.edit(vim.uri_to_fname(result))
  end, bufnr)
end

  vim.keymap.set("n", "gs", switch_source_header)

