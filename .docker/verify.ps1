# Windows counterpart of verify.sh (no fish / login shell checks).
$ErrorActionPreference = "Continue"
$env:Path = "$HOME\.local\bin;$env:LOCALAPPDATA\mise\shims;$env:Path"
Set-Location $HOME
$fails = 0
function Pass($m) { Write-Host "ok   $m" -ForegroundColor Green }
function Fail($m) { Write-Host "FAIL $m" -ForegroundColor Red; $script:fails++ }

Write-Host "== tools"
foreach ($t in "nvim","lazygit","yazi","ya","gh","node","npm","cargo","rustc","tree-sitter","rg","fzf","mise","chezmoi") {
    $v = & $t --version 2>&1 | Select-Object -First 1
    if ($LASTEXITCODE -eq 0) { Pass "${t}: $v" } else { Fail "$t not runnable" }
}

Write-Host "== mise: every configured tool installed"
$missing = (mise ls --missing --no-header 2>&1 | Out-String).Trim()
if (-not $missing) { Pass "no missing tools" } else { Fail "missing: $missing" }

Write-Host "== yazi plugins"
foreach ($p in "fast-enter","easyjump","rich-preview","relative-motions") {
    if (Test-Path "$HOME\.config\yazi\plugins\$p.yazi") { Pass "yazi $p" } else { Fail "yazi plugin $p missing" }
}

Write-Host "== nvim starts cleanly and installs locked plugins"
$log = nvim --headless +qa 2>&1 | Out-String
if ($log -match "(?m)^E\d+:|Error") { Fail "nvim reported errors:`n$log" } else { Pass "nvim first start" }
$lock = Get-Content "$HOME\.config\nvim\nvim-pack-lock.json" -Raw | ConvertFrom-Json
$pack = "$env:LOCALAPPDATA\nvim-data\site\pack\core\opt"
$bad = 0
foreach ($p in $lock.plugins.PSObject.Properties) {
    $have = git -C "$pack\$($p.Name)" rev-parse HEAD 2>$null
    if ($have -ne $p.Value.rev) { Write-Host "     $($p.Name): lock $($p.Value.rev), installed $have"; $bad++ }
}
if ($bad -eq 0) { Pass "all nvim plugins match the lockfile" } else { Fail "$bad nvim plugin(s) differ from lockfile" }

Write-Host "== idempotent"
$status = (chezmoi status 2>&1 | Out-String).Trim()
if (-not $status) { Pass "chezmoi status clean" } else { Fail "chezmoi status not clean:`n$status" }
chezmoi verify
if ($LASTEXITCODE -eq 0) { Pass "chezmoi verify" } else { Fail "chezmoi verify (managed files drifted)" }

if ($fails -eq 0) { Write-Host "`nALL CHECKS PASSED" } else { Write-Host "`n$fails CHECK(S) FAILED"; exit 1 }
