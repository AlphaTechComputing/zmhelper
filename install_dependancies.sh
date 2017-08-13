#!/bin/bash

sudo apt-get update
sudo apt-get upgrade

sudo apt-get install lamp-server^

sudo apt-get install -y python-pip
sudo pip install -y python-crontab
