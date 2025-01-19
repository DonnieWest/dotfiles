local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/avante.fnl"
local _2amodule_name_2a = "plugin.avante"
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
local avante, lib, nvim = require("avante"), require("avante_lib"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["avante"] = avante
_2amodule_locals_2a["lib"] = lib
_2amodule_locals_2a["nvim"] = nvim
lib.load()
avante.setup({provider = "ollama", auto_suggestions_provider = "ollama", vendors = {ollama = {__inherited_from = "openai", api_key_name = "", endpoint = "http://127.0.0.1:11434/v1", model = "qwen2.5-coder:3b-large-ctx"}}})
return _2amodule_2a