(module dotfiles.module.plugin.asyncomplete
  {require {nvim aniseed.nvim}})

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

; imap <C-x><C-o> <Plug>(asyncomplete_force_refresh)
; autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
;
; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
;     \ 'name': 'file',
;     \ 'allowlist': ['*'],
;     \ 'completor': function('asyncomplete#sources#file#completor')
;     \ }))
;
; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#Verdin#get_source_options({
;     \ 'name': 'Verdin',
;     \ 'allowlist': ['vim'],
;     \ 'completor': function('asyncomplete#sources#Verdin#completor')
;     \ }))
;
; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#ale#get_source_options({
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
;
; au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#lsp#get_source_options({}))
