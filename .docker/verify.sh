#!/usr/bin/env bash
# Verify a machine/container set up by these dotfiles. Used by CI and by hand:
#   docker run --rm dotfiles .local/share/chezmoi/.docker/verify.sh
#   ~/.local/share/chezmoi/.docker/verify.sh            # on a real mac/linux box
set -uo pipefail
export PATH="$HOME/.local/bin:$HOME/.local/share/mise/shims:$PATH"
cd "$HOME"

fails=0
pass() { printf "\033[0;32mok\033[0m   %s\n" "$*"; }
fail() { printf "\033[0;31mFAIL\033[0m %s\n" "$*"; fails=$((fails + 1)); }

echo "== tools"
for t in nvim lazygit yazi ya gh node npm cargo rustc tree-sitter rg fzf fish mise chezmoi; do
   # capture everything, then keep the first line: piping into `head` can
   # SIGPIPE a tool that prints several lines (yazi), which pipefail reports
   if v="$("$t" --version 2>&1)"; then pass "$t: ${v%%$'\n'*}"; else fail "$t not runnable"; fi
done

echo "== mise: every configured tool installed at its pinned version"
missing="$(mise ls --missing --no-header 2>&1)"
[ -z "$missing" ] && pass "no missing tools" || fail "missing: $missing"

if [ "$(chezmoi execute-template '{{ .noRoot }}')" != "true" ]; then
   echo "== login shell"
   if [ "$(uname)" = Darwin ]; then
      shell="$(dscl . -read "/Users/$(id -un)" UserShell | awk '{print $2}')"
   else
      shell="$(getent passwd "$(id -un)" | cut -d: -f7)"
   fi
   [[ "$shell" == */fish ]] && pass "login shell $shell" || fail "login shell is $shell, expected fish"
fi

echo "== fish plugins"
fish -c 'type -q fisher; and functions -q __bobthefish_glyphs' && pass "fisher + bobthefish" || fail "fish plugins missing"

echo "== yazi plugins"
for p in fast-enter easyjump rich-preview relative-motions; do
   [ -d "$HOME/.config/yazi/plugins/$p.yazi" ] && pass "yazi $p" || fail "yazi plugin $p missing"
done

echo "== nvim: plugins install at the commits in nvim-pack-lock.json"
nvim --headless +qa >/tmp/nvim-first-start.log 2>&1 || { fail "nvim first start"; tail /tmp/nvim-first-start.log; }
if grep -qiE '^E[0-9]+:|Error' /tmp/nvim-first-start.log; then
   fail "nvim reported errors on start:"; grep -iE '^E[0-9]+:|Error' /tmp/nvim-first-start.log | head -5
fi
pack="$HOME/.local/share/nvim/site/pack/core/opt"
lock="$HOME/.config/nvim/nvim-pack-lock.json"
mismatches=0
while IFS=$'\t' read -r name rev; do
   have="$(git -C "$pack/$name" rev-parse HEAD 2>/dev/null || echo missing)"
   if [ "$have" != "$rev" ]; then echo "     $name: lock $rev, installed $have"; mismatches=$((mismatches + 1)); fi
done < <(node -e 'for (const [k, v] of Object.entries(require(process.argv[1]).plugins)) console.log(k + "\t" + v.rev)' "$lock")
[ "$mismatches" -eq 0 ] && pass "all nvim plugins match the lockfile" || fail "$mismatches nvim plugin(s) differ from lockfile"

echo "== idempotent: nothing left to apply, no scripts pending"
status="$(chezmoi status 2>&1)"
[ -z "$status" ] && pass "chezmoi status clean" || { fail "chezmoi status not clean:"; echo "$status"; chezmoi diff --no-pager 2>&1 | head -n 60 | sed 's/^/     /'; }
chezmoi verify && pass "chezmoi verify" || fail "chezmoi verify (managed files drifted)"

echo
if [ "$fails" -eq 0 ]; then echo "ALL CHECKS PASSED"; else echo "$fails CHECK(S) FAILED"; exit 1; fi
