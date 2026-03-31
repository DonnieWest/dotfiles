{1 :nvim-treesitter/nvim-treesitter-context
 :event :BufReadPost
 :opts {:enable true
        :on_attach (fn [bufnr]
                     (let [filetype (vim.api.nvim_get_option_value "filetype" {:buf bufnr})
                           name (vim.api.nvim_buf_get_name bufnr)]
                       (not (or (= filetype "markdown")
                                (not= (name:match "%.mdx?$") nil)
                                (not= (name:match "%.markdown$") nil)))))
        :max_lines 3
        :min_window_height 0
        :line_numbers true
        :multiline_threshold 20
        :trim_scope :outer
        :mode :cursor
        :separator nil
        :zindex 20}
 :keys [{1 "[c"
         2 (fn []
             (let [tsc (require :treesitter-context)]
               (tsc.go_to_context vim.v.count1)))
         :desc "Jump to context"}]}
