local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/dap.fnl"
local _2amodule_name_2a = "plugin.dap"
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
local dap, dapui, nvim, virtual = require("dap"), require("dapui"), require("aniseed.nvim"), require("nvim-dap-virtual-text")
do end (_2amodule_locals_2a)["dap"] = dap
_2amodule_locals_2a["dapui"] = dapui
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["virtual"] = virtual
virtual.setup({commented = true})
dapui.setup()
local function _1_()
  return dapui.open()
end
dap.listeners.after.event_initialized["dapui_config"] = _1_
local function _2_()
  return dapui.close()
end
dap.listeners.before.event_terminated["dapui_config"] = _2_
local function _3_()
  return dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = _3_
return _2amodule_2a