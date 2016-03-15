#/bin/sh
sleep 10
cd /www
ln -s /dev/v4l/video0 /dev/video0 # create /dev/video0
spcacat -d /dev/video0 -g -f jpg -p 3000 -o > /dev/zero # take a picture every 3 sec
