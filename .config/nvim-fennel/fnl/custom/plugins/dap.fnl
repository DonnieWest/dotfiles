{1 :mfussenegger/nvim-dap
 :dependencies [:rcarriga/nvim-dap-ui
                :nvim-neotest/nvim-nio
                :theHamsta/nvim-dap-virtual-text
                :nvim-telescope/telescope-dap.nvim]
 :init (fn []
         (local dap (require :dap))
         (local dapui (require :dapui))
         (dapui.setup)
         ((. (require :nvim-dap-virtual-text) :setup) {:commented true})
         (tset dap.listeners.before.event_terminated :dapui_config
               (fn []
                 (dapui.close)))
         (tset dap.listeners.before.event_exited :dapui_config
               (fn []
                 (dapui.close)))
         (tset dap.listeners.after.event_initialized :dapui_config
               (fn []
                 (dapui.open))))}

