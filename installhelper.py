#!/usr/bin/python

import os
from crontab import CronTab

cron = CronTab(user='root')
os.system('cp ./checkzm.py /usr/bin')
os.system('sudo chmod +x /usr/bin/checkzm.py')


job = cron.new(command='/usr/bin/checkzm.py')
job.minute.every(1)
cron.write()
