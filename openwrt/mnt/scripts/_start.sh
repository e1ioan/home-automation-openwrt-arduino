#!/opt/bin/bash

sleep 15
/mnt/scripts/_speed.sh &
/mnt/scripts/_readserial.sh &
/mnt/scripts/_writeserial.sh &
