;; rest.nvim - HTTP REST client
;; Test APIs directly from .http files within Neovim
{1 :rest-nvim/rest.nvim
 :dependencies [:nvim-lua/plenary.nvim]
 :ft :http
 :config (fn []
           (let [rest (require :rest-nvim)]
             (rest.setup {:result_split_horizontal false
                          :result_split_in_place false
                          :skip_ssl_verification false
                          :encode_url true
                          :highlight {:enabled true :timeout 150}
                          :result {:show_url true
                                   :show_http_info true
                                   :show_headers true
                                   :formatters {:json (fn [body]
                                                        (vim.fn.system (.. "jq '.' <<< "
                                                                           (vim.fn.shellescape body))))
                                                :html (fn [body]
                                                        (vim.fn.system (.. "xmllint --format --html - <<< "
                                                                           (vim.fn.shellescape body))))}}})))
 :keys [{1 :<leader>rr 2 :<Plug>RestNvim :desc "Run request under cursor"}
        {1 :<leader>rp 2 :<Plug>RestNvimPreview :desc "Preview curl command"}
        {1 :<leader>rl 2 :<Plug>RestNvimLast :desc "Re-run last request"}]}
