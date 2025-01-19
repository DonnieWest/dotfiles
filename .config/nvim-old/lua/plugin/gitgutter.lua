local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/gitgutter.fnl"
local _2amodule_name_2a = "plugin.gitgutter"
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
local au, nvim, z, _ = require("zest.au"), require("aniseed.nvim"), require("zest.lib"), nil
_2amodule_locals_2a["au"] = au
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["z"] = z
_2amodule_locals_2a["_"] = _
local function _1_()
  return nvim.command("GitGutter")
end
au["set-au"]({"BufWritePost"}, {"*"}, _1_)
local function _2_()
  return nvim.command("GitGutterAll")
end
au["set-au-user"]({"NeogitStatusRefreshed"}, _2_)
nvim.g.gitgutter_max_signs = 10000
return _2amodule_2a