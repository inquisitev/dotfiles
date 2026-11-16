-- Clipboard: every yank (y / yanky) goes to the system clipboard.
--
-- Over SSH (e.g. WezTerm on Windows -> ssh -> Linux) there is no system
-- clipboard on the remote, so copies are sent to the local terminal with OSC 52,
-- which writes the *Windows* clipboard. Works through tmux too (see
-- set-clipboard in ~/.tmux.conf).
--
-- Pasting: terminals don't let programs read the clipboard back over OSC 52
-- (WezTerm ignores the query), so `p` pastes nvim's own last yank and pasting
-- from Windows into the remote is the terminal's paste (Ctrl+Shift+V), which
-- arrives as bracketed paste.
--
-- Locally, nvim's built-in provider (pbcopy / wl-copy / xclip / win32yank) is
-- used unchanged.
vim.opt.clipboard = "unnamedplus"

local in_ssh = vim.env.SSH_TTY ~= nil or vim.env.SSH_CONNECTION ~= nil
if not in_ssh then
  return
end

local osc52 = require("vim.ui.clipboard.osc52")

-- Return nvim's last yank instead of an empty paste (the old provider returned
-- nothing here, so `p` with clipboard=unnamedplus pasted nothing).
local function paste_last_yank()
  return { vim.fn.split(vim.fn.getreg('"'), "\n"), vim.fn.getregtype('"') }
end

vim.g.clipboard = {
  name = "OSC 52 (ssh)",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = {
    ["+"] = paste_last_yank,
    ["*"] = paste_last_yank,
  },
}
