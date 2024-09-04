### My Setup:
- A SBC(Single Board Computer) with a battery so that it doesn't turn off when there is no power.
- A router normally connected to electricity.

### Script to check if there is power at home:
This script pings the router every minute and notifies if the electricity is down. To ping every minute you can use cronjob.

## Check cronjob
```console
orangepi@orangepi3b:~$ sudo crontab -e
[sudo] password for orangepi:
No modification made
```
```console
# Edit this file to introduce tasks to be run by cron.
#
# Each task to run has to be defined through a single line
# indicating with different fields when the task will be run
# and what command to run for the task
#
# To define the time you can provide concrete values for
# minute (m), hour (h), day of month (dom), month (mon),
# and day of week (dow) or use '*' in these fields (for 'any').
#
# Notice that tasks will be started based on the cron's system
# daemon's notion of time and timezones.
#
# Output of the crontab jobs (including errors) is sent through
# email to the user the crontab file belongs to (unless redirected).
#
# For example, you can run a backup of all your user accounts
# at 5 a.m every week with:
# 0 5 * * 1 tar -zcf /var/backups/home.tgz /home/
#
# For more information see the manual pages of crontab(5) and cron(8)
#
# m h  dom mon dow   command
*/1 * * * * /home/orangepi/scripts/electricity.sh >> /home/orangepi/scripts/electricity.log 2>&1
0 */1 * * * /home/orangepi/scripts/clearlog.sh
```

The first script runs once every minute.

The clearlog.sh script clears the electricity.log 100 lines every hour so that the log doesn't take too much space.
