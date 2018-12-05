#!/usr/bin/groovy
/*
To enable talking to user instance of Systemd, export XDG_RUNTIME_DIR, then restart Jenkins.

$ head ~/.profile ~/.config/systemd/user/dummy.*
==> /var/lib/jenkins/.profile <==
export XDG_RUNTIME_DIR=/run/user/$(id -u)

==> /var/lib/jenkins/.config/systemd/user/dummy.service <==
[Unit]
Description=Do nothing

[Service]
Type=oneshot
ExecStart=/bin/true

==> /var/lib/jenkins/.config/systemd/user/dummy.timer <==
[Unit]
Description=Run dummy no-op service

[Timer]
OnCalendar=yearly
*/
