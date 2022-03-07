(module plugin.neogit {require {nvim aniseed.nvim neogit neogit}})

(neogit.setup {:disable_context_highlighting true
               :auto_refresh false
               :integrations {:diffview true}})

(defn valid-neogit-refresh-context [file]
      (if (= (nvim.fn.bufname) :dirvish) false
          (= (nvim.fn.bufname) :Neogit) false
          (= (nvim.fn.match (nvim.fn.bufname)
                            "^\\(Neogit.*\\|.git/COMMIT_EDITMSG\\)$")
             0) false
          (= (nvim.fn.expand :$HOME) (nvim.fn.bufname)) false
          (= (nvim.fn.expand :$HOME) file) false
          true))

(defn refresh [file] (if (valid-neogit-refresh-context file)
                         (neogit.refresh_manually file)))

(vim.api.nvim_create_autocmd [:BufWritePost
                              :BufEnter
                              :FocusGained
                              :ShellCmdPost
                              :VimResume]
                             {:callback #(refresh (nvim.fn.expand :<afile>))})

