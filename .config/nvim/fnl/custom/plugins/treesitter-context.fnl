{1 :nvim-treesitter/nvim-treesitter-context
 :event :BufReadPost
 :opts {:enable true
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
