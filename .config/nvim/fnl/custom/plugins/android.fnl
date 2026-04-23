{1 :hsanson/vim-android
 :lazy false
 :init (fn []
         (let [group (vim.api.nvim_create_augroup :KotlinPackageInsertEarly {:clear true})
               kotlin-tools (require :custom.kotlin-tools)]
           (vim.api.nvim_create_autocmd [:BufNewFile :BufEnter]
                                        {:group group
                                         :pattern :*.kt
                                         :callback (fn [args]
                                                     (pcall kotlin-tools.maybe-insert-package args.buf))})
            (vim.api.nvim_create_autocmd :VimEnter
                                         {:group group
                                          :callback (fn []
                                                     (pcall kotlin-tools.maybe-insert-package (vim.api.nvim_get_current_buf)))}) ))
 :config (fn []
           (let [android (require :custom.android)]
             (android.setup)))}
