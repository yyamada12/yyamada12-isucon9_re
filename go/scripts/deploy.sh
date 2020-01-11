#!/bin/sh

set -eux

SCRIPT_DIR=$(dirname "$0")

cd $SCRIPT_DIR

date -R
echo "Started deploying."

# rotate logs
./rotate_log.sh /var/log/nginx/access.log
./rotate_log.sh /var/log/nginx/error.log

./rotate_log.sh /var/log/mysql/mysqld.log
./rotate_log.sh /var/log/mysql/slow.log

# build go app
cd ..
make

# restart services
sudo systemctl restart mysql
sudo systemctl restart isucari.golang.service
sudo systemctl restart nginx

date -R
echo "Finished deploying."
