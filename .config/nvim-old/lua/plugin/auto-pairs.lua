local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/auto-pairs.fnl"
local _2amodule_name_2a = "plugin.auto-pairs"
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
local autopairs, core, nvim = require("nvim-autopairs"), require("aniseed.core"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["autopairs"] = autopairs
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["nvim"] = nvim
autopairs.setup({check_ts = true})
local lisps = {"scheme", "lisp", "clojure", "fennel"}
(autopairs.get_rules("'"))[1]["not_filetypes"] = lisps
local backrules = autopairs.get_rules("`")
backrules[1]["not_filetypes"] = lisps
return _2amodule_2a