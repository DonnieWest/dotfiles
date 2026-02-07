#!/bin/bash
# Gotham-Noir-Ultra LS_COLORS for lf and terminal file listings
# Source this file in your shell (.bashrc, .zshrc, etc.):
# source ~/.config/lf/gotham-ls-colors.sh

# ANSI color codes for Gotham-Noir-Ultra theme
# 0;30 - Black       #03090e
# 0;31 - Red         #ff5555
# 0;32 - Green       #50fa7b
# 0;33 - Yellow      #ffd700
# 0;34 - Blue        #8be9fd (using cyan as blue)
# 0;35 - Magenta     #ff79c6
# 0;36 - Cyan        #33c2de
# 0;37 - White       #e6f9f7
# Bright versions (prefix with 1; instead of 0;)

# Build LS_COLORS
declare -A colors

# Default directory
colors[di]="1;36"  # Cyan bold for directories

# Files by type
colors[ln]="1;36"  # Cyan bold for symlinks
colors[or]="1;31"  # Red bold for broken symlinks
colors[ex]="1;32"  # Green bold for executables
colors[bd]="1;33"  # Yellow bold for block devices
colors[cd]="1;33"  # Yellow bold for character devices
colors[pi]="1;35"  # Pink for named pipes
colors[so]="1;35"  # Pink for sockets
colors[do]="1;35"  # Pink for doors

# Archives (Pink)
colors["*.tar"]="1;35"
colors["*.tgz"]="1;35"
colors["*.arc"]="1;35"
colors["*.arj"]="1;35"
colors["*.taz"]="1;35"
colors["*.lha"]="1;35"
colors["*.lz4"]="1;35"
colors["*.lzh"]="1;35"
colors["*.lzma"]="1;35"
colors["*.tlz"]="1;35"
colors["*.txz"]="1;35"
colors["*.tzo"]="1;35"
colors["*.t7z"]="1;35"
colors["*.zip"]="1;35"
colors["*.z"]="1;35"
colors["*.dz"]="1;35"
colors["*.gz"]="1;35"
colors["*.lrz"]="1;35"
colors["*.lz"]="1;35"
colors["*.lzo"]="1;35"
colors["*.xz"]="1;35"
colors["*.zst"]="1;35"
colors["*.tzst"]="1;35"
colors["*.bz2"]="1;35"
colors["*.bz"]="1;35"
colors["*.tbz"]="1;35"
colors["*.tbz2"]="1;35"
colors["*.tz"]="1;35"
colors["*.deb"]="1;35"
colors["*.rpm"]="1;35"
colors["*.jar"]="1;35"
colors["*.war"]="1;35"
colors["*.ear"]="1;35"
colors["*.sar"]="1;35"
colors["*.rar"]="1;35"
colors["*.alz"]="1;35"
colors["*.ace"]="1;35"
colors["*.zoo"]="1;35"
colors["*.cpio"]="1;35"
colors["*.7z"]="1;35"
colors["*.rz"]="1;35"
colors["*.cab"]="1;35"
colors["*.wim"]="1;35"
colors["*.swm"]="1;35"
colors["*.dwm"]="1;35"
colors["*.esd"]="1;35"

# Images (Purple)
colors["*.jpg"]="1;35"
colors["*.jpeg"]="1;35"
colors["*.mjpg"]="1;35"
colors["*.mjpeg"]="1;35"
colors["*.gif"]="1;35"
colors["*.bmp"]="1;35"
colors["*.pbm"]="1;35"
colors["*.pgm"]="1;35"
colors["*.ppm"]="1;35"
colors["*.tga"]="1;35"
colors["*.xbm"]="1;35"
colors["*.xpm"]="1;35"
colors["*.tif"]="1;35"
colors["*.tiff"]="1;35"
colors["*.png"]="1;35"
colors["*.svg"]="1;35"
colors["*.svgz"]="1;35"
colors["*.mng"]="1;35"
colors["*.pcx"]="1;35"
colors["*.mov"]="1;35"
colors["*.mpg"]="1;35"
colors["*.mpeg"]="1;35"
colors["*.m2v"]="1;35"
colors["*.mkv"]="1;35"
colors["*.webm"]="1;35"
colors["*.ogm"]="1;35"
colors["*.mp4"]="1;35"
colors["*.m4v"]="1;35"
colors["*.mp4v"]="1;35"
colors["*.vob"]="1;35"
colors["*.qt"]="1;35"
colors["*.nuv"]="1;35"
colors["*.wmv"]="1;35"
colors["*.asf"]="1;35"
colors["*.rm"]="1;35"
colors["*.rmvb"]="1;35"
colors["*.flc"]="1;35"
colors["*.avi"]="1;35"
colors["*.fli"]="1;35"
colors["*.flv"]="1;35"
colors["*.gl"]="1;35"
colors["*.dl"]="1;35"
colors["*.xcf"]="1;35"
colors["*.xwd"]="1;35"
colors["*.yuv"]="1;35"
colors["*.cgm"]="1;35"
colors["*.emf"]="1;35"
colors["*.ogv"]="1;35"
colors["*.ogx"]="1;35"

# Audio (Light Cyan)
colors["*.aac"]="1;36"
colors["*.au"]="1;36"
colors["*.flac"]="1;36"
colors["*.m4a"]="1;36"
colors["*.mid"]="1;36"
colors["*.midi"]="1;36"
colors["*.mka"]="1;36"
colors["*.mp3"]="1;36"
colors["*.mpc"]="1;36"
colors["*.ogg"]="1;36"
colors["*.ra"]="1;36"
colors["*.wav"]="1;36"
colors["*.oga"]="1;36"
colors["*.opus"]="1;36"
colors["*.spx"]="1;36"
colors["*.xspf"]="1;36"

# Code files - Python (Green)
colors["*.py"]="0;32"
colors["*.pyc"]="2;32"
colors["*.pyd"]="2;32"
colors["*.pyo"]="2;32"

# Code files - JavaScript/TypeScript (Yellow/Cyan)
colors["*.js"]="0;33"
colors["*.mjs"]="0;33"
colors["*.ts"]="0;36"
colors["*.tsx"]="0;36"
colors["*.jsx"]="0;36"

# Code files - Web (Orange/Cyan)
colors["*.htm"]="0;33"
colors["*.html"]="0;33"
colors["*.css"]="0;36"
colors["*.scss"]="0;35"
colors["*.sass"]="0;35"
colors["*.less"]="0;36"

# Code files - Rust (Orange)
colors["*.rs"]="0;33"

# Code files - Go (Light Cyan)
colors["*.go"]="0;36"

# Code files - C/C++ (Cyan)
colors["*.c"]="0;36"
colors["*.h"]="0;35"
colors["*.cpp"]="0;36"
colors["*.hpp"]="0;35"
colors["*.cc"]="0;36"
colors["*.hh"]="0;35"

# Code files - Shell (Green)
colors["*.sh"]="0;32"
colors["*.bash"]="0;32"
colors["*.zsh"]="0;32"
colors["*.fish"]="0;32"
colors["*.csh"]="0;32"
colors["*.ksh"]="0;32"

# Code files - Lua (Cyan)
colors["*.lua"]="0;36"

# Code files - Java (Orange)
colors["*.java"]="0;33"
colors["*.jar"]="1;35"
colors["*.class"]="2;33"

# Code files - Ruby (Red)
colors["*.rb"]="0;31"
colors["*.gemspec"]="0;31"

# Config files (Yellow)
colors["*.yml"]="0;33"
colors["*.yaml"]="0;33"
colors["*.json"]="0;33"
colors["*.toml"]="0;33"
colors["*.ini"]="0;33"
colors["*.cfg"]="0;33"
colors["*.conf"]="0;33"

# Documentation (White/Light)
colors["*.md"]="0;37"
colors["*.markdown"]="0;37"
colors["*.txt"]="0;37"
colors["*.rst"]="0;37"
colors["*.doc"]="0;37"
colors["*.docx"]="0;37"
colors["*.pdf"]="1;31"
colors["*.epub"]="0;37"

# Build files (Yellow)
colors["Makefile"]="0;33"
colors["makefile"]="0;33"
colors["*.mk"]="0;33"
colors["CMakeLists.txt"]="0;33"
colors["*.cmake"]="0;33"

# Version control (Green)
colors["*.git"]="2;32"
colors["*.gitignore"]="0;32"
colors["*.gitattributes"]="0;32"

# Build the LS_COLORS string
export LS_COLORS=""

for key in "${!colors[@]}"; do
    if [[ -z "$LS_COLORS" ]]; then
        LS_COLORS="$key=${colors[$key]}"
    else
        LS_COLORS="$LS_COLORS:$key=${colors[$key]}"
    fi
done

export LS_COLORS
