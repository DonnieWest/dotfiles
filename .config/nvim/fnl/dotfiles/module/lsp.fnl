(module dotfiles.module.core
  {require {nvim aniseed.nvim
            lsp lspconfig
            lspstatus lsp-status}})



; (def kind_labels {})

; -- use LSP SymbolKinds themselves as the kind labels
; local kind_labels_mt = {__index = function(_, k) return k end}
; local kind_labels = {}
; setmetatable(kind_labels, kind_labels_mt)
;

(lspstatus.register_progress)
; (lspstatus.config
;   {:kind_labels kind_labels
;   ;; the default is a wide codepoint which breaks absolute and relative
;   ;; line counts if placed before airline's Z section
;    :status_symbol ""})

; (set vim.lsp.handlers)

(defn on_attach [client bufnr]
  (lspstatus.on_attach client bufnr)
  (nvim.command "autocmd CursorHold <buffer> lua vim.lsp.diagnostic.show_line_diagnostics()"))

(lsp.tsserver.setup
  {:on_attach on_attach
   :cmd ["/home/igneo676/Code/typescript-language-server/server/lib/cli.js" "--stdio" "--detailed-completions"]})
