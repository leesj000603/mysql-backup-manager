#!/bin/bash

# MySQL 컨테이너 이름
CONTAINER_NAME="mysql_database"  # 실제 컨테이너 이름
# MySQL 사용자 이름
MYSQL_USER="root"  # 사용자 이름
# MySQL 비밀번호
MYSQL_PASSWORD="root"  # 비밀번호
# 데이터베이스 이름
DATABASE_NAME="database1"  # 데이터베이스 이름
# SQL 명령어 (여기서 데이터 삽입)
SQL_COMMAND="INSERT INTO table1 (column1, column2) VALUES ('value1', 'value2');"  # 삽입할 데이터로 변경하세요

# MySQL에 데이터 삽입
docker exec -i "$CONTAINER_NAME" mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$DATABASE_NAME" -e "$SQL_COMMAND"

echo "데이터가 성공적으로 삽입되었습니다."
