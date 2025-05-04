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
  local function opts(desc)
    return { buffer = bufnr, desc = "LSP " .. desc }
  end


require "nvchad.mappings"


-- add yours here

local map = vim.keymap.set

map("n", "<leader>e", function() Snacks.explorer() end, {desc = "File Explorer"})
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

map("n", "gD", vim.lsp.buf.declaration, opts "Go to declaration")
map("n", "gd", vim.lsp.buf.definition, opts "Go to definition")
map("n", "gi", vim.lsp.buf.implementation, opts "Go to implementation")
map("n", "<leader>sh", vim.lsp.buf.signature_help, opts "Show signature help")
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts "Add workspace folder")
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts "Remove workspace folder")

map("n", "<leader>D", vim.lsp.buf.type_definition, opts "Go to type definition")
map("n", "<leader>ra", require "nvchad.lsp.renamer", opts "NvRenamer")

map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts "Code action")
map("n", "gr", vim.lsp.buf.references, opts "Show references")


vim.keymap.set("n", "gs", switch_source_header)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {desc='Go to definition'})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {desc='Go to declaration'})
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, {desc='Go to implementation'})
vim.keymap.set('n', 'gt', vim.lsp.buf.type_definition, {desc='Go to type definition'})
vim.keymap.set('n', 'gr', vim.lsp.buf.references, {desc='Go to references'})
vim.keymap.set('n', 'K', vim.lsp.buf.hover, {desc='Show documentation'})
-- vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, {desc='Show signature help'})
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, {desc='Rename symbol'})
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, {desc='Code actions'})
