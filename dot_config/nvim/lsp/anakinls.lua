return {
  cmd = { "anakinls" },
  filetypes = { "python" },
  root_dir = function(fname)
    return vim.fs.root(fname, { "pyproject.toml", "setup.py", ".git", "requirements.txt" })
  end,
  -- settings = {
  --   anakinls = {
  --
  --   }
  -- },
  capabilities = vim.lsp.protocol.make_client_capabilities(),
  }
