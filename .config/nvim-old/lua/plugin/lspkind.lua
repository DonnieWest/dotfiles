local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/lspkind.fnl"
local _2amodule_name_2a = "plugin.lspkind"
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
local lspkind, nvim = require("lspkind"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["lspkind"] = lspkind
_2amodule_locals_2a["nvim"] = nvim
lspkind.init({symbol_map = {Text = "\238\152\146", Method = "\239\131\167", Function = "\239\128\147", Constructor = "\239\134\178", Field = "\239\130\173", Variable = "\239\132\161", Class = "\239\131\168", Interface = "\239\135\160", Module = "\239\134\178", Property = "\239\130\173", Unit = "unit", Value = "val", Enum = "\239\135\160", Keyword = "keyword", Snippet = "\239\172\140", Color = "color", File = "\239\128\173", EnumMember = "\239\134\178", Constant = "\239\132\161", Struct = "\238\152\142"}})
return _2amodule_2a