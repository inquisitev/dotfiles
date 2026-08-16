local map = vim.keymap.set
local project_clis = {}
local warned_non_git = {}

local function project_for_buffer(bufnr)
   bufnr = bufnr or vim.api.nvim_get_current_buf()

   local directory = vim.uv.cwd() or vim.fn.getcwd()
   local tagged_directory = vim.b[bufnr].codecompanion_project_directory
   local name = vim.api.nvim_buf_get_name(bufnr)
   if type(tagged_directory) == "string" and vim.fn.isdirectory(tagged_directory) == 1 then
      directory = tagged_directory
   elseif vim.bo[bufnr].buftype == "" and name ~= "" then
      local parent = vim.fs.dirname(vim.fs.normalize(name))
      if parent and vim.fn.isdirectory(parent) == 1 then
         directory = parent
      end
   end

   local root = vim.fs.root(directory, ".git")
   return {
      directory = root or directory,
      git_root = root,
   }
end

local function activate_project(project)
   if project.directory and project.directory ~= "" then
      vim.api.nvim_set_current_dir(project.directory)
   end
end

local function warn_non_git(project, force)
   if not force and warned_non_git[project.directory] then
      return
   end

   warned_non_git[project.directory] = true
   vim.notify(
      "Per-hunk AI review needs a Git worktree. Initialize Git, ignore generated files, then start the agent.",
      vim.log.levels.WARN,
      { title = "CodeCompanion Code Review" }
   )
end

local function prepare_agent(project)
   activate_project(project)
   if not project.git_root then
      warn_non_git(project)
      return
   end

   local baseline = require("codecompanion.interactions.code_review.baseline")
   if not baseline.get(project.git_root) and not baseline.snapshot(project.git_root) then
      vim.notify(
         "Could not create the review baseline; agent changes may not be reviewable.",
         vim.log.levels.ERROR,
         { title = "CodeCompanion Code Review" }
      )
   end
end

local function project_cli(agent, project)
   local key = agent .. "\0" .. project.directory
   local instance = project_clis[key]
   if instance and (not vim.api.nvim_buf_is_valid(instance.bufnr) or not instance.provider:is_running()) then
      project_clis[key] = nil
      instance = nil
   end

   if not instance then
      instance = require("codecompanion.interactions.cli").create({ agent = agent })
      if instance then
         vim.b[instance.bufnr].codecompanion_project_directory = project.directory
         project_clis[key] = instance
      end
   end

   return instance
end

local function show_cli(instance)
   if not instance.ui:is_visible() then
      instance.ui:open()
   end
   instance:focus()
end

local function open_cli(agent, label)
   local project = project_for_buffer()
   prepare_agent(project)

   local instance = project_cli(agent, project)
   if not instance then
      vim.notify("Could not start " .. label, vim.log.levels.ERROR)
      return
   end
   show_cli(instance)
end

local function prompt_cli(agent, label, auto_submit)
   local bufnr = vim.api.nvim_get_current_buf()
   local project = project_for_buffer(bufnr)
   activate_project(project)
   local context = require("codecompanion.utils.context").get(bufnr)

   require("codecompanion.interactions.shared.input").open({
      title = " Prompt " .. label .. " ",
      on_submit = function(prompt, submit_opts)
         prepare_agent(project)

         local cli = require("codecompanion.interactions.cli")
         local instance = project_cli(agent, project)
         if not instance then
            vim.notify("Could not start " .. label, vim.log.levels.ERROR)
            return
         end

         if not instance.ui:is_visible() then
            instance.ui:open()
         end

         local submit = auto_submit or submit_opts.bang
         local resolved = cli.resolve_editor_context(prompt, context)
         if not submit and not resolved:match("\n$") then
            resolved = resolved .. "\n"
         end

         instance:send(resolved, { submit = submit })
         if auto_submit or not submit_opts.bang then
            instance:focus()
         end
      end,
   })
end

local function start_review()
   local project = project_for_buffer()
   activate_project(project)
   if not project.git_root then
      warn_non_git(project, true)
      return
   end

   require("codecompanion.interactions.code_review").approve()
end

local function review_all()
   local project = project_for_buffer()
   activate_project(project)
   if not project.git_root then
      warn_non_git(project, true)
      return
   end

   local baseline = require("codecompanion.interactions.code_review.baseline")
   if not baseline.get(project.git_root) then
      vim.notify(
         "No review baseline exists. Start the agent from an AI keymap, or set the baseline before it edits.",
         vim.log.levels.WARN,
         { title = "CodeCompanion Code Review" }
      )
      return
   end

   require("codecompanion.interactions.code_review").open({ scope = "all" })
end

local function comment_review(range)
   activate_project(project_for_buffer())
   require("codecompanion").code_review({
      subcommand = "comment",
      range = range and 1 or 0,
   })
end

local function send_review(agent)
   local bufnr = vim.api.nvim_get_current_buf()
   local project = project_for_buffer(bufnr)
   activate_project(project)

   local cli = require("codecompanion.interactions.cli")
   local instance = project_cli(agent, project)
   if not instance then
      vim.notify("Could not start the review agent", vim.log.levels.ERROR)
      return
   end

   local context = require("codecompanion.utils.context").get(bufnr)
   local prompt = cli.resolve_editor_context("Please action #{code_review}", context)
   instance:send(prompt, { submit = true })
end

local function share_review()
   activate_project(project_for_buffer())
   require("codecompanion.interactions.code_review").share()
end

map({ "n", "x" }, "<leader>aa", "<cmd>CodeCompanionActions<cr>", { desc = "AI actions", silent = true })
map({ "n", "x" }, "<leader>ac", function()
   activate_project(project_for_buffer())
   vim.cmd("CodeCompanionChat Toggle")
end, { desc = "AI Copilot chat" })
map({ "n", "x" }, "<leader>ap", function()
   prompt_cli("copilot_cli", "Copilot CLI")
end, { desc = "AI prompt Copilot CLI" })
map("n", "<leader>at", function()
   open_cli("copilot_cli", "Copilot CLI")
end, { desc = "AI open Copilot CLI" })
map({ "n", "x" }, "<leader>ax", function()
   prompt_cli("codex_cli", "Codex CLI", true)
end, { desc = "AI prompt Codex CLI" })
map("n", "<leader>aX", function()
   open_cli("codex_cli", "Codex CLI")
end, { desc = "AI open Codex CLI" })

map("n", "<leader>as", start_review, { desc = "AI start review baseline" })
map("n", "<leader>ar", review_all, { desc = "AI review all changes" })
map("n", "<leader>am", function()
   comment_review(false)
end, { desc = "AI comment on change" })
map("x", "<leader>am", function()
   comment_review(true)
end, { desc = "AI comment on selection" })
map("n", "<leader>af", function()
   send_review("copilot_cli")
end, { desc = "AI send review to Copilot" })
map("n", "<leader>aF", function()
   send_review("codex_cli")
end, { desc = "AI send review to Codex" })
map("n", "<leader>aS", share_review, { desc = "AI share review externally" })
