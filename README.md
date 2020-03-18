# autopatch.bash

Automatic patching to be scheduled in cron and runs as root. Excludes certain packages so as to not break running systems.

Prereqs: python xbps-static

To use (install requires root):
1. git clone into /usr/share/autopatch.bash
1. run xbps-static.bash to get XBPS static in the right place
1. add to /etc/crontab the line "00 1 15 * * root /usr/share/autopatch.bash/autopatch.bash" (vary the time so you don't kill the mirror servers)

