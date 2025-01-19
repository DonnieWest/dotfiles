local _2afile_2a = "/home/igneo676/.config/nvim/fnl/util.fnl"
local _2amodule_name_2a = "util"
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
local nvim = require("aniseed.nvim")
do end (_2amodule_locals_2a)["nvim"] = nvim
local function expand(path)
  return nvim.fn.expand(path)
end
_2amodule_2a["expand"] = expand
local function glob(path)
  return nvim.fn.glob(path, true, true, true)
end
_2amodule_2a["glob"] = glob
local function exists_3f(path)
  return (nvim.fn.filereadable(path) == 1)
end
_2amodule_2a["exists?"] = exists_3f
local function lua_file(path)
  return nvim.ex.luafile(path)
end
_2amodule_2a["lua-file"] = lua_file
local config_path = nvim.fn.stdpath("config")
do end (_2amodule_2a)["config-path"] = config_path
local function nnoremap(from, to)
  return nvim.set_keymap("n", ("<leader>" .. from), (":" .. to .. "<cr>"), {noremap = true})
end
_2amodule_2a["nnoremap"] = nnoremap
return _2amodule_2a