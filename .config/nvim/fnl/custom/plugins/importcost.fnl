{1 :barrett-ruth/import-cost.nvim
 :config (fn []
           (set vim.g.import_cost
                {:filetypes [:javascript
                             :javascriptreact
                             :typescript
                             :typescriptreact
                             :svelte]
                 :format {:byte_format "%.1fb"
                          :kb_format "%.1fk"
                          :virtual_text "%s (gzipped: %s)"}
                 :highlight :Comment
                 :package_manager :npm}))}
