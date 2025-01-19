local _2afile_2a = "/home/igneo676/.config/nvim/fnl/zest/lib.fnl"
local _2amodule_name_2a = "zest.lib"
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
local config_path = vim.fn.stdpath("config")
do end (_2amodule_2a)["config-path"] = config_path
local function glob(path)
  return vim.fn.glob(path, true, true, true)
end
_2amodule_2a["glob"] = glob
local function exec(cmd)
  return vim.api.nvim_command(cmd)
end
_2amodule_2a["exec"] = exec
local function norm(cmd)
  return vim.api.nvim_command(("norm! " .. cmd))
end
_2amodule_2a["norm"] = norm
local function eval(str)
  return vim.api.nvim_eval(str)
end
_2amodule_2a["eval"] = eval
local fn_ = vim.fn
_2amodule_2a["fn-"] = fn_
local function nil_3f(x)
  return (nil == x)
end
_2amodule_2a["nil?"] = nil_3f
local function string_3f(x)
  return ("string" == type(x))
end
_2amodule_2a["string?"] = string_3f
local function table_3f(x)
  return ("table" == type(x))
end
_2amodule_2a["table?"] = table_3f
local function sequential_3f(xs)
  local i = 0
  for _ in pairs(xs) do
    i = (i + 1)
    if nil_3f(xs[i]) then
      return false
    else
    end
  end
  return true
end
_2amodule_2a["sequential?"] = sequential_3f
local function function_3f(x)
  return ("function" == type(x))
end
_2amodule_2a["function?"] = function_3f
local function bool_3f(x)
  return ("boolean" == type(x))
end
_2amodule_2a["bool?"] = bool_3f
local function number_3f(x)
  return (type(x) == "number")
end
_2amodule_2a["number?"] = number_3f
local function count(xs)
  if table_3f(xs) then
    local maxn = 0
    for k, v in pairs(xs) do
      maxn = (maxn + 1)
    end
    return maxn
  elseif not xs then
    return 0
  else
    return #xs
  end
end
_2amodule_2a["count"] = count
local function run_21(f, xs)
  if xs then
    local nxs = count(xs)
    if (nxs > 0) then
      for i = 1, nxs do
        f(xs[i])
      end
      return nil
    else
      return nil
    end
  else
    return nil
  end
end
_2amodule_2a["run!"] = run_21
local function reduce(f, init, xs)
  local result = init
  local function _5_(x)
    result = f(result, x)
    return nil
  end
  run_21(_5_, xs)
  return result
end
_2amodule_2a["reduce"] = reduce
local function concat(...)
  local result = {}
  local function _6_(xs)
    local function _7_(x)
      return table.insert(result, x)
    end
    return run_21(_7_, xs)
  end
  run_21(_6_, {...})
  return result
end
_2amodule_2a["concat"] = concat
local function uniq(xs)
  local uniq0 = {}
  local hash = {}
  for _, v in ipairs(xs) do
    if not hash[v] then
      hash[v] = true
      table.insert(uniq0, v)
    else
    end
  end
  return uniq0
end
_2amodule_2a["uniq"] = uniq
local function flatten(t, delimiter)
  local delimiter0 = (delimiter or "")
  if string_3f(t) then
    return t
  else
    if (delimiter0 ~= "") then
      local function _9_(_241, _242)
        return (_241 .. _242 .. delimiter0)
      end
      return string.gsub(reduce(_9_, "", t), ".?$", "")
    else
      local function _10_(_241, _242)
        return (_241 .. _242 .. delimiter0)
      end
      return reduce(_10_, "", t)
    end
  end
end
_2amodule_2a["flatten"] = flatten
local function merge_21(base, ...)
  local function _13_(acc, m)
    if m then
      for k, v in pairs(m) do
        acc[k] = v
      end
    else
    end
    return acc
  end
  return reduce(_13_, (base or {}), {...})
end
_2amodule_2a["merge!"] = merge_21
local function merge(...)
  return merge_21({}, ...)
end
_2amodule_2a["merge"] = merge
local function map(f, xs)
  local result = {}
  local function _15_(x)
    local mapped = f(x)
    local function _16_()
      if (0 == select("#", mapped)) then
        return nil
      else
        return mapped
      end
    end
    return table.insert(result, _16_())
  end
  run_21(_15_, xs)
  return result
end
_2amodule_2a["map"] = map
local function empty_3f(xs)
  return (0 == count(xs))
end
_2amodule_2a["empty?"] = empty_3f
local function full_3f(xs)
  return (0 ~= count(xs))
end
_2amodule_2a["full?"] = full_3f
local function index_as_method(callback)
  local function _17_(self, index)
    local function _18_(...)
      return callback(index, ...)
    end
    self[index] = _18_
    return rawget(self, index)
  end
  return setmetatable({}, {__index = _17_})
end
_2amodule_2a["index-as-method"] = index_as_method
return _2amodule_2a