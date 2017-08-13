#!/usr/bin/python

import commands
import time
import os

#find process
pc = commands.getoutput('ps -aux | grep zmwatch.pl | grep -v grep').strip()

if(len(pc) > 0):
          print 'zoneminder running. skip'

else:
	  print 'zoneminder not running'
          os.system('sudo service zoneminder start')
  	  print 'zoneminder started'
