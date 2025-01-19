local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/lint.fnl"
local _2amodule_name_2a = "plugin.lint"
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
local lint, nvim = require("lint"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["lint"] = lint
_2amodule_locals_2a["nvim"] = nvim
local function _1_()
  return lint.try_lint()
end
vim.api.nvim_create_autocmd({"BufWritePost"}, {callback = _1_})
lint["linters_by_ft"] = {markdown = {}}
return _2amodule_2a