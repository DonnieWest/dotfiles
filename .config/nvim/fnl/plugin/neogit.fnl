(module plugin.neogit {require {nvim aniseed.nvim
                                neogit neogit
                                status neogit.status}})

(neogit.setup {:disable_context_highlighting true
               :auto_refresh false
               :integrations {:diffview true}})

(defn valid-neogit-refresh-context [file o]
      (if (not status.status_buffer) false
          (= (nvim.fn.bufname) :dirvish) false
          (= (nvim.fn.bufname) :Neogit) false
          (= (nvim.fn.match (nvim.fn.bufname)
                            "^\\(Neogit.*\\|.git/COMMIT_EDITMSG\\)$")
             0) false
          (= (: (vim.api.nvim_buf_get_option o.buf :filetype) :find :Neogit)
             nil) false
          (= (nvim.fn.expand :$HOME) (nvim.fn.bufname)) false
          (= (nvim.fn.expand :$HOME) file) false
          true))

(defn refresh [file o]
      (if (valid-neogit-refresh-context file o)
          (neogit.refresh_manually file)))

(vim.api.nvim_create_autocmd [:BufWritePost
                              :BufEnter
                              :FocusGained
                              :ShellCmdPost
                              :VimResume]
                             {:callback #(refresh (nvim.fn.expand :<afile>) $1)})

