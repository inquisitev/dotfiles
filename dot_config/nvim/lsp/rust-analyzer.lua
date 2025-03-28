return {
  cmd = { 'rust-analyzer' },
  filetypes = { 'rust' },
  root_markers = {
    'Cargo.toml',
    'rust-project.json',
  },
  settings = {
    ['rust-analyzer'] = {
      assist = {
        importGranularity = "module",
        importPrefix = "self",
      },
      cargo = {
        loadOutDirsFromCheck = true,
        allFeatures = true,
      },
      procMacro = {
        enable = true,
      },
      checkOnSave = {
        command = "clippy",
      },
    },
  },
}
