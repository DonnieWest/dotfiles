(set vim.opt_local.spell true)
(set vim.opt_local.textwidth 72)

(local prompt-template
       "Analyze these git staged changes and generate a concise conventional commit message.
Follow the format: <type>(<scope>): <subject>

Types: feat, fix, refactor, docs, style, test, chore, perf

Output ONLY the raw commit message with no markdown, no code blocks, no backticks, no explanations.

Staged changes:
%s

Generate a single-line commit message following conventional commits format. Keep it under 72 characters. Focus on what changed and why.")

(fn generate-commit-message []
  (let [bufnr (vim.api.nvim_get_current_buf)
        lines (vim.api.nvim_buf_get_lines bufnr 0 -1 false)
        cmd "git diff --staged"
        handle (io.popen cmd)
        diff-content (handle:read :*a)]
    (handle:close)
    (var has-content false)
    (each [_ line (ipairs lines)]
      (when (and (not= line "") (not (line:match "^#")))
        (set has-content true)))
    (when has-content
      (vim.notify "Commit buffer already has content" vim.log.levels.WARN)
      (lua :return))
    (when (= diff-content "")
      (vim.notify "No staged changes found" vim.log.levels.WARN)
      (lua :return))
    (let [prompt (string.format prompt-template diff-content)
          opencode-cmd (string.format "opencode run --model opencode/minimax-m2.1-free %s"
                                      (vim.fn.shellescape prompt))
          result (io.popen opencode-cmd)
          response (result:read :*a)]
      (result:close)
      (vim.notify (string.format "Raw: '%s'" response) vim.log.levels.DEBUG)
      (var commit-msg (response:gsub "^%s*(.-)%s*$" "%1"))
      (set commit-msg (commit-msg:gsub "`" ""))
      (set commit-msg (commit-msg:gsub "```" ""))
      (set commit-msg (or (commit-msg:match "^(.+)$") commit-msg))
      (when (= commit-msg "")
        (vim.notify "OpenCode returned empty message" vim.log.levels.WARN)
        (lua :return))
      (let [new-lines [commit-msg]
            _ (each [_ line (ipairs lines)]
                (when (line:match "^#")
                  (table.insert new-lines line)))]
        (vim.api.nvim_buf_set_lines bufnr 0 -1 false new-lines)
        (vim.notify "Commit message generated!" vim.log.levels.INFO)))))

(vim.api.nvim_create_user_command :OpencodeCommit generate-commit-message {})

(vim.keymap.set :n :<leader>gc generate-commit-message
                {:buffer true :desc "Generate commit message with OpenCode"})
