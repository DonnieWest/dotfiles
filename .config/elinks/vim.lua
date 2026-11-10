-- Vim-like navigation and alphabetic link hints for ELinks.
-- Load this near the end of hooks.lua, after pre_format_html_hooks exists.

local hint_alphabet = "asdfghjkl"
local hint_mode = false
local hint_prefix = ""
local hint_urls = {}

local function hint_label(number, width)
    local base = string.len(hint_alphabet)
    local label = ""

    number = number - 1
    for _ = 1, width do
        local digit = math.fmod(number, base) + 1
        label = string.sub(hint_alphabet, digit, digit) .. label
        number = math.floor(number / base)
    end
    return label
end

local function hint_width(count)
    local base = string.len(hint_alphabet)
    local width = 1
    local capacity = base

    while capacity < count do
        width = width + 1
        capacity = capacity * base
    end
    return width
end

local function anchor_href(tag)
    local href = string.match(tag, '[hH][rR][eE][fF]%s*=%s*"([^"]*)"')
    if not href then
        href = string.match(tag, "[hH][rR][eE][fF]%s*=%s*'([^']*)'")
    end
    if not href then
        href = string.match(tag, "[hH][rR][eE][fF]%s*=%s*([^%s>]+)")
    end
    return href
end

local function resolve_href(base, href)
    href = string.gsub(href, "&amp;", "&")
    if string.match(href, "^[%a][%w+.-]*:") then return href end

    local scheme, authority = string.match(base or "", "^([%a][%w+.-]*:)//([^/]*)")
    if not scheme then return href end
    if string.sub(href, 1, 2) == "//" then return scheme .. href end

    local origin = scheme .. "//" .. authority
    if string.sub(href, 1, 1) == "/" then return origin .. href end

    base = string.gsub(base, "[#?].*$", "")
    if href == "" then return base end
    if string.sub(href, 1, 1) == "#" or string.sub(href, 1, 1) == "?" then
        return base .. href
    end

    local directory = base == origin and origin or string.match(base, "^(.*)/")
    directory = directory or origin
    local path = directory .. "/" .. href
    repeat
        local changed
        path, changed = string.gsub(path, "/[^/]+/%.%./", "/", 1)
    until changed == 0
    path = string.gsub(path, "/%./", "/")
    return path
end

local function strip_hints(html)
    return string.gsub(html,
        "<!%-%-elinks%-vim%-hint%-%->.-<!%-%-/elinks%-vim%-hint%-%->", "")
end

local function add_hints(url, html)
    local stripped
    html, stripped = strip_hints(html)
    if not hint_mode then return stripped > 0 and html or nil, nil end

    local anchors = {}
    string.gsub(html, "<[aA]%s[^>]->", function(tag)
        if anchor_href(tag) then table.insert(anchors, tag) end
    end)

    hint_urls = {}
    local width = hint_width(#anchors)
    local index = 0
    local changed
    html, changed = string.gsub(html, "(<[aA]%s[^>]->)", function(tag)
        local href = anchor_href(tag)
        if not href then return tag end

        index = index + 1
        local label = hint_label(index, width)
        hint_urls[label] = resolve_href(url, href)
        return "<!--elinks-vim-hint--><b>[" .. label ..
            "]</b><!--/elinks-vim-hint-->" .. tag
    end)
    return changed > 0 and html or nil, nil
end

if pre_format_html_hooks then
    table.insert(pre_format_html_hooks, add_hints)
else
    local previous_pre_format_html_hook = pre_format_html_hook
    function pre_format_html_hook(url, html)
        if previous_pre_format_html_hook then
            html = previous_pre_format_html_hook(url, html) or html
        end
        return add_hints(url, html)
    end
end

local function leave_hint_mode(refresh)
    hint_mode = false
    hint_prefix = ""
    hint_urls = {}
    if refresh then reload() end
end

local function enter_hint_mode()
    hint_mode = true
    hint_prefix = ""
    reload()
end

local function hint_key(key)
    if not hint_mode then return false end

    hint_prefix = hint_prefix .. key
    local exact = hint_urls[hint_prefix]
    if exact then
        leave_hint_mode(false)
        goto_url(exact)
        return true
    end

    for label in pairs(hint_urls) do
        if string.sub(label, 1, string.len(hint_prefix)) == hint_prefix then
            return true
        end
    end

    leave_hint_mode(true)
    return true
end

local normal_actions = {
    h = "scroll-left",
    j = "scroll-down",
    k = "scroll-up",
    l = "scroll-right",
    d = "move-half-page-down",
    u = "move-half-page-up",
    b = "move-page-up",
    o = "goto-url",
    r = "reload",
    H = "history-move-back",
    L = "history-move-forward",
    J = "tab-next",
    K = "tab-prev",
    G = "move-document-end",
}

local bound = {}
local function bind(key, handler)
    if bound[key] then return end
    bound[key] = true
    bind_key("main", key, handler)
end

for key, action in pairs(normal_actions) do
    local bound_key = key
    local bound_action = action
    bind(bound_key, function()
        if hint_key(bound_key) then return end
        execute_action(bound_action)
    end)
end

bind("f", function()
    if hint_mode then
        hint_key("f")
    else
        enter_hint_mode()
    end
end)

for index = 1, string.len(hint_alphabet) do
    local key = string.sub(hint_alphabet, index, index)
    local bound_key = key
    bind(bound_key, function() hint_key(bound_key) end)
end

bind("Escape", function()
    if hint_mode then leave_hint_mode(true) end
end)

bind("g", function()
    if hint_key("g") then return end
    execute_action("move-document-start")
end)
