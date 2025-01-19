(module plugin.dap {require {nvim aniseed.nvim dap dap dapui dapui virtual nvim-dap-virtual-text}})

(virtual.setup {:commented true})
(dapui.setup)

(tset dap.listeners.after.event_initialized :dapui_config
      (fn []
        (dapui.open)))

(tset dap.listeners.before.event_terminated :dapui_config
      (fn []
        (dapui.close)))

(tset dap.listeners.before.event_exited :dapui_config
      (fn []
        (dapui.close)))
