;; Neotest - Testing framework integration
;; Provides inline test running with virtual text results
{1 :nvim-neotest/neotest
 :dependencies [:nvim-neotest/neotest-jest
                 :marilari88/neotest-vitest
                 :rcasia/neotest-java
                 :nvim-lua/plenary.nvim
                 :nvim-treesitter/nvim-treesitter]
 :config (fn []
           (let [neotest (require :neotest)]
             (neotest.setup {:adapters [(require :neotest-jest)
                                        (require :neotest-vitest)
                                        (require :neotest-java)]
                             :icons {:passed "✓"
                                     :running "●"
                                     :failed "✗"
                                     :skipped "○"
                                     :unknown "?"}
                             :floating {:border :rounded
                                        :max_height 0.6
                                        :max_width 0.6}})
             (let [map (fn [lhs rhs desc]
                         (vim.keymap.set :n lhs rhs {: desc}))]
               (map :<leader>tn #(neotest.run.run) "Test nearest")
               (map :<leader>tf #(neotest.run.run (vim.fn.expand :%)) "Test file")
               (map :<leader>td #(neotest.run.run {:strategy :dap}) "Debug nearest test")
               (map :<leader>ts #(neotest.summary.toggle) "Toggle test summary")
               (map :<leader>to #(neotest.output.open {:enter true}) "Open test output")
               (map :<leader>tO #(neotest.output_panel.toggle) "Toggle test output panel")
               (map :<leader>tx #(neotest.run.stop) "Stop test"))))}
