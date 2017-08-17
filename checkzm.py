#!/usr/bin/python

import commands
import time
import os
import logging
from time import gmtime, strftime

#find process
pc = commands.getoutput('ps -aux | grep zmwatch.pl | grep -v grep').strip()
time_format = "%Y-%m-%d %H:%M:%S"

logging.basicConfig(filename='/var/log/checkzm.log',level=logging.DEBUG)

if(len(pc) > 0):
	print 'zoneminder running. skip'
	log_time = strftime(time_format, time.localtime()) + ':'
	logging.info(log_time + 'zoneminder running.')


else:
	log_time = strftime(time_format, time.localtime()) + ':'
        logging.warning(log_time + 'zoneminder not running, starting.')
        os.system('sudo service zoneminder start')
  	print 'zoneminder not running, starting.'
