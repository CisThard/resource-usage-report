#!/bin/bash

# setup for cron

# source /home/$(echo $USER)/resource-usage-report/setup/user.sh 
#source /home/se2on/resource-usage-report/setup/user.sh 
source /home/se20n/resource-usage-report/setup/user.sh

# CRON_JOB="6 * * * * /home/se2on/resource-usage-report/collect.sh"
CRON_JOB="6 * * * * /bin/bash -c '/bin/bash /home/se2on/resource-usage-report/analyze.sh >> /home/se20n/resource-usage-report/analyze.txt 2>&1'"

export CRON_JOB

#runuser -u "${MONITOR_USER}" -- bash -c "
#	crontab -l 2>/dev/null | grep -Fv \"$CRON_JOB\"; \
#        echo \"$CRON_JOB\"
#	" | runuser -u "${MONITOR_USER}" -- crontab -

runuser -u "$MONITOR_USER" -- sh -c \
'crontab -l 2>/dev/null | grep -Fv "$CRON_JOB"; echo "$CRON_JOB"' \
| runuser -u "$MONITOR_USER" -- crontab -

sudo chown monitoring:monitoring /home/se20n/resource-usage-report/
sudo chmod 755 /home/se20n/resource-usage-report/

crontab -l -u "$MONITOR_USER"

sudo crontab -l

