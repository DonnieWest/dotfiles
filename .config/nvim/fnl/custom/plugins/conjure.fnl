{1 :Olical/conjure
 :lazy true
 :ft [:clojure :fennel]
 :init (fn [] (set vim.g.conjure_auto_start 0)
         (set vim.g.conjure#filetypes
              [:clojure
               :fennel
               :janet
               :hy
               :julia
               :racket
               :scheme
               :lua
               :lisp
               :python
               :rust
               :sql])
         (set vim.g.conjure#mapping#enable_ft_mappings false))}
