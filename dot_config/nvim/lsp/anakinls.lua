return {
  cmd = { "anakinls" },
  filetypes = { "python", "py" },
  root_marker =  {"pyproject.toml", "setup.py", ".git", "requirements.txt"},
  -- settings = {
  --   anakinls = {
  --
  --   }
  -- },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  }
