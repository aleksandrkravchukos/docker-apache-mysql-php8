#!/bin/bash

#export PATH="$PATH:/usr/local/lib/node_modules/pm2/bin"
#pm2 start public/server.js

source /etc/apache2/envvars
#tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND
