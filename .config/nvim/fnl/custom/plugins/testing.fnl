;; Neotest - Testing framework integration
;; Provides inline test running with virtual text results
{1 :nvim-neotest/neotest
 :dependencies [:nvim-neotest/neotest-jest
                :nvim-neotest/neotest-python
                :rcasia/neotest-java
                :nvim-lua/plenary.nvim
                :nvim-treesitter/nvim-treesitter]
 :config (fn []
           (let [neotest (require :neotest)]
             (neotest.setup {:adapters [(require :neotest-jest)
                                        (require :neotest-python)
                                        (require :neotest-java)]
                             :icons {:passed "✓"
                                     :running "●"
                                     :failed "✗"
                                     :skipped "○"
                                     :unknown "?"}
                             :floating {:border :rounded
                                        :max_height 0.6
                                        :max_width 0.6}})))}
