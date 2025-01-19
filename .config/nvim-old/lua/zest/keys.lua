local _2afile_2a = "/home/igneo676/.config/nvim/fnl/zest/keys.fnl"
local _2amodule_name_2a = "zest.keys"
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
local z, _ = require("zest.lib"), nil
_2amodule_locals_2a["z"] = z
_2amodule_locals_2a["_"] = _
local _id = 0
local function set_keymaps(modes, options, lhs, rhs)
  for mode in modes:gmatch(".") do
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
  end
  return nil
end
_2amodule_locals_2a["set-keymaps"] = set_keymaps
local function map_keys(modes, ...)
  local params = {...}
  local rhs = table.remove(params)
  local lhs = table.remove(params)
  local params0 = unpack(params)
  local opts = {noremap = true}
  if z["full?"](params0) then
    for _0, o in ipairs(params0) do
      if (o == "remap") then
        opts["noremap"] = false
      else
        opts[o] = true
      end
    end
  else
  end
  if z["string?"](rhs) then
    return set_keymaps(modes, opts, lhs, rhs)
  else
    local cm
    if opts.expr then
      local z_16_auto = require("zest.lib")
      local id_17_auto = ("__" .. z_16_auto.count(_Z.fn))
      do end (_G)["_Z"]["fn"][id_17_auto] = rhs
      cm = ("v:lua._Z.fn." .. id_17_auto .. "()")
    else
      local function _3_(...)
        local z_16_auto = require("zest.lib")
        local id_17_auto = ("__" .. z_16_auto.count(_Z.fn))
        do end (_G)["_Z"]["fn"][id_17_auto] = rhs
        return ("v:lua._Z.fn." .. id_17_auto .. "()")
      end
      cm = (":call " .. _3_(...) .. "<cr>")
    end
    return set_keymaps(modes, opts, lhs, cm)
  end
end
_2amodule_locals_2a["map-keys"] = map_keys
do
  local k = z["index-as-method"](map_keys)
  k.leader = function(key)
    vim.g.mapleader = key
    return nil
  end
end
return _2amodule_2a