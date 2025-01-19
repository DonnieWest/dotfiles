{1 :mfussenegger/nvim-dap
 :dependencies [{1 :rcarriga/nvim-dap-ui :opts {}}
                :nvim-neotest/nvim-nio
                {1 :theHamsta/nvim-dap-virtual-text :opts {}}
                :nvim-telescope/telescope-dap.nvim]
 :init #(let [dap (require :dap)]
          (tset dap.listeners.before.event_terminated :dapui_config
                (fn []
                  (dapui.close)))
          (tset dap.listeners.before.event_exited :dapui_config
                (fn []
                  (dapui.close)))
          (tset dap.listeners.after.event_initialized :dapui_config
                (fn []
                  (dapui.open))))}

