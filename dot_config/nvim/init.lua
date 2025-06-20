-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")

vim.diagnostic.config({ virtual_text = false })
-- require("gitblame").setup({
--   --Note how the `gitblame_` prefix is omitted in `setup`
--   enabled = false,
-- })
