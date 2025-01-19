local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/luasnip.fnl"
local _2amodule_name_2a = "plugin.luasnip"
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
local extras, luasnip, nvim, snipmate, types, vscode = require("luasnip.extras"), require("luasnip"), require("aniseed.nvim"), require("luasnip.loaders.from_snipmate"), require("luasnip.util.types"), require("luasnip.loaders.from_vscode")
do end (_2amodule_locals_2a)["extras"] = extras
_2amodule_locals_2a["luasnip"] = luasnip
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["snipmate"] = snipmate
_2amodule_locals_2a["types"] = types
_2amodule_locals_2a["vscode"] = vscode
vscode.lazy_load()
snipmate.lazy_load()
luasnip.config.setup({ext_opts = {[types.choiceNode] = {active = {virt_text = {{"\226\151\143", "#D12820"}}}}, [types.insertNode] = {active = {virt_text = {{"\226\151\143", "#FFB610"}}}}}})
luasnip.snippets = {fennel = {luasnip.snippet("module", {luasnip.text_node("(module plugin."), luasnip.insert_node(0), luasnip.text_node(" {require {nvim aniseed.nvim}})")})}, kotlin = {luasnip.snippet("moshi", {luasnip.text_node({"@JsonClass(generateAdapter = true)", "data class "}), luasnip.insert_node(1), luasnip.text_node("("), luasnip.snippet_node(0, {luasnip.text_node("val "), luasnip.insert_node(1), luasnip.text_node(":"), luasnip.insert_node(2)}), luasnip.text_node(")")})}}
return _2amodule_2a