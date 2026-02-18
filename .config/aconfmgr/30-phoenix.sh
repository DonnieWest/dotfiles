# Phoenix-specific configurations
# This file contains settings that only apply to the Phoenix host

if [[ "$HOSTNAME" == "phoenix" ]]; then


# Regular packages

AddPackage python-fangfrisch # Freshclam like utility that allows downloading unofficial virus definition files
AddPackage slack-desktop # Slack Desktop (Beta) for Linux
AddPackage teams-for-linux # Unofficial Microsoft Teams client for Linux using Electron.


# Foreign packages

AddPackage --foreign teams # Microsoft Teams for Linux is your chat-centered workspace in Office 365


# Files

CopyFile /etc/ananicy.d/01-custom/clamav-extra.rules
CopyFile /etc/clamav/clamd.conf
CopyFile /etc/clamav/virus-event.bash 755
CopyFile /etc/sudoers.d/clamav
CopyFile /etc/systemd/system/clamav-clamonacc.service.d/override.conf
CopyFile /etc/systemd/system/clamav-daemon.service.d/override.conf
CreateLink /etc/systemd/system/multi-user.target.wants/clamav-clamonacc.service /usr/lib/systemd/system/clamav-clamonacc.service
CreateLink /etc/systemd/system/multi-user.target.wants/clamav-daemon.service /usr/lib/systemd/system/clamav-daemon.service
CreateLink /etc/systemd/system/multi-user.target.wants/clamav-freshclam.service /usr/lib/systemd/system/clamav-freshclam.service
CreateLink /etc/systemd/system/sockets.target.wants/clamav-daemon.socket /usr/lib/systemd/system/clamav-daemon.socket
CreateLink /etc/systemd/system/timers.target.wants/clamav-freshclam-once.timer /usr/lib/systemd/system/clamav-freshclam-once.timer
CreateLink /etc/systemd/system/timers.target.wants/fangfrisch.timer /usr/lib/systemd/system/fangfrisch.timer


# File properties

SetFileProperty /etc/fangfrisch/fangfrisch-has-news.sh group clamav


fi
