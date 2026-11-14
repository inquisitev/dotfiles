#!/usr/bin/env bash
# Quick smoke test for the dotfiles image (seconds, not minutes). The full
# check is verify.sh; this only answers "is the environment usable at all?".
#   docker run --rm dotfiles .local/share/chezmoi/.docker/smoke.sh
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
cd "$HOME"

fails=0
check() {
   local name="$1"
   shift
   if out="$("$@" 2>&1)"; then
      printf "\033[0;32mok\033[0m   %s\n" "$name"
   else
      printf "\033[0;31mFAIL\033[0m %s\n" "$name"
      printf '%s\n' "$out" | tail -n 15 | sed 's/^/     /'
      fails=$((fails + 1))
   fi
}

for t in chezmoi mise fish nvim git rg fzf; do
   check "$t on PATH" "$t" --version
done

check "fish login shell starts" fish -l -c 'exit 0'

# Load the whole config (headless loads every plugin up front) and fail on
# any error message, then make sure the key plugins actually came up.
check "nvim starts with no errors" nvim --headless \
   -c 'lua local m = vim.fn.execute("messages"); if m:find("Error") or m:find("E%d+:") then io.stderr:write(m); vim.cmd("cquit 1") end' \
   -c 'lua for _, mod in ipairs({ "cmp", "telescope", "lualine", "nvim-treesitter" }) do if not package.loaded[mod] then io.stderr:write(mod .. " not loaded\n"); vim.cmd("cquit 1") end end' \
   -c 'qa!'

check "nvim dashboard opens" nvim --headless -c 'Dashboard' \
   -c 'lua if vim.bo.filetype ~= "dashboard" then io.stderr:write("filetype is " .. vim.bo.filetype .. "\n"); vim.cmd("cquit 1") end' \
   -c 'qa!'

check "treesitter highlights lua" nvim --headless "$HOME/.config/nvim/init.lua" \
   -c 'lua if not vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] then io.stderr:write("no treesitter highlighter\n"); vim.cmd("cquit 1") end' \
   -c 'qa!'

check "chezmoi managed files unchanged" chezmoi verify

echo
if [ "$fails" -eq 0 ]; then echo "SMOKE TEST PASSED"; else echo "$fails SMOKE CHECK(S) FAILED"; exit 1; fi
