(module plugin.lightline {require {nvim aniseed.nvim nu aniseed.nvim.util}})

(defn- expand [s] (nvim.fn.expand s))

(defn readonly [] (if (and nvim.bo.readonly (not= nvim.bo.filetype :help)) :RO
                      ""))

(defn nearest-method [] (or nvim.b.vista_nearest_method_or_function ""))

(defn- bridge [from to] (nu.fn-bridge from :plugin.lightline to {:return true}))

(bridge :LightlineReadonly :readonly)
(bridge :LspStatus :lspstatus)
(bridge :NearestMethodOrFunction :nearest-method)

(set nvim.g.lightline#ale#indicator_checking "")
(set nvim.g.lightline#ale#indicator_warnings "")
(set nvim.g.lightline#ale#indicator_errors "")
(set nvim.g.lightline#ale#indicator_ok "")
(set nvim.g.lightline#bufferline#enable_devicons 1)
(set nvim.g.lightline#bufferline#show_number 0)
(set nvim.g.lightline#bufferline#shorten_path 1)
(set nvim.g.lightline_buffer_enable_devicons 1)

(set nvim.g.lightline
     {:colorscheme :base16_nvim
      :separator {:left "" :right ""}
      :subseparator {:left "" :right ""}
      :component_function {:gitbranch "FugitiveHead"
                           :method :NearestMethodOrFunction
                           :readonly :LightlineReadonly}
      :component_expand {:buffers "lightline#bufferline#buffers"
                         :file_type_symbol :WebDevIconsGetFileTypeSymbol
                         :lsp_warnings "lightline#lsp#warnings"
                         :lsp_errors "lightline#lsp#errors"
                         :lsp_info "lightline#lsp#info"
                         :lsp_hints "lightline#lsp#hints"
                         :lsp_ok "lightline#lsp#ok"
                         :lsp_status "lightline#lsp#status"
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
                       :linter_warnings :warning
                       :linter_errors :error
                       :linter_info :info
                       :linter_hints :hints
                       :linter_ok :left
                       :linter_checking :left
                       :linter_warnings :warning
                       :linter_errors :error
                       :linter_ok :left}
      :tabline {:left [[:buffers]] :right [[]]}
      :active {:left [[:mode :paste]
                      [:gitbranch :readonly :filename :modified :method]]
               :right [[:lineinfo]
                       [:percent]
                       [:linter_checking
                        :linter_errors
                        :linter_warnings
                        :linter_ok]
                       [:lsp_status
                        :lsp_warnings
                        :lsp_errors
                        :lsp_info
                        :lsp_hints
                        :lsp_ok]
                       [:fileformat :fileencoding :filetype :file_type_symbol]]}
      :inactive {:right [[:lineinfo] [:percent] [:lsp_status]]}})

