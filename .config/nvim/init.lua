-- Ensure lazy and hotpot are always installed
local function ensure_installed(plugin, branch)
  local user, repo = string.match(plugin, "(.+)/(.+)")
  local repo_path = vim.fn.stdpath("data") .. "/lazy/" .. repo
  if not (vim.uv or vim.loop).fs_stat(repo_path) then
    vim.notify("Installing " .. plugin .. " " .. branch)
    local repo_url = "https://github.com/" .. plugin .. ".git"
    local out = vim.fn.system({
      "git",
      "clone",
      "--filter=blob:none",
      "--branch=" .. branch,
      repo_url,
      repo_path
    })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone " .. plugin .. ":\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  return repo_path
end
local lazy_path = ensure_installed("folke/lazy.nvim", "stable")
local hotpot_path = ensure_installed("rktjmp/hotpot.nvim", "v0.14.6")
-- As per Lazy's install instructions, but also include hotpot
vim.opt.runtimepath:prepend({hotpot_path, lazy_path})

-- You must call vim.loader.enable() before requiring hotpot unless you are
-- passing {performance = {cache = false}} to Lazy.
vim.loader.enable()

vim.g.mapleader = ","

-- Generate plugins table
local plugins = {
  {
    "rktjmp/hotpot.nvim",
  },
}

-- Configure hotpot.nvim
require("hotpot").setup({
  provide_require_fennel = true,
})

-- Add plugins to table
local plugins_path = vim.fn.stdpath("config") .. "/fnl/custom/plugins"
if vim.loop.fs_stat(plugins_path) then
  for file in vim.fs.dir(plugins_path) do
    local name = file:match("^(.*)%.fnl$")
    if name then
      plugins[#plugins + 1] = require("custom.plugins." .. name)
    end
  end
end

-- Configure lazy.nvim
require("lazy").setup(plugins)
