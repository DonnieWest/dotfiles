; Compose @Preview annotation queries
; Matches functions annotated with @Preview for screenshot generation

; Simple @Preview annotation (no parameters)
(annotation
  (user_type
    (type_identifier) @annotation_name
    (#eq? @annotation_name "Preview"))
  .
  (function_definition
    (simple_identifier) @preview_function
    body: (function_body) @preview_body)) @preview_node

; @Preview with parameters
(annotation
  (user_type
    (type_identifier) @annotation_name
    (#eq? @annotation_name "Preview"))
  (constructor_invocation
    (value_arguments)
    .
    (function_definition
      (simple_identifier) @preview_function
      body: (function_body) @preview_body))) @preview_node

; @Preview with multiple annotations (e.g., @Preview @Composable)
(function_definition
  (modifiers
    (annotation
      (user_type
        (type_identifier) @annotation_name
        (#eq? @annotation_name "Preview"))))
  (simple_identifier) @preview_function
  body: (function_body) @preview_body) @preview_node

; @Preview with parameters and multiple annotations
(function_definition
  (modifiers
    (annotation
      (user_type
        (type_identifier) @annotation_name
        (#eq? @annotation_name "Preview"))
      (constructor_invocation
        (value_arguments))))
  (simple_identifier) @preview_function
  body: (function_body) @preview_body) @preview_node

; Match androidx.compose.ui.tooling.preview.Preview (fully qualified)
(annotation
  (user_type
    (type_identifier) @annotation_name
    (#eq? @annotation_name "Preview"))
  .
  (function_definition
    (simple_identifier) @preview_function
    body: (function_body) @preview_body)) @preview_node
