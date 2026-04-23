(local M {})

(local imports-by-prefix
       {:ktvm ["androidx.lifecycle.ViewModel"
               "androidx.lifecycle.viewModelScope"
               "kotlinx.coroutines.flow.MutableStateFlow"
               "kotlinx.coroutines.flow.StateFlow"
               "kotlinx.coroutines.flow.asStateFlow"
               "kotlinx.coroutines.launch"]
        :ktrep ["kotlinx.coroutines.flow.Flow"]
        :ktent ["androidx.room.Entity" "androidx.room.PrimaryKey"]
        :ktdao ["androidx.room.*" "kotlinx.coroutines.flow.Flow"]
        :ktdb ["android.content.Context"
               "androidx.room.Database"
               "androidx.room.Room"
               "androidx.room.RoomDatabase"]
        :ktcf ["androidx.compose.runtime.Composable"]
        :ktcfs ["androidx.compose.runtime.*"]
        :ktprev ["androidx.compose.runtime.Composable"
                 "androidx.compose.ui.tooling.preview.Preview"]
        :ktscaffold ["androidx.compose.material3.*"
                     "androidx.compose.material.icons.Icons"
                     "androidx.compose.material.icons.filled.Add"
                     "androidx.compose.ui.Modifier"]
        :ktbottomsheet ["androidx.compose.material3.*"
                        "androidx.compose.runtime.*"
                        "androidx.compose.ui.unit.dp"]
        :kttab ["androidx.compose.material3.*"
                "androidx.compose.material.icons.Icons"
                "androidx.compose.material.icons.filled.ArrowBack"]
        :ktnav ["androidx.compose.runtime.Composable"
                "androidx.navigation.compose.NavHost"
                "androidx.navigation.compose.composable"
                "androidx.navigation.compose.rememberNavController"]
        :kthiltvm ["androidx.lifecycle.ViewModel"
                   "androidx.lifecycle.viewModelScope"
                   "dagger.hilt.android.lifecycle.HiltViewModel"
                   "kotlinx.coroutines.flow.MutableStateFlow"
                   "kotlinx.coroutines.flow.StateFlow"
                   "kotlinx.coroutines.flow.asStateFlow"
                   "kotlinx.coroutines.launch"
                   "javax.inject.Inject"]})

(var cached-defs nil)

(fn load-defs []
  (if cached-defs
      cached-defs
      (let [path (.. (vim.fn.stdpath :config) "/data/kotlin-snippets.json")
            raw (table.concat (vim.fn.readfile path) "\n")
            decoded (vim.json.decode raw)
            defs {}]
        (each [key snippet (pairs decoded)]
          (let [prefix snippet.prefix]
            (tset defs prefix {:key key
                               :prefix prefix
                               :description (or snippet.description key)
                               :body (table.concat (or snippet.body []) "\n")
                               :imports (. imports-by-prefix prefix)})))
        (set cached-defs defs)
        defs)))

(fn M.all []
  (load-defs))

(fn M.expand-body [def ctx]
  (let [body def.body
        class-name ctx.class-name
        table-name ctx.table-name
        database-name ctx.database-name]
    (var current body)
    (set current (current:gsub (vim.pesc "${1:Name}") (.. "${1:" class-name "}")))
    (set current (current:gsub (vim.pesc "${3:Name}") (.. "${3:" class-name "}")))
    (set current (current:gsub (vim.pesc "${4:Name}") (.. "${4:" class-name "}")))
    (set current (current:gsub (vim.pesc "${1:items}") (.. "${1:" table-name "}")))
    (set current (current:gsub (vim.pesc "${2:items}") (.. "${2:" table-name "}")))
    (set current (current:gsub (vim.pesc "${5:name_database}") (.. "${5:" database-name "}")))
    current))

M
