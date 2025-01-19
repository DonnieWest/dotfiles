local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/conjure.fnl"
local _2amodule_name_2a = "plugin.conjure"
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
local ceval, core, nvim, z = require("conjure.eval"), require("aniseed.core"), require("aniseed.nvim"), require("zest.lib")
do end (_2amodule_locals_2a)["ceval"] = ceval
_2amodule_locals_2a["core"] = core
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["z"] = z
nvim.g["conjure#eval#result_register"] = "*"
nvim.g["conjure#log#botright"] = true
nvim.g["conjure#log#hud#enabled"] = true
nvim.g["conjure#log#hud#height"] = 0.2
nvim.g["conjure#extract#tree_sitter#enabled"] = true
nvim.g["conjure#filetype#python"] = false
nvim.g["conjure#filetype#rust"] = false
nvim.g["conjure#mapping#enable_ft_mappings"] = false
nvim.ex.autocmd("FileType", "clojure,fennel,scheme", "nnoremap <silent> gd    <cmd>:ConjureDefWord<CR>")
nvim.ex.autocmd("FileType", "clojure,scheme", "nnoremap <silent> <c-]> <cmd>:ConjureDefWord<CR>")
nvim.ex.autocmd("FileType", "clojure,fennel,scheme", "nnoremap <silent> K     <cmd>:ConjureDocWord<CR>")
nvim.ex.autocmd("FileType", "clojure,fennel,scheme", "nnoremap <silent> gD    <cmd>:ConjureCljViewSource<CR>")
local symbol_map = {T = "\238\152\146", M = "\239\131\167", F = "\239\128\147", V = "\239\132\161", ["function"] = "\239\128\147", boolean = "\239\132\161", table = "\239\130\173"}
_2amodule_2a["symbol-map"] = symbol_map
local function includes(col, val)
  if core["string?"](col) then
    return not core["nil?"](col:find(val))
  elseif core["table?"](col) then
    local function _1_(_241)
      return (_241 == val)
    end
    return not core["nil?"](find(_1_, col))
  else
    return false
  end
end
_2amodule_locals_2a["includes"] = includes
local pattern_regex = vim.regex("[0-9a-zA-Z.!$%&*+/:<=>?#_~\\^\\-\\\\]\\+$")
do end (_2amodule_2a)["pattern-regex"] = pattern_regex
local source_conf = {priority = 1000, filetypes = {"fennel", "clojure", "racket", "janet"}, menu = "[conjure]", dub = false}
_2amodule_locals_2a["source-conf"] = source_conf
local function determine(_, _3_)
  local _arg_4_ = _3_
  local before_char = _arg_4_["before_char"]
  local before_line = _arg_4_["before_line"]
  local col = _arg_4_["col"]
  local offset = pattern_regex:match_str(before_line)
  local has_dot = includes(before_char, "%.")
  local has_slash = includes(before_char, "/")
  local trigger
  if (has_dot or has_slash) then
    trigger = col
  else
    trigger = 0
  end
  if core["nil?"](offset) then
    return {}
  else
    return {keyword_pattern_offset = (offset + 1), trigger_character_offset = trigger}
  end
end
_2amodule_locals_2a["determine"] = determine
local function complete(_, _7_)
  local _arg_8_ = _7_
  local context = _arg_8_["context"]
  local keyword_pattern_offset = _arg_8_["keyword_pattern_offset"]
  local callback = _arg_8_["callback"]
  local input = context:get_input(keyword_pattern_offset)
  local function _9_(items)
    local kind_items
    local function _10_(item)
      return core.assoc(item, "kind", (symbol_map[item.kind] or item.kind))
    end
    kind_items = z.map(_10_, items)
    return callback({items = kind_items})
  end
  return ceval.completions(input, _9_)
end
_2amodule_locals_2a["complete"] = complete
local function documentation(_, _11_)
  local _arg_12_ = _11_
  local completed_item = _arg_12_["completed_item"]
  local callback = _arg_12_["callback"]
  local abort = _arg_12_["abort"]
  local content = completed_item.info
  if (content ~= "") then
    return callback(content)
  else
    return abort()
  end
end
_2amodule_locals_2a["documentation"] = documentation
local source
local function _14_()
  return source_conf
end
source = {get_metadata = _14_, documentation = documentation, complete = complete, determine = determine}
_2amodule_2a["source"] = source
return _2amodule_2a