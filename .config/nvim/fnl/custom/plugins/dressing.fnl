(fn update-root []
  (let [buf (vim.api.nvim_get_current_buf)
        bt (vim.api.nvim_get_option_value :buftype {:buf buf})
        name (vim.api.nvim_buf_get_name buf)]
    (when (and (= bt "") (not= name ""))
      (let [path (vim.fs.normalize name)
            root (vim.fs.root path [".git"
                                    "package.json"
                                    "tsconfig.json"
                                    "pyproject.toml"
                                    "build.gradle"
                                    "build.gradle.kts"
                                    "settings.gradle"
                                    "settings.gradle.kts"
                                    "pom.xml"
                                    "Cargo.toml"
                                    "go.mod"
                                    "deps.edn"
                                    "project.clj"])]
        (when (and root (not= root (vim.fn.getcwd -1 0)))
          (vim.cmd.lcd (vim.fn.fnameescape root)))))))

{1 :folke/snacks.nvim
 :lazy false
 :priority 900
 :init (fn []
         (vim.api.nvim_create_autocmd [:BufEnter]
                                      {:callback update-root}))
 :opts {:input {:enabled true}
        :picker {:enabled true}}}
