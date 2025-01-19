local _2afile_2a = "/home/igneo676/.config/nvim/fnl/zest/au.fnl"
local _2amodule_name_2a = "zest.au"
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
local id = 0
local function set_au(events, filetypes, action)
  local events0 = z.flatten(events, ",")
  local filetypes0 = z.flatten(filetypes, ",")
  local body
  local function _2_()
    if z["function?"](action) then
      local function _1_()
        local z_16_auto = require("zest.lib")
        local id_17_auto = ("__" .. z_16_auto.count(_Z.fn))
        do end (_G)["_Z"]["fn"][id_17_auto] = action
        return ("v:lua._Z.fn." .. id_17_auto .. "()")
      end
      return (":call " .. _1_())
    else
      return action
    end
  end
  body = ("au " .. events0 .. " " .. filetypes0 .. " " .. _2_())
  id = (id + 1)
  return z["run!"](z.exec, {("augroup " .. id), "autocmd!", body, "augroup end"})
end
_2amodule_2a["set-au"] = set_au
local function set_au_user(events, action)
  local events0 = z.flatten(events, ",")
  local body
  local function _4_()
    if z["function?"](action) then
      local function _3_()
        local z_16_auto = require("zest.lib")
        local id_17_auto = ("__" .. z_16_auto.count(_Z.fn))
        do end (_G)["_Z"]["fn"][id_17_auto] = action
        return ("v:lua._Z.fn." .. id_17_auto .. "()")
      end
      return (":call " .. _3_())
    else
      return action
    end
  end
  body = ("au User " .. events0 .. " " .. _4_())
  id = (id + 1)
  return z["run!"](z.exec, {("augroup " .. id), "autocmd!", body, "augroup end"})
end
_2amodule_2a["set-au-user"] = set_au_user
local function set_au_file(files, action)
  local events = z.flatten(files, ",")
  local body
  local function _6_()
    if z["function?"](action) then
      local function _5_()
        local z_16_auto = require("zest.lib")
        local id_17_auto = ("__" .. z_16_auto.count(_Z.fn))
        do end (_G)["_Z"]["fn"][id_17_auto] = action
        return ("v:lua._Z.fn." .. id_17_auto .. "()")
      end
      return (":call " .. _5_())
    else
      return action
    end
  end
  body = ("au FileType " .. files .. " " .. _6_())
  id = (id + 1)
  return z["run!"](z.exec, {("augroup " .. id), "autocmd!", body, "augroup end"})
end
_2amodule_2a["set-au-file"] = set_au_file
return _2amodule_2a