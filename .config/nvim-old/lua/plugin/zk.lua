local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/zk.fnl"
local _2amodule_name_2a = "plugin.zk"
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
local nvim, zk = require("aniseed.nvim"), require("zk")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["zk"] = zk
zk.setup({picker = "telescope"})
return _2amodule_2a