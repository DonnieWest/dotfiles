(module dotfiles.module.plugin.neoformat
  {require {nvim aniseed.nvim
            mapping dotfiles.module.mapping}})

(set nvim.g.neoformat_xml_prettier
     {:exe "prettier"
      :args ["--stdin" "--stdin-filepath" "\"%:p\""]
      :stdin 1})

(set nvim.g.neoformat_enabled_xml ["prettier"])

(mapping.noremap :n :<leader>fm ":Neoformat<CR>")

; let g:neoformat_java_googleformatter = {
;             \ 'exe': 'google-java-format',
;             \ 'args': ['-'],
;             \ 'stdin': 1,
;             \ }
;
; let g:neoformat_enabled_java = ['googleformatter']
;
; let g:neoformat_kotlin_ktlint = {
;             \ 'exe': 'ktlint',
;             \ 'args': ['-F', '-a', '--stdin'],
;             \ 'stdin': 1,
;             \ }
;


; let g:neoformat_enabled_javascript = ['prettiereslint']
; let g:neoformat_enabled_typescript = ['prettier']
