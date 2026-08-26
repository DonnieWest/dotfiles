; extends

(call_expression
  function: (identifier) @_tag
  arguments: (template_string) @injection.content
  (#any-of? @_tag "html" "svg" "mathml")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "html"))

(call_expression
  function: (identifier) @_tag
  arguments: (template_string) @injection.content
  (#eq? @_tag "css")
  (#offset! @injection.content 0 1 0 -1)
  (#set! injection.include-children)
  (#set! injection.language "css"))
