(local lint (require :lint))

(set lint.linters.lit_analyzer.args
     [(vim.fs.joinpath (vim.fn.stdpath :config)
                       :scripts
                       :lit-analyzer-platform-ux.js)
      (. lint.linters.lit_analyzer.args 2)])

(fn platform-root []
  (let [root (vim.fs.root 0 [:yarn.lock :.git])]
    (when root
      (let [manifest (vim.fs.joinpath root :package.json)
            file (io.open manifest :r)]
        (when file
          (let [package (vim.json.decode (file:read "*a"))]
            (file:close)
            (when (= package.name "@banno/platform-ux")
              root)))))))

(fn people-terminal [command env]
  (let [root (platform-root)]
    (if (not root)
        (vim.notify "Not in the platform-ux repository" vim.log.levels.ERROR)
        (do
          (vim.cmd.botright :new)
          (vim.cmd.lcd
           (vim.fn.fnameescape
            (vim.fs.joinpath root :projects :people)))
          (let [argv [:yarn]]
            (vim.list_extend argv command)
            (vim.fn.jobstart argv {:term true : env}))
          (vim.cmd.startinsert)))))

(local commands
       {:PeopleStart [:start]
        :PeopleStartDevelopment [:start]
        :PeopleTest [:test]
        :PeopleLint [:lint]
        :PeopleBuild [:build]
        :PeopleBuildRelease [:build:release]})

(each [name command (pairs commands)]
  (vim.api.nvim_create_user_command
   name
   (fn [opts]
     (let [args (vim.deepcopy command)
           env (if (= name :PeopleStartDevelopment)
                   {:ENV :development}
                   (= name :PeopleStart)
                   {:ENV :staging}
                   nil)]
       (when (and (not= opts.args "") (not env))
         (vim.list_extend args opts.fargs))
       (people-terminal args env)))
   {:nargs "*" :complete :file}))
