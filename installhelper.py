#!/usr/bin/python

import os
from crontab import CronTab

cron = CronTab(user='root')
os.system('cp ./checkzm.py /usr/bin')
os.system('sudo chmod +x /usr/bin/checkzm.py')


job = cron.new(command='/usr/bin/checkzm.py')
job.minute.every(1)
cron.write()

os.system('sudo crontab -l')

with open("/etc/logrotate.conf", "a") as myfile:
  myfile.write("\n" + "/var/log/checkzm.log {" + "\n\t monthly \n\t size 100M \n\t compress \n\t delaycompress \n\t missingok \n\t notifempty \n\t create 644 root root \n }")
