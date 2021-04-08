(module dotfiles.module.plugin.conjure
  {require {nvim aniseed.nvim
            :ceval conjure.eval}})

(set nvim.g.conjure#eval#result_register "*")
(set nvim.g.conjure#log#botright true)
(set nvim.g.conjure#log#hud#enabled true)
(set nvim.g.conjure#log#hud#height 0.2)
(set nvim.g.conjure#extract#tree_sitter#enabled true)

(nvim.ex.autocmd
    :FileType
    "clojure,fennel,scheme"
    "nnoremap <silent> gd    <cmd>:ConjureDefWord<CR>")

(nvim.ex.autocmd
    :FileType
    "clojure,fennel,scheme"
    "nnoremap <silent> <c-]> <cmd>:ConjureDefWord<CR>")

(nvim.ex.autocmd
    :FileType
    "clojure,fennel,scheme"
    "nnoremap <silent> K     <cmd>:ConjureDocWord<CR>")

(nvim.ex.autocmd
    :FileType
    "clojure,fennel,scheme"
    "nnoremap <silent> gD    <cmd>:ConjureCljViewSource<CR>")

(def symbol-map
  {:T ""
  :M ""
  :F ""
  :V ""})

(defn- nil? [val] (= (type val) :nil))
(defn string? [val] (= (type val) :string))
(defn table? [val] (= (type val) :table))

(defn- includes [col val]
  "(includes [:foo :bar] :foo) ;=> true
   (includes [:foo :bar] :baz) ;=> false
   (includes \"foo\" :foo) ;=> true
   (includes \"foo\" :bar) ;=> false"
  (if
    (string? col) (not (nil? (: col :find val)))
    (table? col) (not (nil? (find #(= $1 val) col)))
    false))

(def pattern-regex (vim.regex "[0-9a-zA-Z.!$%&*+/:<=>?#_~\\^\\-\\\\]\\+$"))

(def- source-conf
  {:priority 1000
   :filetypes [:fennel :clojure :racket :janet]
   :dub false
   :menu "[conjure]"})

(defn- determine [_ {: before_char
                     : before_line
                     : col}]
  (let [offset (pattern-regex:match_str before_line)
        has-dot (includes before_char "%.")
        has-slash (includes before_char "/")
        trigger (if (or has-dot has-slash) col 0)]

    (if
      (nil? offset) {}
      {:keyword_pattern_offset (+ offset 1)
       :trigger_character_offset trigger})))

(defn- complete [_ {: context
                    : keyword_pattern_offset
                    : callback}]
  (let [input (context:get_input keyword_pattern_offset)]
    (ceval.completions input (fn [items]
                              (callback {: items})))))


(defn- documentation [_ {: completed_item
                         : callback
                         : abort}]
  (let [content completed_item.info]
    (if (not= content "") (callback content) (abort))))

(def source
  {:get_metadata #source-conf
   : documentation
   : complete
   : determine
   })
