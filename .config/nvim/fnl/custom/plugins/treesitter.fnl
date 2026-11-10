(fn enable-treesitter [event]
  (let [bufnr event.buf
        filetype (vim.api.nvim_get_option_value :filetype {:buf bufnr})
        skip-indent [:markdown
                     :javascript
                     :javascriptreact
                     :javascript.jsx
                     :typescript
                     :typescriptreact
                     :typescript.tsx
                     :tsx]]
    (when (not= filetype :markdown)
      (let [(ok _) (pcall vim.treesitter.start bufnr)]
        (when (and ok (not (vim.tbl_contains skip-indent filetype)))
          (vim.api.nvim_set_option_value :indentexpr
                                         "v:lua.require'nvim-treesitter'.indentexpr()"
                                         {:buf bufnr}))))))

(fn install-parsers [parsers]
  (let [ts (require :nvim-treesitter)
        config (require :nvim-treesitter.config)
        get-installed (or config.get_installed config.installed_parsers)
        installed (if get-installed (get-installed) [])
        missing []]
    (each [_ parser (ipairs parsers)]
      (when (not (vim.tbl_contains installed parser))
        (table.insert missing parser)))
    (when (> (length missing) 0)
      (ts.install missing))))

{1 :nvim-treesitter/nvim-treesitter
 :branch :main
 :event [:BufReadPost :BufNewFile]
 :build ":TSUpdate"
 :dependencies [:RRethy/nvim-treesitter-endwise]
 :init (fn []
         (vim.fn.matchadd :ColorColumn "\\%101v" 100))
 :config (fn []
           (let [ts (require :nvim-treesitter)
                 parsers [:lua
                          :fennel
                          :javascript
                          :typescript
                          :tsx
                          :html
                          :css
                          :scss
                          :xml
                          :json
                          :yaml
                          :toml
                          :markdown
                          :java
                          :kotlin
                          :groovy
                          :properties
                          :clojure
                          :sql
                          :vim
                          :vimdoc
                          :query
                          :bash
                          :http
                          :diff
                          :regex]]
             (ts.setup {})
             (install-parsers parsers)
             (vim.api.nvim_create_autocmd :FileType
                                          {:callback enable-treesitter})
             (enable-treesitter {:buf (vim.api.nvim_get_current_buf)})))}
