#!/bin/sh

# kill any existing ntpclient processes
# (they can get stuck if no route to target host)
/usr/bin/killall ntpclient
      
# do time sync
/usr/sbin/ntpclient -l -h us.pool.ntp.org -c 1 -s &
