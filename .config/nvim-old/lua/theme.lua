local _2afile_2a = "/home/igneo676/.config/nvim/fnl/theme.fnl"
local _2amodule_name_2a = "theme"
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
local base16, nvim, treesitter, ts_commentstring, _, _0 = require("base16"), require("aniseed.nvim"), require("nvim-treesitter.configs"), require("ts_context_commentstring"), nil, nil
_2amodule_locals_2a["base16"] = base16
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["treesitter"] = treesitter
_2amodule_locals_2a["ts_commentstring"] = ts_commentstring
_2amodule_locals_2a["_"] = _0
_2amodule_locals_2a["_"] = _0
treesitter.setup({ensure_installed = "all", ignore_install = {"php", "phpdoc"}, query_linter = {enable = true, use_virtual_text = true, lint_events = {"BufWrite", "CursorHold"}}, endwise = {enable = true}, matchup = {enable = true}, refactor = {smart_rename = {keymaps = {smart_rename = "grr"}, enable = true}, navigation = {keymaps = {goto_definition_lsp_fallback = "<c-]>", list_definitions = "gD", goto_next_usage = "<Leader>n", goto_previous_usage = "<Leader>N"}, enable = true}}, textobjects = {lsp_interop = {peek_definition_code = {["<Leader>df"] = "@function.outer", ["<Leader>dF"] = "@class.outer"}, enable = true, border = false}, move = {enable = true, set_jumps = true, goto_next_start = {["]m"] = "@function.outer", ["]]"] = "@class.outer"}, goto_next_end = {["]M"] = "@function.outer", ["]["] = "@class.outer"}, goto_previous_start = {["[m"] = "@function.outer", ["[["] = "@class.outer"}, goto_previous_end = {["[M"] = "@function.outer", ["[]"] = "@class.outer"}}, select = {keymaps = {af = "@function.inner", ["if"] = "@function.outer", ag = "@class.outer", ig = "@class.inner", ac = "@comment.outer"}, enable = true}}, autotag = {enable = true}, highlight = {enable = true, additional_vim_regex_highlighting = true}, indent = {enable = true}})
ts_commentstring.setup()
local function colorscheme_fixes()
  nvim.ex.hi("TSComment", "gui=italic")
  nvim.ex.hi("TSType", "gui=italic")
  nvim.ex.hi("TSKeywords", "gui=italic")
  nvim.ex.hi("jsGlobalNodeObjects", "gui=italic")
  nvim.ex.hi("JSKeywords", "gui=italic")
  nvim.ex.hi("jsFunction", "gui=italic")
  nvim.ex.hi("JSKeywords", "gui=italic")
  nvim.ex.hi("TSKeyword", "gui=italic")
  nvim.ex.hi("TSStatement", "gui=italic")
  nvim.ex.hi("TSBoolean", "gui=italic")
  nvim.ex.hi("TSConstant", "gui=italic")
  nvim.ex.hi("TSInclude", "gui=italic")
  nvim.ex.hi("SpellBad", "gui=underline")
  nvim.ex.hi("SpellLocal", "gui=underline")
  nvim.ex.hi("SpellRare", "gui=underline")
  nvim.ex.hi("htmlArg", "gui=italic")
  nvim.ex.hi("Comment", "gui=italic")
  nvim.ex.hi("Type", "gui=italic")
  nvim.ex.hi("Keywords", "gui=italic")
  nvim.ex.hi("Keyword", "gui=italic")
  nvim.ex.hi("Statement", "gui=italic")
  nvim.ex.hi("Boolean", "gui=italic")
  nvim.ex.hi("Constant", "gui=italic")
  nvim.ex.hi("Include", "gui=italic")
  nvim.ex.hi("ColorColumn", "ctermbg=blue")
  nvim.ex.hi("NeogitDiffAdd", "guifg=LightGray", "guibg=DarkGreen")
  nvim.ex.hi("NeogitDiffDelete", "guifg=DarkGray", "guibg=DarkRed")
  nvim.ex.hi("NeogitDiffAddHighlight", "guifg=LightGray", "guibg=DarkGreen")
  nvim.ex.hi("NeogitDiffDeleteHighlight", "guifg=DarkGray", "guibg=DarkRed")
  nvim.ex.highlight("link", "NeogitDiffContextHighlight", "CursorLine")
  nvim.ex.highlight("link", "NeogitHunkHeader", "TabLine")
  return nvim.ex.highlight("link", "NeogitHunkHeaderHighlight", "DiffText")
end
_2amodule_2a["colorscheme-fixes"] = colorscheme_fixes
base16.themes["gotham"] = base16.theme_from_array({"0c1014", "11151c", "091f2e", "0a3749", "245361", "d3ebe9", "599cab", "98d1ce", "4e5166", "2aa889", "33859E", "edb443", "195466", "888ca6", "d26937", "c23127"})
local function strip_hex_symbol(hex)
  return string.gsub(hex, "#", "")
end
_2amodule_locals_2a["strip-hex-symbol"] = strip_hex_symbol
local function get_color(theme, color)
  return strip_hex_symbol(theme[color])
end
_2amodule_locals_2a["get-color"] = get_color
local function convert_theme_to_base16(theme)
  return {base00 = get_color(theme, "background"), base01 = get_color(theme, "lighter-background"), base02 = get_color(theme, "selection"), base03 = get_color(theme, "comment"), base04 = get_color(theme, "dark-foreground"), base05 = get_color(theme, "foreground"), base06 = get_color(theme, "light-foreground"), base07 = get_color(theme, "light-background"), base08 = get_color(theme, "variables"), base09 = get_color(theme, "numbers"), base0A = get_color(theme, "classes"), base0B = get_color(theme, "strings"), base0C = get_color(theme, "regex"), base0D = get_color(theme, "functions"), base0E = get_color(theme, "keywords"), base0F = get_color(theme, "tags")}
end
_2amodule_locals_2a["convert-theme-to-base16"] = convert_theme_to_base16
base16.themes["tweaked"] = convert_theme_to_base16({background = "#03090e", ["lighter-background"] = "#061620", selection = "#091f2e", comment = "#223543", ["dark-foreground"] = "#9da5ab", foreground = "#e6e9ea", ["light-foreground"] = "#f5fafd", ["light-background"] = "#53626d", variables = "#4e5166", numbers = "#DDECB2", classes = "#33859E", strings = "#FFB610", regex = "#195466", functions = "#27B8C2", keywords = "#ecb2c0", tags = "#D12820"})
do end (base16.themes)["nightowl"] = base16.theme_from_array({"011627", "0c2132", "172c3d", "223748", "2c4152", "ced6e3", "d6deeb", "feffff", "ecc48d", "f78c6c", "c792ea", "29E68E", "aad2ff", "82aaff", "c792ea", "f78c6c"})
do end (base16.themes)["gotham-tweaked"] = convert_theme_to_base16({background = "#03090e", ["lighter-background"] = "#10151c", selection = "#0e3a4f", comment = "#13596c", ["dark-foreground"] = "#2d6a79", foreground = "#e6f9f7", ["light-foreground"] = "#6bb8c8", ["light-background"] = "#b0e3e4", variables = "#606476", numbers = "#3cd7b2", classes = "#41a8c7", strings = "#f7ba56", regex = "#1e6a87", functions = "#a3a7c1", keywords = "#ee7545", tags = "#d5423b"})
base16(base16.themes["gotham-tweaked"], true, {lightline = true})
local function _1_()
  return colorscheme_fixes()
end
vim.api.nvim_create_autocmd({"ColorScheme"}, {callback = _1_})
colorscheme_fixes()
nvim.fn.matchadd("ColorColumn", "\\%81v", 100)
return _2amodule_2a