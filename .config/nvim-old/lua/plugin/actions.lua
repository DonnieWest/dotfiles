local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/actions.fnl"
local _2amodule_name_2a = "plugin.actions"
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
local actions, core, nvim = require("actions"), require("aniseed.core"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["actions"] = actions
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["nvim"] = nvim
local function _1_()
  return {filetypes = {"help"}, steps = {("echo 'Current file: " .. vim.fn.expand("%:p") .. "'")}}
end
actions.setup({log_level = vim.log.levels.INFO, actions = {["Example action"] = _1_}})
return _2amodule_2a