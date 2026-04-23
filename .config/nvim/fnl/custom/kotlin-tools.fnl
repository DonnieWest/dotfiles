(local M {})

(fn normalize [path]
  (let [input (or path "")]
    (input:gsub "\\" "/")))

(fn M.class-name-from-file [path]
  (let [name (vim.fn.fnamemodify path ":t:r")
        kebab-fixed (name:gsub "[-_]([a-zA-Z0-9])" (fn [c] (c:upper)))]
    (kebab-fixed:gsub "^(.)" string.upper)))

(fn M.get-package-info [path text]
  (let [text (or text "")
        existing (or (text:match "^%s*package%s+([%w%.]+)")
                     (text:match "\n%s*package%s+([%w%.]+)"))]
    (if existing
        {:has-package true :package-name existing :sub-package nil}
        (let [normalized (normalize path)
              java-idx (normalized:find "/java/" 1 true)
              kotlin-idx (normalized:find "/kotlin/" 1 true)
              marker (if java-idx "/java/" (if kotlin-idx "/kotlin/" nil))
              start-idx (or java-idx kotlin-idx)
              rel-path (if (and marker start-idx)
                           (normalized:sub (+ start-idx (length marker)))
                           nil)
              pkg-path (if rel-path
                           (rel-path:match "(.+)/[^/]+%.kt$")
                           nil)]
          (if pkg-path
              (let [package-name (pkg-path:gsub "/" ".")
                    sub-package (package-name:match "([^.]+)$")]
                {:has-package false :package-name package-name :sub-package sub-package})
              {:has-package false :package-name nil :sub-package nil})))))

(fn M.find-import-insert-line [lines]
  (var last-import -1)
  (var package-line -1)
  (let [line-count (math.min (length lines) 100)]
    (for [i 1 line-count]
      (let [text (vim.trim (or (. lines i) ""))]
        (when (text:match "^package%s+")
          (set package-line (- i 1)))
        (when (text:match "^import%s+")
          (set last-import (- i 1)))
        (when (text:match "^(class|fun|interface|object|val|var|sealed|data|enum)%s")
          nil))))
  (if (>= last-import 0)
      (+ last-import 1)
      (if (>= package-line 0)
          (+ package-line 2)
          0)))

(fn M.get-missing-imports [lines imports]
  (let [text (table.concat lines "\n")
        missing []]
    (each [_ import-name (ipairs (or imports []))]
      (when (not (text:find (.. "import " import-name) 1 true))
        (table.insert missing import-name)))
    missing))

(fn M.build-additional-text-edits [bufnr imports]
  (let [lines (vim.api.nvim_buf_get_lines bufnr 0 -1 false)
        missing (M.get-missing-imports lines imports)]
    (if (= (length missing) 0)
        nil
        (let [insert-line (M.find-import-insert-line lines)
              edits []]
          (each [_ import-name (ipairs missing)]
            (let [edit {:newText (.. "import " import-name "\n")
                        :range {:start {:line insert-line :character 0}}}]
              (tset edit.range "end" {:line insert-line :character 0})
              (table.insert edits edit)))
          edits))))

(fn M.maybe-insert-package [?bufnr]
  (let [bufnr (or ?bufnr (vim.api.nvim_get_current_buf))
        path (vim.api.nvim_buf_get_name bufnr)
        is-kotlin-file (path:match "%.kt$")]
    (when (and (not= path "") is-kotlin-file)
      (let [lines (vim.api.nvim_buf_get_lines bufnr 0 -1 false)
            text (table.concat lines "\n")]
        (when (= (vim.trim text) "")
          (let [info (M.get-package-info path text)]
            (when (and (not info.has-package) info.package-name)
              (vim.api.nvim_buf_set_lines bufnr 0 -1 false [(.. "package " info.package-name) ""])
              (vim.api.nvim_win_set_cursor 0 [3 0]))))))))

M
