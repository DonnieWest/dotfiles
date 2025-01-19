local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/cmp-ai.fnl"
local _2amodule_name_2a = "plugin.cmp-ai"
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
local ai, nvim = require("cmp_ai.config"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["ai"] = ai
_2amodule_locals_2a["nvim"] = nvim
local function _1_(msg)
  return vim.notify(msg)
end
local function _2_(lines_before, lines_after)
  return ("<|fim_prefix|>" .. lines_before .. "<|fim_suffix|>" .. lines_after .. "<|fim_middle|>")
end
ai:setup({max_lines = 100, notify = true, notify_callback = _1_, provider = "Ollama", provider_options = {model = "qwen2.5-coder:3b-large-ctx", prompt = _2_}, run_on_every_keystroke = false})
return _2amodule_2a