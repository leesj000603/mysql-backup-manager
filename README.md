# 📦 mysql-backup-manager

## 🎯 목표
- docker volume을 사용하여 컨테이너 독립적인 데이터 저장과 신속한 복원
- 주기적으로 backup 파일을 저장하여 안정성 보장 (현재는 호스트에 저장하고 있으나, 클라우드 스토리지와 같은 원격 저장소에 저장)

## 📌 필요성

1. **데이터 안정성 확보**:  
   데이터베이스는 애플리케이션의 핵심 자산이다. 데이터 손실이나 손상으로 인한 비즈니스 중단을 방지하기 위해 안정적인 데이터 저장 및 백업 전략은 매우 중요하다. 이 방식은 Docker 볼륨과 주기적인 백업을 통해 데이터의 안정성을 보장한다.

2. **빠른 복구 능력**:  
   시스템 장애나 데이터 손실이 발생했을 때, 신속하게 데이터를 복구할 수 있는 기능은 매우 중요하다. 볼륨과 백업 파일을 사용하여 데이터베이스를 즉시 복원할 수 있는 체계를 마련하여 서비스 중단 시간을 최소화한다.

3. **효율적인 리소스 관리**:  
   Docker를 이용한 컨테이너 환경에서 볼륨을 사용하면 데이터 저장과 관리가 간편하다. 이를 통해 시스템 리소스를 보다 효율적으로 사용할 수 있으며 데이터베이스 관리가 용이하다.

4. **주기적 데이터 보호**:  
   Cron을 활용한 주기적인 백업 설정은 데이터를 정기적으로 보호할 수 있도록 한다. 사용자가 설정한 주기에 따라 데이터베이스를 자동으로 백업하여 데이터 손실의 위험을 최소화한다.

5. **원격 저장소 연계 가능성**:  
   현재 호스트에 백업 파일을 저장하고 있지만, 클라우드 스토리지와 같은 원격 저장소에 저장함으로써 데이터의 안전성을 더욱 높일 수 있다. 이는 host의 저장소에 문제가 생겼을 때 데이터베이스를 안정적으로 복구 할 수 있다.

6. **비즈니스 연속성 보장**:  
   안정적이고 신속한 데이터 관리 및 백업 체계를 갖추는 것은 비즈니스의 연속성을 보장한다. 데이터 관리에 대한 확실한 전략이 있으면 고객의 신뢰를 얻고 서비스 품질을 유지하는 데 기여한다.

  
## 🔧 설정

### Docker Compose 설정
```yaml
version: '3.8'

services:
  db1:
    image: mysql:latest
    container_name: mysql_database
    environment:
      MYSQL_ROOT_PASSWORD: root
      MYSQL_DATABASE: database1
    volumes:
      - mysql_data:/var/lib/mysql

volumes:
  mysql_data:  # DB가 사용할 볼륨
```

### 데이터 삽입 스크립트
```bash
#!/bin/bash

# MySQL 컨테이너 이름
CONTAINER_NAME="mysql_database"  # 실제 컨테이너 이름
# MySQL 사용자 이름
MYSQL_USER="root"  # 사용자 이름
# MySQL 비밀번호
MYSQL_PASSWORD="root"  # 비밀번호
# 데이터베이스 이름
DATABASE_NAME="database1"  # 데이터베이스 이름
# SQL 명령어 (데이터 삽입)
SQL_COMMAND="INSERT INTO your_table_name (column1, column2) VALUES ('value1', 'value2');"

# MySQL에 데이터 삽입
docker exec -i "$CONTAINER_NAME" mysql -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$DATABASE_NAME" -e "$SQL_COMMAND"

echo "데이터가 성공적으로 삽입되었습니다."
```

### 테이블 생성
```sql
CREATE TABLE table1 ( column1 VARCHAR(255), column2 VARCHAR(255) );
```

### 데이터 확인
```sql
mysql> select * from table1;
+---------+---------+
| column1 | column2 |
+---------+---------+
| value1  | value2  |
+---------+---------+
```

## 🚀 컨테이너 삭제 및 재생성
```bash
docker-compose down
docker-compose up
```

### 재생성 후 데이터 확인
```sql
mysql> select * from table1;
+---------+---------+
| column1 | column2 |
+---------+---------+
| value1  | value2  |
+---------+---------+
```
- 이를 통해 컨테이너가 삭제되고 다시 재생성 되어도 데이터베이스의 data가 보존됨을 알 수 있다.

## 💾 주기적인 데이터 백업
```bash
#!/bin/bash
current_date=$(date +"%Y-%m-%d_%H-%M-%S")

# MySQL 데이터베이스를 호스트에 백업
docker exec mysql_database sh -c "tar czf - /var/lib/mysql" > path/mysql_backup_$current_date.tar.gz
```

## 📅 Cron 설정 (오후 6시마다 백업)
```bash
0 18 * * * /home/username/mysql-backup-manager/copyVolume.sh
```

## 📂 파일 구조
```
.
├── addData.sh
├── backup
│   ├── mysql_backup_2024-09-27_15-24-01.tar.gz
│   ├── mysql_backup_2024-09-27_15-25-01.tar.gz
│   ├── mysql_backup_2024-09-27_15-26-01.tar.gz
│   ├── mysql_backup_2024-09-27_15-27-01.tar.gz
│   └── mysql_backup_2024-09-27_15-28-01.tar.gz
├── copyVolume.sh
├── cron.log
└── docker-compose.yml
```
