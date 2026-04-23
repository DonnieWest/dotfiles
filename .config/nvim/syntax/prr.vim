" Vim syntax file
" Language:     prr
" Maintainer:   Daniel Xu <dxu@dxuuu.xyz>
" Last Change:  2023 Nov 07

if exists("b:current_syntax")
  finish
endif

" match + but not +++
syn match prrAdded   "^> +\(++\)\@!.*"
" match - but not ---
syn match prrRemoved "^> -\(--\)\@!.*"

syn match prrHeader "^> diff --git .*"
syn match prrIndex "^> index \w*\.\.\w*\( \w*\)\?"
syn match prrChunkH "^> @@ .* @@"

syn match prrTag "^@prr .*" contains=prrTagName,prrResult transparent

syn match prrTagName contained "@prr" nextgroup=prrResult
syn keyword prrResult contained approve reject comment

hi def link prrAdded           Added
hi def link prrRemoved         Removed

hi def link prrTagName Keyword
hi def link prrResult String
hi def link prrHeader Include
hi def link prrIndex Comment
hi def link prrChunkH Function

let b:current_syntax = "prr"
