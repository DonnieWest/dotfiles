local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/package-info.fnl"
local _2amodule_name_2a = "plugin.package-info"
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
local core, nvim, package = require("aniseed.core"), require("aniseed.nvim"), require("package-info")
do end (_2amodule_locals_2a)["core"] = core
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["package"] = package
package.setup()
local function _1_()
  return package.show()
end
vim.api.nvim_create_autocmd({"BufEnter", "BufWritePost"}, {pattern = "package.json", callback = _1_})
return _2amodule_2a