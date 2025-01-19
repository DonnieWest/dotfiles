local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/formatter.fnl"
local _2amodule_name_2a = "plugin.formatter"
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
local defaults, formatter, mapping, nvim, util = require("formatter.defaults"), require("formatter"), require("mapping"), require("aniseed.nvim"), require("formatter.util")
do end (_2amodule_locals_2a)["defaults"] = defaults
_2amodule_locals_2a["formatter"] = formatter
_2amodule_locals_2a["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["util"] = util
mapping.noremap("n", "<leader>fm", ":Format<CR>")
local function _1_()
  return {exe = "fnlfmt", args = {"-"}, stdin = true}
end
local function _2_()
  return {exe = "ktfmt", args = {"-"}, stdin = true}
end
formatter.setup({filetype = {fennel = {_1_}, javascript = util.copyf(defaults.prettier), kotlin = {_2_}}})
return _2amodule_2a