local _2afile_2a = "/home/igneo676/.config/nvim/fnl/plugin/lsp.fnl"
local _2amodule_name_2a = "core.lsp"
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
local cmp_lsp, document_color, fzf, lsp, lsp_code_action, lsp_locations, lsp_symbols, mapping, nvim, schemastore, virtualtypes = require("cmp_nvim_lsp"), require("document-color"), require("fzf-lua"), require("lspconfig"), require("lsputil.codeAction"), require("lsputil.locations"), require("lsputil.symbols"), require("mapping"), require("aniseed.nvim"), require("schemastore"), require("virtualtypes")
do end (_2amodule_locals_2a)["cmp-lsp"] = cmp_lsp
_2amodule_locals_2a["document-color"] = document_color
_2amodule_locals_2a["fzf"] = fzf
_2amodule_locals_2a["lsp"] = lsp
_2amodule_locals_2a["lsp-code-action"] = lsp_code_action
_2amodule_locals_2a["lsp-locations"] = lsp_locations
_2amodule_locals_2a["lsp-symbols"] = lsp_symbols
_2amodule_locals_2a["mapping"] = mapping
_2amodule_locals_2a["nvim"] = nvim
_2amodule_locals_2a["schemastore"] = schemastore
_2amodule_locals_2a["virtualtypes"] = virtualtypes
document_color.setup({mode = "background"})
local capabilities = cmp_lsp.default_capabilities()
do end (_2amodule_2a)["capabilities"] = capabilities
capabilities.textDocument.colorProvider = {dynamicRegistration = true}
local function on_attach(client, bufnr)
  virtualtypes.on_attach(client, bufnr)
  if client.server_capabilities.colorProvider then
    document_color.buf_attach(bufnr)
  else
  end
  vim.keymap.set("n", "gr", fzf.lsp_references, opts)
  vim.keymap.set("n", "grr", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "<F19>", vim.lsp.buf.rename, opts)
  vim.keymap.set("n", "gd", fzf.lsp_declarations, opts)
  vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, opts)
  vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
  vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, opts)
  vim.keymap.set("n", "gD", fzf.lsp_implementations, opts)
  vim.keymap.set("n", "1gD", fzf.lsp_typedefs, opts)
  vim.keymap.set("n", "g0", fzf.lsp_document_symbols, opts)
  vim.keymap.set("n", "gW", fzf.lsp_workspace_symbols, opts)
  vim.keymap.set("n", "ga", fzf.lsp_code_actions, opts)
  return nvim.ex.autocmd("CursorHold", "<buffer>", "lua vim.diagnostic.open_float(nil, { focusable = false })")
end
_2amodule_2a["on-attach"] = on_attach
nvim.ex.autocmd("FileType", "clojure", "nnoremap <silent> <leader>fm    <cmd>lua vim.lsp.buf.format()<CR>")
do end (vim.lsp.handlers)["textDocument/codeAction"] = lsp_code_action.code_action_handler
vim.lsp.handlers["textDocument/references"] = lsp_locations.references_handler
vim.lsp.handlers["textDocument/definition"] = lsp_locations.definition_handler
vim.lsp.handlers["textDocument/declaration"] = lsp_locations.declaration_handler
vim.lsp.handlers["textDocument/typeDefinition"] = lsp_locations.typeDefinition_handler
vim.lsp.handlers["textDocument/implementation"] = lsp_locations.implementation_handler
vim.lsp.handlers["textDocument/documentSymbol"] = lsp_symbols.document_handler
local diagnostic_config = {signs = true, underline = true, update_in_insert = true, severity_sort = true, virtual_text = false}
_2amodule_locals_2a["diagnostic-config"] = diagnostic_config
vim.lsp.handlers["workspace/symbol"] = lsp_symbols.workspace_handler
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, diagnostic_config)
vim.diagnostic.config(diagnostic_config)
vim.cmd("autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost .rs,.ts,.js lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = \"Comment\" }")
local function filter(arr, ___fn___)
  if (type(arr) ~= "table") then
  else
  end
  local filtered = {}
  for k, v in pairs(arr) do
    if ___fn___(v, k, arr) then
      table.insert(filtered, v)
    else
    end
  end
  return filtered
end
_2amodule_locals_2a["filter"] = filter
local function filter_dts(value)
  return (string.match(value.uri, "d.ts") == nil)
end
_2amodule_locals_2a["filter-dts"] = filter_dts
local function definition_handler(err, result, method, ...)
  if (vim.tbl_islist(result) and (#result > 1)) then
    return vim.lsp.handlers["textDocument/definition"](err, filter(result, filter_dts)(), method, ...)
  else
    return vim.lsp.handlers["textDocument/definition"](err, result, method, ...)
  end
end
_2amodule_locals_2a["definition-handler"] = definition_handler
local function get_python_path(workspace)
  if vim.env.VIRTUAL_ENV then
    local ___antifnl_rtns_1___ = {lsp.util.path.join(vim.env.VIRTUAL_ENV, "bin", "python")}
    return (table.unpack or _G.unpack)(___antifnl_rtns_1___)
  else
  end
  for _, pattern in ipairs({"*", ".*"}) do
    local ___match___ = vim.fn.glob(path.join(workspace, pattern, "pyvenv.cfg"))
    if (___match___ ~= "") then
      local ___antifnl_rtns_1___ = {lsp.util.path.join(lsp.util.path.dirname(___match___), "bin", "python")}
      return (table.unpack or _G.unpack)(___antifnl_rtns_1___)
    else
    end
  end
  return ((exepath("python3") or exepath("python")) or "python")
end
local function _7_(_, config)
  config.settings.python.pythonPath = get_python_path(config.root_dir)
  return nil
end
lsp.pyright.setup({on_attach = on_attach, capabilities = capabilities, before_init = _7_, settings = {python = {analysis = {useLibraryCodeForTypes = true, completeFunctionParens = true}}}})
lsp.gopls.setup({on_attach = on_attach, capabilities = capabilities})
lsp.cssls.setup({on_attach = on_attach, capabilities = capabilities})
lsp.clojure_lsp.setup({on_attach = on_attach, capabilities = capabilities})
lsp.jsonls.setup({on_attach = on_attach, capabilities = capabilities, settings = {json = {schemas = schemastore.json.schemas()}, jsonls = {textDocument = {completion = {completionItem = {snippetSupport = true}}}}}})
lsp.cssls.setup({on_attach = on_attach, capabilities = capabilities})
lsp.jdtls.setup({on_attach = on_attach, capabilities = capabilities})
lsp.tailwindcss.setup({on_attach = on_attach, capabilities = capabilities})
lsp.kotlin_language_server.setup({cmd = {"/home/igneo676/.local/share/nvim/site/pack/packer/start/kotlin-language-server/server/build/install/server/bin/kotlin-language-server"}, init_options = {storagePath = "/home/igneo676/.cache/kotlin-lsp"}, on_attach = on_attach, capabilities = capabilities, settings = {kotlin = {hints = {typeHints = true, chainedHints = true, parameterHints = true}, compiler = {jvm = {target = "1.8"}}}}})
lsp.gradle_ls.setup({cmd = {"/home/igneo676/.local/share/nvim/site/pack/packer/start/vscode-gradle/gradle-language-server/build/install/gradle-language-server/bin/gradle-language-server"}, on_attach = on_attach, capabilities = capabilities})
lsp.fennel_ls.setup({on_attach = on_attach, capabilities = capabilities})
local function _8_(fname)
  return (lsp.util.root_pattern(unpack({"settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts"}))(fname) or lsp.util.root_pattern(unpack({"build.gradle", "build.gradle.kts"}))(fname))
end
require("lspconfig.configs")["ideals"] = {default_config = {cmd = {"android-studio-canary", "lsp-server"}, filetypes = {"kotlin"}, root_dir = _8_}}
lsp.ideals.setup({on_attach = on_attach, capabilities = capabilities})
return _2amodule_2a