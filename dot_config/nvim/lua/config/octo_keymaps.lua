-- Octo (plugins/octo.lua), under <leader>g for GitHub.
-- In a PR: <leader>gr starts a review, then use the review buffer's own keys
-- (<localleader>ca to comment, ]q/[q between files); <leader>gR submits.
local function map(lhs, cmd, desc)
   vim.keymap.set("n", lhs, "<cmd>Octo " .. cmd .. "<cr>", { desc = desc })
end

map("<leader>go", "", "GitHub: all Octo commands")
map("<leader>gp", "pr list", "GitHub: pull requests")
map("<leader>gP", "pr search", "GitHub: search pull requests")
map("<leader>gc", "pr checkout", "GitHub: check out this PR")
map("<leader>gd", "pr diff", "GitHub: PR diff")
map("<leader>gk", "pr checks", "GitHub: PR checks (CI)")
map("<leader>gr", "review start", "GitHub: start review")
map("<leader>gR", "review submit", "GitHub: submit review")
map("<leader>gi", "issue list", "GitHub: issues")
map("<leader>gn", "pr create", "GitHub: new pull request")
