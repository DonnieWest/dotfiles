(module plugin.neorg
  {require {core aniseed.core
            nvim aniseed.nvim
            neorg neorg}})

(neorg.setup
  {:load
   {:core
    {:defaults {}
     :norg {
            :concealer {}
            :dirman {:config {:workspaces {:my_workspace "~/Code/notes"}}}}}}})
