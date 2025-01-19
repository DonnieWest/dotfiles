local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/codecompanion.fnl"
local _2amodule_name_2a = "plugin.codecompanion"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local adapters, codecompanion, nvim = require("codecompanion.adapters"), require("codecompanion"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["adapters"] = adapters
_2amodule_locals_2a["codecompanion"] = codecompanion
_2amodule_locals_2a["nvim"] = nvim
local function _1_()
  return adapters.extend("ollama", {name = "codellama", schema = {model = {default = "qwen2.5-coder:7b"}, num_ctx = {default = -1}, num_predict = {default = -1}}})
end
codecompanion.setup({strategies = {chat = {adapter = "codellama"}, inline = {adapter = "codellama"}}, adapters = {codellama = _1_}})
vim.api.nvim_set_keymap("n", "<C-a>", "<cmd>CodeCompanionActions<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<C-a>", "<cmd>CodeCompanionActions<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("n", "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "<LocalLeader>a", "<cmd>CodeCompanionChat Toggle<cr>", {noremap = true, silent = true})
vim.api.nvim_set_keymap("v", "ga", "<cmd>CodeCompanionChat Add<cr>", {noremap = true, silent = true})
return _2amodule_2a