(fn breadcrumb []
  (let [default-bar (.. "%#NavicText#" (vim.fn.expand "%:.") "%*")
        navic (require :nvim-navic)]
    (if (not (and navic (navic.is_available)))
        default-bar
        (let [bar (navic.get_location)]
          (if (= bar "")
              default-bar
              bar)))))

(fn attached_lsp []
  (let [servers {}]
    (each [_ v (pairs (vim.lsp.get_clients))]
      (table.insert servers v.name))
    (table.concat servers " ")))

(local colors {:bg "#03090e"                  ;; Background
               :alt_bg "#0a3749"             ;; Alternate Background
               :fg "#d3ebe9"                 ;; Foreground
               :light_fg "#b2d8d3"           ;; Lighter Foreground
               :dark_fg "#526b79"            ;; Darker Foreground
               :normal "#599cab"             ;; Normal Mode
               :insert "#2aa889"             ;; Insert Mode
               :replace "#d26937"            ;; Replace Mode
               :visual "#edb443"})           ;; Visual Mode

(local theme
  {:normal {:a {:fg colors.bg :bg colors.normal}
            :b {:fg colors.light_fg :bg colors.alt_bg}
            :c {:fg colors.fg :bg colors.bg}}
   :replace {:a {:fg colors.bg :bg colors.replace}
             :b {:fg colors.light_fg :bg colors.alt_bg}}
   :insert {:a {:fg colors.bg :bg colors.insert}
            :b {:fg colors.light_fg :bg colors.alt_bg}}
   :visual {:a {:fg colors.bg :bg colors.visual}
            :b {:fg colors.light_fg :bg colors.alt_bg}}
   :inactive {:a {:fg colors.dark_fg :bg colors.bg}
              :b {:fg colors.dark_fg :bg colors.bg}
              :c {:fg colors.dark_fg :bg colors.bg}}})

;; Set additional states if needed
(set theme.command theme.normal)
(set theme.terminal theme.insert)

{1 :nvim-lualine/lualine.nvim
 :dependencies [:arkav/lualine-lsp-progress :SmiteshP/nvim-navic]
 :opts {:always_show_tabline true
        :options {:theme theme}
        :sections {:lualine_c [attached_lsp :lsp_progress]}
        :tabline {:lualine_a [:buffers]
                  :lualine_b []
                  :lualine_c []
                  :lualine_x []
                  :lualine_y []
                  :lualine_z []}}}

