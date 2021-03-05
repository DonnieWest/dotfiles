(module dotfiles.module.mapping
  {require {nvim aniseed.nvim
            nu aniseed.nvim.util
            core aniseed.core}})

(defn noremap [mode from to]
  "Sets a mapping with {:noremap true}."
  (nvim.set_keymap mode from to {:noremap true}))

;; Generic mapping configuration.
(nvim.set_keymap :n :<space> :<nop> {:noremap true})
(set nvim.g.mapleader ",")

;; Delete hidden buffers.
(noremap :n :<leader>bo ":call DeleteHiddenBuffers()<cr>")

(nu.fn-bridge
  :StripTrailingWhitespace
  :dotfiles.module.mapping :strip-trailing-whitespace)

(defn strip-trailing-whitespace []
  (let [pos (nvim.fn.getpos ".")]
    (nvim.command "%s/\\s\\+$//e")
    (nvim.command "%s/\\n\\{3,}/\\r\\r/e")
    (nvim.command "%s#\\($\\n\\s*\\)\\+\\%$##e")
    (nvim.fn.setpos "." pos)))

(noremap :n :<leader><space> ":call StripTrailingWhitespace()<cr>")

(nu.fn-bridge
  :DeleteHiddenBuffers
  :dotfiles.module.mapping :delete-hidden-buffers)

(defn delete-hidden-buffers []
  (let [visible-bufs (->> (nvim.fn.range 1 (nvim.fn.tabpagenr :$))
                          (core.map nvim.fn.tabpagebuflist)
                          (unpack)
                          (core.concat))]
    (->> (nvim.fn.range 1 (nvim.fn.bufnr :$))
         (core.filter
           (fn [bufnr]
             (and (nvim.fn.bufexists bufnr)
                  (= -1 (nvim.fn.index visible-bufs bufnr)))))
         (core.run!
           (fn [bufnr]
             (nvim.ex.bwipeout bufnr))))))
