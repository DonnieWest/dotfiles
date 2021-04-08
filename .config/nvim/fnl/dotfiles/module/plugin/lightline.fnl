(module dotfiles.module.plugin.lightline
  {require {nvim aniseed.nvim
            lsp-status lsp-status
            nu aniseed.nvim.util}})

(defn- expand [s]
  (nvim.fn.expand s))

(defn readonly []
  (if (and nvim.bo.readonly
           (not= nvim.bo.filetype "help"))
    "RO"
    ""))

(defn nearest-method []
  (or nvim.b.vista_nearest_method_or_function ""))

(defn lspstatus []
  (lsp-status.status))

(defn- bridge [from to]
  (nu.fn-bridge from :dotfiles.module.plugin.lightline to {:return true}))

(bridge :LightlineReadonly :readonly)
(bridge :LspStatus :lspstatus)
(bridge :NearestMethodOrFunction :nearest-method)

(set nvim.g.lightline#ale#indicator_checking "")
(set nvim.g.lightline#ale#indicator_warnings "")
(set nvim.g.lightline#ale#indicator_errors  "")
(set nvim.g.lightline#ale#indicator_ok "")
(set nvim.g.lightline#bufferline#enable_devicons 1)
(set nvim.g.lightline#bufferline#show_number 0)
(set nvim.g.lightline#bufferline#shorten_path 1)
(set nvim.g.lightline_buffer_enable_devicons 1)

(set nvim.g.lightline
     {:colorscheme :gotham256
      :separator {:left ""
                  :right "" }
      :subseparator {:left ""
                     :right "" }
      :component_function {:gitbranch "fugitive#head"
                           :method :NearestMethodOrFunction
                           :lsp_status :LspStatus
                           :readonly :LightlineReadonly}
      :component_expand {:buffers "lightline#bufferline#buffers"
                         :linter_checking "lightline#ale#checking"
                         :linter_warnings "lightline#ale#warnings"
                         :linter_errors "lightline#ale#errors"
                         :linter_ok "lightline#ale#ok"
                         :gradle_errors "lightline#gradle#errors"
                         :gradle_warnings "lightline#gradle#warnings"
                         :gradle_running "lightline#gradle#running"
                         :gradle_project "lightline#gradle#project"}
      :component_type {:buffers :tabsel
                       :gradle_errors :error
                       :gradle_warnings :warning
                       :gradle_running :left
                       :gradle_project :right
                       :linter_checking :left
                       :linter_warnings :warning
                       :linter_errors :error
                       :linter_ok :left}
      :tabline {:left [[:buffers]]
                :right [[:exit]]}
      :active {:left [[:mode :paste]
                      [:gitbranch :readonly :filename :modified :method]]
               :right [[:lineinfo]
                       [:percent]
                       [:linter_checking :linter_errors :linter_warnings :linter_ok:]
                       [ :lsp_status: ]
                       [ :fileformat :fileencoding :filetype: ]]}
      :inactive {:right [[:lineinfo] [:percent] [:lsp_status]]}})
