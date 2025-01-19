local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/lightline.fnl"
local _2amodule_name_2a = "plugin.lightline"
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
local devicon, nu, nvim = require("nvim-web-devicons"), require("aniseed.nvim.util"), require("aniseed.nvim")
do end (_2amodule_locals_2a)["devicon"] = devicon
_2amodule_locals_2a["nu"] = nu
_2amodule_locals_2a["nvim"] = nvim
local function expand(s)
  return nvim.fn.expand(s)
end
_2amodule_locals_2a["expand"] = expand
local function readonly()
  if (nvim.bo.readonly and (nvim.bo.filetype ~= "help")) then
    return "RO"
  else
    return ""
  end
end
_2amodule_2a["readonly"] = readonly
local function nearest_method()
  return (nvim.b.vista_nearest_method_or_function or "")
end
_2amodule_2a["nearest-method"] = nearest_method
local function bridge(from, to)
  return nu["fn-bridge"](from, "plugin.lightline", to, {["return"] = true})
end
_2amodule_locals_2a["bridge"] = bridge
bridge("LightlineReadonly", "readonly")
bridge("LspStatus", "lspstatus")
bridge("NearestMethodOrFunction", "nearest-method")
nvim.g["lightline#bufferline#enable_devicons"] = 1
nvim.g["lightline#bufferline#show_number"] = 0
nvim.g["lightline#bufferline#shorten_path"] = 1
nvim.g.lightline_buffer_enable_devicons = 1
nvim.g.lightline = {colorscheme = "base16_nvim", separator = {left = "\238\130\176", right = "\238\130\178"}, subseparator = {left = "\238\130\177", right = "\238\130\179"}, component_function = {gitbranch = "FugitiveHead", method = "NearestMethodOrFunction", readonly = "LightlineReadonly"}, component_expand = {buffers = "lightline#bufferline#buffers", file_type_symbol = "WebDevIconsGetFileTypeSymbol", lsp_warnings = "lightline#lsp#warnings", lsp_errors = "lightline#lsp#errors", lsp_info = "lightline#lsp#info", lsp_hints = "lightline#lsp#hints", lsp_ok = "lightline#lsp#ok", lsp_status = "lightline#lsp#status", gradle_errors = "lightline#gradle#errors", gradle_warnings = "lightline#gradle#warnings", gradle_running = "lightline#gradle#running", gradle_project = "lightline#gradle#project"}, component_type = {buffers = "tabsel", gradle_errors = "error", gradle_warnings = "warning", gradle_running = "left", gradle_project = "right"}, tabline = {left = {{"buffers"}}, right = {{}}}, active = {left = {{"mode", "paste"}, {"gitbranch", "readonly", "filename", "modified", "method"}}, right = {{"lineinfo"}, {"percent"}, {"lsp_status", "lsp_warnings", "lsp_errors", "lsp_info", "lsp_hints", "lsp_ok"}, {"fileformat", "fileencoding", "filetype", "file_type_symbol"}}}, inactive = {right = {{"lineinfo"}, {"percent"}, {"lsp_status"}}}}
return _2amodule_2a