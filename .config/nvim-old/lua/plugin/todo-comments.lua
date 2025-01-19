local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/todo-comments.fnl"
local _2amodule_name_2a = "plugin.todo-comment"
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
local nvim, todo_comments = require("aniseed.nvim"), require("todo-comments")
do end (_2amodule_locals_2a)["nvim"] = nvim
_2amodule_locals_2a["todo-comments"] = todo_comments
todo_comments.setup()
return _2amodule_2a