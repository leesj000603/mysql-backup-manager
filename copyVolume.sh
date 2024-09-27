#!/bin/bash
current_date=$(date +"%Y-%m-%d_%H-%M-%S")

# MySQL 데이터베이스를 호스트에 백업
docker exec mysql_database sh -c "tar czf - /var/lib/mysql" > /home/username/mysql-backup-manager/backup/mysql_backup_$current_date.tar.gz
