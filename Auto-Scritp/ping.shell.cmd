@echo off
title Auto Ping Monitor
color 0A

start "PING 8.8.8.8" cmd /k "ping -t 8.8.8.8"
start "PING 4.4.5.5" cmd /k "ping -t 4.4.5.5"
start "PING 1.1.1.1" cmd /k "ping -t 1.1.1.1"
start "PING 192.168.1.1" cmd /k "ping -t 192.168.1.1"
start "PING 192.168.1.254" cmd /k "ping -t 192.168.1.254"

exit