(module dotfiles.module.plugin.asyncomplete
  {require {nvim aniseed.nvim
            nu aniseed.nvim.util}})

(set nvim.g.asyncomplete_completion_symbols
     {:text ""
      :method ""
      :function ""
      :constructor ""
      :field ""
      :variable ""
      :class ""
      :interface ""
      :module ""
      :property ""
      :unit "unit"
      :value "val"
      :enum ""
      :keyword "keyword"
      :snippet ""
      :color "color"
      :file ""
      :reference "ref"
      :folder ""
      :enum_member ""
      :constant ""
      :struct ""
      :event "event"
      :operator ""
      :type_parameter "type param"
      :* "v"})

(nvim.ex.set "completeopt=noinsert,menuone,noselect,longest")
(nvim.set_keymap :n :<C-x><C-o> "<Plug>(asycomplete_force_refresh)" {})
(nvim.ex.autocmd_ :CompleteDone "*" "if pumvisible() == 0 | pclose | endif")

; (nvim.ex.autocmd :User "call RegisterAsyncompleteSources()<cr>")
;
; (nu.fn-bridge
;   :RegisterAsyncompleteSources
;   :dotfiles.module.plugin.asyncomplete :asyncomplete-register-sources)
;
; (defn asyncomplete-register-sources []
;   (nvim.fn.asyncomplete#register_source
;     (nvim.fn.asyncomplete#sources#file#get_source_options
;       [:name "file"
;        :allowlist ["*"]
;        :completor nvim.fn.asyncomplete#sources#file#completor]))
;   (nvim.fn.asyncomplete#register_source (nvim.fn.asyncomplete#sources#lsp#get_source_options))
;   (nvim.fn.asyncomplete#register_source (nvim.fn.asyncomplete#sources#ale#get_source_options)))

; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#Verdin#get_source_options({
;     \ 'name': 'Verdin',
;     \ 'allowlist': ['vim'],
;     \ 'completor': function('asyncomplete#sources#Verdin#completor')
;     \ }))
;
; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#omni#get_source_options({
;   \ 'name': 'omni',
;   \ 'allowlist': ['sql', 'sq'],
;   \ 'completor': function('vim_dadbod_completion#omni')
;   \  }))
;
; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#conjure#get_source_options({
;     \ 'name': 'conjure',
;     \ 'allowlist': ['clojure', 'fennel'],
;     \ 'completor': function('asyncomplete#sources#conjure#completor'),
;     \ }))
