(module dotfiles.module.plugin.pretty-template
  {require {core aniseed.core
            nvim aniseed.nvim}})


(nvim.fn.jspretmpl#register_tag "gql" "graphql")
(nvim.fn.jspretmpl#register_tag "/* GraphQL */" "graphql")

(nvim.ex.autocmd :FileType :javascript "JsPreTmpl")
(nvim.ex.autocmd :FileType "javascript.jsx" "JsPreTmpl")
