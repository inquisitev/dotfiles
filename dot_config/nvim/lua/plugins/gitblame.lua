vim.pack.add({
   "https://github.com/f-person/git-blame.nvim",
})

require('gitblame').setup {
  enabled = true,
  message_template = " <summary> • <date> • <author> • <<sha>>",
  date_format = "%m-%d-%Y %H:%M:%S",
  display_virtual_text = 0, -- disable inline virtual text
}
