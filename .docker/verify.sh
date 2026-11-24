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
tools=(nvim lazygit yazi ya gh node npm cargo rustc tree-sitter rg fzf herdr fish mise chezmoi)
[ "$(uname)" = Linux ] && tools+=(code-server)
for t in "${tools[@]}"; do
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

if [ "$(uname)" = Linux ] && [ "$(chezmoi execute-template '{{ .noRoot }}')" != "true" ]; then
   echo "== X11 apps and libraries"
   for t in xauth xclip xsel xdpyinfo xeyes; do
      command -v "$t" >/dev/null && pass "$t" || fail "$t missing"
   done
   libs="$(ldconfig -p)"
   for lib in libgtk-3.so.0 libQt5Gui.so.5 libnss3.so libxcb-cursor.so.0 libasound.so.2; do
      [[ "$libs" == *"$lib "* ]] && pass "$lib" || fail "$lib missing"
   done
fi

if [ "$(chezmoi execute-template '{{ .xpra }}')" = "true" ]; then
   echo "== xpra browser display"
   num="$(chezmoi execute-template '{{ .xpraDisplay.number }}')"
   port="$(chezmoi execute-template '{{ .xpraDisplay.port }}')"
   size="$(chezmoi execute-template '{{ .xpraDisplay.size }}')"
   unit="$HOME/.config/systemd/user/xpra-display.service"
   [ -f "$unit" ] && pass "systemd user unit" || fail "missing $unit"
   bash -ic 'echo "$DISPLAY"' 2>/dev/null | grep -qx ":$num" && pass "bash DISPLAY=:$num" || fail "bash DISPLAY not :$num"
   [ "$(fish -c 'echo $DISPLAY')" = ":$num" ] && pass "fish DISPLAY=:$num" || fail "fish DISPLAY not :$num"
   # Start it the way the unit does (no systemd in containers) and check it serves.
   start="$(sed -n '/^ExecStart=/,/[^\\]$/p' "$unit" | sed 's/^ExecStart=//; s/\\$//' | tr -d '\n')"
   $start >/tmp/xpra-verify.log 2>&1 &
   for _ in $(seq 30); do curl -fs "http://127.0.0.1:$port/" >/dev/null && break; sleep 1; done
   curl -fs "http://127.0.0.1:$port/" | grep -qi '<html' && pass "HTML5 client on :$port" || { fail "HTML5 client not served on :$port"; tail /tmp/xpra-verify.log; }
   dims="$(DISPLAY=":$num" xdpyinfo 2>/dev/null | awk '/dimensions:/{print $2}')"
   [ "$dims" = "$size" ] && pass "display :$num is $dims" || fail "display :$num is '$dims', expected $size"
   xpra stop ":$num" >/dev/null 2>&1
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
