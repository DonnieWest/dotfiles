(local M {})
(var registered false)

(fn M.register []
  (when (not registered)
    (let [(ok blink) (pcall require :blink.cmp)]
      (when ok
        (blink.add_source_provider :jetstart_kotlin
                                   {:name "JetStart Kotlin"
                                    :module "custom.blink_kotlin_snippets"})
        (blink.add_filetype_source :kotlin :jetstart_kotlin)
        (set registered true)))))

M
