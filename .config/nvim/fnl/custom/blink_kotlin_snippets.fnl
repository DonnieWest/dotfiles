(local snippets (require :custom.kotlin-snippets))
(local tools (require :custom.kotlin-tools))

(local Source {})
(set Source.__index Source)

(fn make-range [ctx]
  (let [line (- (. ctx.cursor 1) 1)
        start-char (- ctx.bounds.start_col 1)
        end-char (+ start-char ctx.bounds.length)
        range {:start {:line line :character start-char}}]
    (tset range "end" {:line line :character end-char})
    range))

(fn make-context [bufnr]
  (let [path (vim.api.nvim_buf_get_name bufnr)
        class-name (tools.class-name-from-file path)
        lower-head (if (> (length class-name) 0)
                       (.. (string.lower (class-name:sub 1 1)) (class-name:sub 2))
                       class-name)]
    {:class-name class-name
     :table-name (.. lower-head "s")
     :database-name (.. lower-head "_database")}))

(fn Source.new []
  (setmetatable {} Source))

(fn Source.enabled [self]
  (= vim.bo.filetype "kotlin"))

(fn Source.get_completions [self ctx callback]
  (let [items []
        defs (snippets.all)
        render-ctx (make-context ctx.bufnr)
        range (make-range ctx)
        types (require :blink.cmp.types)
        kind types.CompletionItemKind.Snippet
        snippet-format vim.lsp.protocol.InsertTextFormat.Snippet]
    (each [prefix def (pairs defs)]
      (let [body (snippets.expand-body def render-ctx)
            item {:label prefix
                  :kind kind
                  :detail def.description
                  :documentation {:kind :markdown :value def.description}
                  :insertTextFormat snippet-format
                  :textEdit {:newText body :range range}
                  :additionalTextEdits (tools.build-additional-text-edits ctx.bufnr def.imports)
                  :data {:prefix prefix}
                  :sortText (.. "0" prefix)
                  :filterText prefix}]
        (table.insert items item)))
    (callback {:is_incomplete_forward false
               :is_incomplete_backward false
               :items items})))

Source
