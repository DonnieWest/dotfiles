(fn merge-and-set-hl [group new-settings]
  (let [old-settings (vim.api.nvim_get_hl 0 {:name group})
        merged-settings (vim.tbl_extend :force old-settings new-settings)]
    (vim.api.nvim_set_hl 0 group merged-settings)))

(fn colorscheme-fixes []
  (let [italic-groups ["@comment"
                       "@type"
                       "@keyword"
                       "@keyword.import"
                       "@boolean"
                       "@constant"
                       :Comment
                       :Type
                       :Keyword
                       :Boolean
                       :Constant
                       :Include]
        underline-groups [:SpellBad :SpellLocal :SpellRare]]
    (each [_ group (ipairs italic-groups)]
      (merge-and-set-hl group {:italic true}))
    (each [_ group (ipairs underline-groups)]
      (merge-and-set-hl group {:underline true}))
    (merge-and-set-hl :ColorColumn {:ctermbg :blue})
    (merge-and-set-hl :NeogitDiffAdd {:fg "#ffffff" :bg "#218c50"})
    (merge-and-set-hl :NeogitDiffDelete {:fg "#ffffff" :bg "#d32f2f"})
    (merge-and-set-hl :NeogitDiffAddHighlight {:fg "#ffffff" :bg "#176b3a"})
    (merge-and-set-hl :NeogitDiffDeleteHighlight {:fg "#ffffff" :bg "#a62323"})
    (merge-and-set-hl :BlinkCmpMenuSelection {:bg "#0e3a4f"})
    (vim.api.nvim_set_hl 0 :NeogitDiffContextHighlight {:link :CursorLine})
    (vim.api.nvim_set_hl 0 :NeogitHunkHeader {:link :TabLine})
    (vim.fn.matchadd :ColorColumn "\\%101v" 100)
    (vim.api.nvim_set_hl 0 :NeogitHunkHeaderHighlight {:link :DiffText})))

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
 :build ":TSUpdate"
 :dependencies [:RRethy/nvim-treesitter-endwise]
 :init (fn []
         (colorscheme-fixes)
         (vim.api.nvim_create_autocmd [:ColorScheme]
                                      {:callback colorscheme-fixes})
         (vim.api.nvim_create_autocmd :FileType {:callback enable-treesitter}))
 :config (fn []
           (let [ts (require :nvim-treesitter)
                 parsers [:lua
                          :fennel
                          :javascript
                          :typescript
                          :tsx
                          :html
                          :css
                          :json
                          :yaml
                          :toml
                          :markdown
                          :java
                          :kotlin
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
             (install-parsers parsers)))}
