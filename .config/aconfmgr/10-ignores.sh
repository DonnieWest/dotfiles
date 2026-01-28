IgnorePath '/var/lib/swapspace/*'
IgnorePath '/var/lib/pacman/local/*'

# Ollama Data (Models)
IgnorePath '/var/lib/ollama/*'

# Libvirt (Images and State)
IgnorePath '/var/lib/libvirt/images/*'
IgnorePath '/var/lib/libvirt/boot/*'
IgnorePath '/var/lib/libvirt/qemu/*'

# Zephyr SDK (Large SDK)
IgnorePath '/opt/zephyr-sdk/*'

# Postgres Data
IgnorePath '/var/lib/postgres/*'

# Container Storage (Podman/Buildah)
IgnorePath '/var/lib/containers/*'

# Waydroid Images
IgnorePath '/var/lib/waydroid/*'

# ClamAV Definitions
IgnorePath '/var/lib/clamav/*'

# System Caches
IgnorePath '/var/cache/*'

# Generated System Configuration
IgnorePath '/usr/share/mime/*'
IgnorePath '/etc/ssl/certs/*'
IgnorePath '/etc/ca-certificates/extracted/*'
IgnorePath '/etc/xml/catalog'
IgnorePath '/opt/.cisco/*'

# System Logs and Temp
IgnorePath '/var/log/*'
IgnorePath '/var/log/journal/*'
IgnorePath '/var/tmp/*'
IgnorePath '/var/spool/*'

# Binary Caches & Generated State
IgnorePath '/etc/ld.so.cache'
IgnorePath '/etc/udev/hwdb.bin'
IgnorePath '/usr/lib/udev/hwdb.bin'
IgnorePath '/var/lib/systemd/*'
IgnorePath '/etc/adjtime'
IgnorePath '/usr/lib/firefox-developer-edition/*.bak'

# Kernel Modules & Firmware Generation
IgnorePath '/usr/lib/modules/*'

# Compiled Python Files (Global)
IgnorePath '*/__pycache__/*'
IgnorePath '*.pyc'

# Generated System Caches (Icons, Glib, Mime, Loaders)
IgnorePath '/usr/share/icons/*/icon-theme.cache'
IgnorePath '/usr/share/applications/mimeinfo.cache'
IgnorePath '/usr/share/glib-2.0/schemas/gschemas.compiled'
IgnorePath '/usr/lib/**/modules/*.cache'
IgnorePath '/usr/lib/**/loaders.cache'
IgnorePath '/usr/lib/**/immodules.cache'
IgnorePath '/usr/lib/gconv/gconv-modules.cache'

# Pacman / System Configuration
IgnorePath '/var/lib/pacman/sync/*'
IgnorePath '/etc/pacman.d/gnupg/*'
IgnorePath '/usr/lib/ghc-*/lib/package.conf.d/*'

# LVM Backups
IgnorePath '/etc/lvm/archive/*'
IgnorePath '/etc/lvm/backup/*'

# Boot Images (Generated)
IgnorePath '/boot/initramfs*'
IgnorePath '/boot/vmlinuz*'

# Security: SSH Host Keys (DO NOT COMMIT)
IgnorePath '/etc/ssh/ssh_host_*'

# -------------------------------------------------------------------
# User Requested Ignores (Sensitive Data, Logs, Hardware State)
# -------------------------------------------------------------------

# Bitlbee Logs & Cache
IgnorePath '/var/lib/bitlbee/**/logs/*'
IgnorePath '/var/lib/bitlbee/**/certificates/*'
IgnorePath '/var/lib/bitlbee/.cache/*'

# Gitolite SSH Keys
IgnorePath '/data/gitolite/ssh/ssh_host_*'

# Bootloader & EFI (Hardware/Install specific)
IgnorePath '/boot/EFI/*'
IgnorePath '/boot/loader/*'

# Security: Secrets & Keys
IgnorePath '/etc/profile.d/variables.sh' # Environment Secrets
IgnorePath '/var/lib/sbctl/*'    # Secure Boot Keys
IgnorePath '/var/lib/iwd/*'      # WiFi Credentials
IgnorePath '/var/lib/fprint/*'   # Biometric Data
IgnorePath '/var/lib/caddy/*'    # Web Server Certificates
IgnorePath '/var/lib/fwupd/*'    # Firmware Update Keys/Cache
IgnorePath '/var/lib/passim/*'   # Local Caching Keys
IgnorePath '/etc/shadow*'        # Password Hashes
IgnorePath '/etc/gshadow*'       # Group Password Hashes
IgnorePath '/etc/u2f_keys'       # U2F Keys

# Hardware State & Bluetooth
IgnorePath '/var/lib/bluetooth'
IgnorePath '/var/lib/bitlbee'
IgnorePath '/var/lib/cloudflare-warp'
IgnorePath '/var/lib/dkms'
IgnorePath '/var/lib/libvirt/images'
IgnorePath '/var/lib/libvirt/qemu'
IgnorePath '/var/lib/libvirt/dnsmasq'
IgnorePath '/var/lib/machines'
IgnorePath '/var/lib/portables'
IgnorePath '/var/lib/private'
IgnorePath '/var/lib/tpm2-tss'
IgnorePath '/var/lib/cni'
IgnorePath '/var/lib/fangfrisch'
IgnorePath '/var/lib/geoclue'
IgnorePath '/var/lib/lastlog'
IgnorePath '/var/lib/misc'
IgnorePath '/var/lib/rpcbind'
IgnorePath '/var/lib/xmms2'
IgnorePath '/var/db/sudo/lectured'

# Secrets and Certificates
IgnorePath '/etc/shadow*'
IgnorePath '/etc/gshadow*'
IgnorePath '/etc/.#*'
IgnorePath '/etc/sudoers.d/00_igneo676'
IgnorePath '/etc/ssh/sshd_config'
IgnorePath '/etc/ca-certificates/trust-source'
IgnorePath '/etc/ssl/certs'
IgnorePath '/etc/pacman.d/gnupg'

# System Hardware and ID
IgnorePath '/etc/machine-id'
IgnorePath '/var/lib/dbus/machine-id'    # systemd creates this symlink
IgnorePath '/etc/shells'                 # updated by shell packages
IgnorePath '/etc/os-release'             # base package symlink
IgnorePath '/etc/adjtime'
IgnorePath '/etc/udev/hwdb.bin'
IgnorePath '/boot/intel-ucode.img'

# Printers and Network Noise
IgnorePath '/etc/hosts'              # Large ad-blocking hosts file (regenerate with hostsctl)
IgnorePath '/etc/cups/printers.conf*'
IgnorePath '/etc/cups/subscriptions.conf*'
IgnorePath '/etc/pacman.d/mirrorlist*'
IgnorePath '/opt/cisco'

# Generated Caches and Databases
IgnorePath '/etc/texmf/ls-R'
IgnorePath '/etc/texmf/web2c/*'          # texlive auto-generated
IgnorePath '/usr/share/perl5/vendor_perl/XML/SAX/ParserDetails.ini' # perl-xml-sax generated
IgnorePath '/usr/share/texmf-dist/ls-R'
IgnorePath '/usr/share/info/dir'
IgnorePath '/usr/share/vim/vimfiles/doc/tags'
IgnorePath '/usr/lib/locale/locale-archive'
IgnorePath '/usr/lib32/gconv/gconv-modules.cache'
IgnorePath '/usr/lib32/gio/modules/giomodule.cache'
IgnorePath '/var/cache/ldconfig/aux-cache'

IgnorePath '/etc/passwd-'
IgnorePath '/etc/passwd.OLD'
IgnorePath '/etc/group-'
IgnorePath '/etc/gshadow-'
IgnorePath '/etc/shadow-'
IgnorePath '/etc/subuid-'
IgnorePath '/etc/subgid-'
IgnorePath '/etc/brlapi.key'

IgnorePath '/opt/ventoy/log.txt'
IgnorePath '/usr/lib/graphviz/config8'
IgnorePath '/usr/lib/luarocks/rocks-*/manifest'

IgnorePath '/etc/cups/classes.conf*'
IgnorePath '/etc/cups/ppd'
IgnorePath '/etc/printcap'
IgnorePath '/etc/resolv.conf-warp'
IgnorePath '/etc/libvirt/nwfilter/*'
IgnorePath '/etc/libvirt/qemu/networks/default.xml'
IgnorePath '/etc/httpd/conf/httpd.conf'
IgnorePath '/etc/dconf/db/ibus'
IgnorePath '/etc/containers/registries.conf.d/01-registries.conf'
IgnorePath '/opt/jmeter'
IgnorePath '/usr/lib/fwupd/efi'
IgnorePath '/opt/intel/oneapi/compiler/*/linux/lib/libshim_l0.so*'

# Temporary / Volatile
IgnorePath '/etc/*.pacnew'
IgnorePath '/etc/*.pacsave'
IgnorePath '/etc/xml/catalog'
IgnorePath '/var/lib/boltd/*'
IgnorePath '/var/lib/upower/*'

# Network State
IgnorePath '/var/lib/dhcpcd/*'

# Generated Files
IgnorePath '/var/lib/texmf/*'
IgnorePath '/etc/.pwd.lock'
IgnorePath '/etc/.updated'
IgnorePath '/var/.updated'

# Package default permissions (no need to track)
IgnorePath '/usr/bin/groupmems'          # shadow package default
IgnorePath '/usr/lib/utempter/utempter'  # libutempter package default
