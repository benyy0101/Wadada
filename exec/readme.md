```bash
WADADA 프로젝트
├── I. GitLab 소스 클론 이후 빌드 및 배포할 수 있도록 정리한 문서
│   ├── 1. 프로젝트 개요
│   ├── 2. 프로젝트 사용 도구
│   └── 3. 개발환경
│       ├── [BackEnd]
│       ├── [FrontEnd]
│       ├── [DataBase]
│       └── [Infra]
├── EC2 Server 설정사항
├── 각각 실행하는 방법
│   ├── II. Member 빌드 및 배포
│   ├── II. Single 빌드 및 배포
│   ├── II. Multi 빌드 및 배포
│   ├── II. Marathon 서버 빌드 및 배포
│   ├── II. MySQL 빌드 및 배포
│   ├── II. Redis 빌드 및 배포
│   ├── II. ElasticSearch 빌드 및 배포
│   ├── II. RabbitMQ 빌드 및 배포
│   ├── II. FrontEnd 빌드 및 배포
│   ├── II. Jenkins 빌드 및 배포
│   └── II. nginx 빌드 및 배포
├── II. 프로젝트에서 사용하는 외부 서비스 정보를 정리한 문서
└── III. DB 덤프 파일 최신본
    └── 4. 서비스 이용 방법
        ├── 1. 로그인 과정
        ├── 2. 싱글 게임 이용
        ├── 3. 멀티 게임 이용
        ├── 4. 마라톤 게임 이용
        └── 5. 마이페이지 이용
```
# 목차
## I. Gitlab 소스 클론 이후 빌드 및 배포할 수 있도록 정리한 문서
### 1. 프로젝트 개요    
Wadada 프로젝트는 단순한 런닝 앱을 넘어서는 새로운 경험을 제공합니다. 우리의 앱은 싱글모드, 멀티모드, 마라톤모드 등 다양한 러닝 모드를 제공하여 사용자가 자신에게 맞는 달리기 환경을 선택할 수 있도록 합니다. 특히, Wadada는 다른 런닝 앱과 차별화된 경쟁 시스템을 도입하여 사용자들이 다른 사람들과 경쟁함으로써 더 높은 동기를 부여받고 신체 능력을 향상시킬 수 있도록 설계되었습니다. 이러한 경쟁 시스템은 사용자들에게 더욱 적극적인 참여를 유도하고, 운동을 더욱 재미있고 도전적인 활동으로 만들어줍니다.
### 2. 프로젝트 사용 도구
- 이슈 관리 : JIRA
- 형상 관리 : Gitlab
- API 테스트 : PostMan,apic - The Complete API Solution
- 커뮤니케이션 : Notion,Mattermost
- 디자인 : Figma
- CI/CD : Jenkins

### 3. 개발환경
##### [BackEnd]
- Spring Boot : 3.2.5
- Spring Web : 3.2.5
- Spring Data JPA : 3.2.5
- Spring Security : 3.2.5
- JJWT : 0.11.5
- JDK : 17.0.9
- JPA(QueryDsl) : 5.0.0
- RabbitMQ : 5.19.0

![image.png](./image.png)

##### [FrontEnd]
- flutter 3.0
- get: 4.6.6
- geolocator: 11.0.0
- flutter_blue_plus: 1.30.8
- stomp_dart_client:2.0.0
##### [Database]
- logstash: 8.13.0
- kibana: 8.13.0
- elasticsearch: 8.13.0
- mysql: 8.0.36
- redis: 7.2.
[- ImageDB : S3]
##### [Infra]
- SERVER : AWS EC2 Ubuntu 20.04.6 LTS
- Docker : 25.0.4
- ProxyWebServer : Nginx/1.25.4
##### [watch]
- watch_connectivity: 0.2.0
- is_wear: 0.0.1+1
- permission_handler: 11.3.1
- play-services-wearable:18.0.0

##### [최종 배포 환경]
- SERVER : AWS EC2 
  - Docker  
    - ProxyCloudGateway : Nginx
        - Front (Flutter)
        - Member (SpringBoot)
        - Single (SpringBoot)
        - Multi (SpringBoot)
        - Marathon (SpringBoot)
        - RabbitMQ
        - Jenkins

- SERVER : AWS Lightsail 
    - DB : MYSQL
    - MemoryDB : Redis
    - ElasticSearch
    - Kibana
    - logstash

- SERVER : S3

## EC2 Server 설정사항
- AWS (서비스 서버)
    - 22,80,443,5432,9400,15672,15692,16000
- AWS (Database 서버)
    - 22,80,3306,5601,6379,9200
- SSL 인증서 발급 
(참고 사이트 https://velog.io/@pdohyung/EC2%EC%97%90%EC%84%9C-%EB%8F%84%EB%A9%94%EC%9D%B8%EC%97%90-NGINX-HTTPS-%EC%A0%81%EC%9A%A9)
- "docker network create deploy" 도커 공유네트워크 생성

## 쉽게 실행하는 방법
[프론트]

[서버]
1. master Branch 클론 후 폴더로 이동
2. docker compose down || true
3. docker compose up --build -d

## 각각 실행 하는 방법

# ※주의사항※
-  jar파일이 없을 시 jar파일 생성후 빌드
- 해당 폴더에 resources파일에 SSL 통신을 하기위한 Cert파일이 존재
- 해당파일을 통신할 사이트 crt로 바꿔야함
- Dockerfile의 해당 파일명도 바꿔줘야 함
- txt로 끝나는파일 -> conf로 변경


# AWS 서비스서버

## II . Member 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
1. chmod +x ./gradlew
2. ./gradlew build
### 3. 배포하기
1. docker compose up --build -d

## II . Single 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
1. chmod +x ./gradlew
2. ./gradlew build
### 3. 배포하기
1. docker compose up --build -d

## II . Multi 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
1. chmod +x ./gradlew
2. ./gradlew build
### 3. 배포하기
1. docker compose up --build -d

## II . Marathon 서버 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
1. chmod +x ./gradlew
2. ./gradlew build
### 3. 배포하기
1. docker compose up --build -d

## II . Marathon 서버 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기
1. docker run -d -p 15672:15672 -p 5672:5672 --name rabbitmq rabbitmq
2. docker exec rabbitmq rabbitmq-plugins enable rabbitmq_management
3. guest/guest 접속후 권한 변경


## II . Jenkins 빌드 및 배포
### 1. 환경변수 형태
- sudo mkdir lastjenkins
### 2. 빌드하기
### 3. 배포하기
- docker run  --network deploy --name Jenkins -e JENKINS_OPTS="--prefix=/Jenkins" -v /var/run/docker.sock:/var/run/docker.sock -u root -v /home/ubuntu/lastjenkins:/var/jenkins_home jenkins/jenkins:lts


## II . nginx 빌드 및 배포
### 1. 환경변수 형태
- sudo mkdir nginx
- nginx.conf파일 하단에 추가
```
stream {
    server {
        listen 5432 udp;
        proxy_pass udp:5432;
        proxy_bind $remote_addr transparent;
    }
}
```

### 2. 빌드하기
- cd S10P12A207/nginx
- docker build -t proxynginx .
### 3. 배포하기
- docker run -p 80:80 -p 443:443 --name proxynginx -d --network deploy -v /home/ubuntu/nginx/default.conf:/etc/nginx/conf.d/default.conf -v /etc/letsencrypt/archive/j10a102.p.ssafy.io:/etc/nginx/ssl/ proxynginx


# AWS Database 서버

## II . MySQL 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기
1. sudo mkdir mysql
2. docker run -p 3306:3306 -v /home/ubuntu/mysql:/etc/mysql/conf.d -e MYSQL_ROOT_PASSWORD='ssafy102!' --name mysql mysql:latest

## II . logstash 빌드 및 배포

* logstash.yml

    ```
    http.host: "0.0.0.0"
    xpack.monitoring.elasticsearch.hosts: [ "엘라스틱서치 경로" ]
    xpack.monitoring.enabled: true
    xpack.monitoring.elasticsearch.username: elastic 유저명
    xpack.monitoring.elasticsearch.password: elastic 비밀번호

    ```

* logstash.conf

    ```

    input {
        jdbc {
            jdbc_driver_library => "/usr/share/logstash/driver/mysql-connector-java-8.0.26.jar"
            jdbc_driver_class => "com.mysql.cj.jdbc.Driver"
            jdbc_connection_string => "jdbc:mysql://{host_ip}:{port}/{db명}"
            jdbc_user => "{db_id}"
            jdbc_password => "{db_pw}"
            jdbc_paging_enabled => true
            jdbc_page_size => "50000"
            tracking_column => "updated_at"
            statement => "SELECT * FROM wadada.room WHERE updated_at > :sql_last_value ORDER BY updated_at"
            schedule => "* * * * *"
            use_column_value => true
            tracking_column_type => "timestamp"
            clean_run => true
        }
    }
    output{
        elasticsearch {
            hosts => ["엘라스틱주소"]
            user => "{es_id}"
            ssl => false
            password => "{es_pw}"
            document_id => "%{room_seq}"
            index => "room"
        }
    }

    ```

* pipelines.yml

    ```
    - pipeline.id: main
    path.config: "/usr/share/logstash/config/logstash.conf"

    ```

### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기

1. wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.26.zip

2. unzip mysql-connector-java-8.0.26.zip

3. docker run --name logstash   -v /var/lib/docker/volumes/logstash/_data/config/logstash.conf:/usr/share/logstash/config/logstash.conf   -v /var/lib/docker/volumes/logstash/_data/config/mysql-connector-java-8.0.26.jar:/usr/share/logstash/driver/mysql-connector-java-8.0.26.jar   -v /var/lib/docker/volumes/logstash/_data/config/logstash.yml:/usr/share/logstash/config/logstash.yml  -d logstash:8.13.0

## II . Kibana 빌드 및 배포
### 1. 환경변수 형태

* kibana.yml

    ```
    # Default Kibana configuration for docker target
    server.host: "0.0.0.0"
    server.shutdownTimeout: "5s"
    elasticsearch.hosts: [ "엘라스틱서치 경로" ]
    monitoring.ui.container.elasticsearch.enabled: true
    elasticsearch.serviceAccountToken: "엘라스틱서치에서 발급받은 토큰"

    ```

### 2. 빌드하기
### 3. 배포하기

docker run -d --link elastic:elasticsearch -p 5601:5601 -v /var/lib/docker/volumes/kibana/_data/config/kibana.yml:/usr/share/kibana/config/kibana.yml --name kibana kibana:8.13.0

## II . Elasticsearch 빌드 및 배포
### 1. 환경변수 형태

* elastic.yml

    ```
    # Enable security features
    xpack.security.enabled: true

    xpack.security.enrollment.enabled: true

    # Enable encryption for HTTP API client connections, such as Kibana, Logstash, and Agents
    xpack.security.http.ssl:
    enabled: false
    keystore.path: certs/http.p12

    # Enable encryption and mutual authentication between cluster nodes
    xpack.security.transport.ssl:
    enabled: false
    verification_mode: certificate
    keystore.path: certs/transport.p12
    truststore.path: certs/transport.p12

    ```

    초기 유저 명 : elastic

    docker exec -it elastic bash

* 비밀번호 변경

    bin/elasticsearch-reset-password -u elastic

* kibana 엑세스 토큰 발급

    bin/elasticsearch-service-tokens create elastic/kibana token-name

### 2. 빌드하기
### 3. 배포하기
docker run -p 9200:9200 -p 9300:9300 -v /var/lib/docker/volumes/elastic/_data/config/elastic.yml:/usr/share/logstash/config/elastic.yml  elastic:/usr/share/elastic -e "discovery.type=single-node" --name elastic elasticsearch:8.13.0

## II . Redis 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기
1. sudo mkdir redis
2. docker run --name redis -p 6379:6379 -v /home/ubuntu/redis:/data -v /home/ubuntu/redis/redis.conf:/usr/local/etc/redis/redis.conf -d redis redis-server /usr/local/etc/redis/redis.conf 

## II . FLUTTER APK 추출


1. android 폴더에서 key 생성(앱 서명)

keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

2. android 폴더 내 keystore 디렉토리 생성 후 key 넣기(앱 서명)

3. keystore에 keystore.password파일 만든 후 비밀번호 입력(앱 서명)

4. .gitignore에  /keystore 추가(앱 서명)

5. app - proguard-rules.pro 파일 생성(앱 권한설정)
    
    ```
    ## Flutter wrapper
    -keep class io.flutter.app.** { *; }
    -keep class io.flutter.plugin.**  { *; }
    -keep class io.flutter.util.**  { *; }
    -keep class io.flutter.view.**  { *; }
    -keep class io.flutter.**  { *; }
    -keep class io.flutter.plugins.**  { *; }
    -keep class com.facebook.** {*;}
    # 기타 필요한 권한 추가
    -dontwarn io.flutter.embedding.**
    ```

6. app - build.gradle에 추가

    ```
    signingConfigs {
            release {
                storeFile file('../keystore/key.jks')
                storePassword file('../keystore/keystore.password').text.trim()
                keyPassword file('../keystore/keystore.password').text.trim()
                keyAlias 'key'
            }
        }

        buildTypes {
            release {
                shrinkResources false   // 난독화 적용 시 true
                minifyEnabled false    //  난독화 적용 시 true
                proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
                // TODO: Add your own signing config for the release build.
                // Signing with the debug keys for now, so `flutter run --release` works.
                signingConfig signingConfigs.release

            }
        }
    ```

7. apk 생성 ——— 경로 /build/app/outputs/apk/release/app-release.apk(APK 추출)

```
flutter build apk --release --target-platform=android-arm64
```

## 공통 환경변수

### Front
```
NATIVE_APP_KEY = 9430c9bd5cf24477bf3ccb0cde068f16
JAVASCRIPT_APP_KEY = 671973e2cb29da502bdead673817f346
SERVER_URL = https://k10a704.p.ssafy.io
MULTI_URL = https://k10a704.p.ssafy.io/Multi/ws
STOMP_URL = https://k10a704.p.ssafy.io/Multi/ws
MARATHON_URL = https://k10a704.p.ssafy.io/Marathon/ws
APP_KEY='f508d67320677608aea64e5d6a9a3005'
```

### BackEnd
```
MYSQL_URL=
MYSQL_USERNAME=
MYSQL_PASSWORD=
REDIS_HOST=
REDIS_PORT=
REDIS_PASSWORD=

ELS_USERNAME=
ELS_PASSWORD=
ELS_URIS=

JWT_KEY=
JWT_ACCESS_VALIDITY_SECONDS=
JWT_REFRESH_VALIDITY_SECONDS=
AES_KEY=

CLIENT_ID=

CLOUD_AWS_CREDENTIALS_ACCESS_KEY=
CLOUD_AWS_CREDENTIALS_SECRET_KEY=
CLOUD_AWS_CREDENTIALS_REGION_STATIC=
CLOUD_AWS_CREDENTIALS_S3_BUCKET=

RABBITMQ_HOST=
RABBITMQ_PORT=
RABBITMQ_USERNAME=
RABBITMQ_PASSWORD=
RABBITMQ_ROUTING_KEY=

RABBITMQ_MARATHON1_ROUTING_KEY=
RABBITMQ_MARATHON2_ROUTING_KEY=
RABBITMQ_MARATHON3_ROUTING_KEY=
```

## 배포 시 특이사항
## DB 주요 계정 및 프로퍼티가 정의된 파일 목록

#### Mysql
아이디 : test01
비밀번호: 1234

#### Redis
비밀번호 : 1234

## II. 프로젝트에서 사용하는 외부 서비스 정보를 정리한 문서
- Kakao Login API
- galaxy watch API

## III. DB 덤프 파일 최신본
wadada_dump.sql

### 4. 서비스 이용 방법
서비스를 이용하는 방법은 다음과 같습니다:

# **테스트 케이스**

# 서비스 이용 방법 안내서

# 앱 사용 가이드

## 1. 앱 시작 및 카카오 로그인

- **1.1** '카카오 로그인'을 클릭합니다.
- **1.2** 카카오 계정 로그인 화면으로 이동한 뒤, 계정 정보를 입력하여 로그인을 완료합니다.
- **1.3** 로그인이 성공하면 자동으로 앱의 메인 페이지로 이동합니다.
- **1.4** 처음 로그인할 시 프로필 생성으로 이동합니다.

## 2. 프로필 생성 및 선택

- **2.1** 프로필 선택 화면에서 '프로필 추가'를 클릭합니다.
- **2.2** 이름, 생일, 성별을 입력하고 '프로필 생성'을 클릭하여 프로필을 생성합니다.
- **2.3** 프로필이 성공적으로 생성된 후 메인페이지로 전환됩니다.

## 3. 싱글 게임 진행

- **3.1** 싱글 페이지에서 "거리 모드", "시간 모드", "챌린지 모드"를 선택할 수 있습니다.
- **3.2** 거리모드는 목표 거리를 설정하며 시간모드는 목표시간을 설정합니다.
- **3.3** 잠시 후 달리기가 시작되며 이동거리, 페이스, 소요시간, 속도, 이동 경로를 확인할 수 있습니다.
- **3.4** 달리기를 마친 후 나의 기록(심박수, 이동거리, 페이스, 소요시간 ,속도, 나의경로)을 그래프로 확인할 수 있습니다.

## 4. 멀티 게임 진행

- **4.1** 멀티 페이지에서 "거리 모드", "시간 모드", "깃발 모드"를 선택할 수 있습니다.
- **4.2** 거리모드는 목표 거리를 설정하며 시간모드는 목표시간을 설정하고, 깃발모드는 목표지점을 설정합니다.
- **4.3** 각각의 모드는 해시태그를 통해 원하는 방을 검색할 수 있으며 참가하고 게임을 시작할 수 있습니다. 
- **4.3** 깃발모드의 경우 목적지 추천 버튼을 통해 목표지점을 선택한 후 게임을 진행합니다.
- **4.4** 잠시 후 달리기가 시작되며 이동거리, 페이스, 소요시간, 속도, 나의 경로를 확인할 수 있습니다.
- **4.5** 달리는 동안 실시간으로 모든 등수를 확인할 수 있습니다.
- **4.6** 달리기를 마친 후 나의 기록(심박수, 이동거리, 페이스, 소요시간 ,속도, 나의경로)을 그래프로 확인할 수 있습니다.

## 5. 마라톤 게임 진행

- **5.1** 마라톤 페이지에서 현재 진행중인 마라톤을 확인하고 마라톤 정보와 참여자를 확인할 수 있습니다.
- **5.2** 참여하기 버튼을 통해 참가할 수 있으며 정해진 시간에 자동으로 시작됩니다.
- **5.3** 잠시 후 달리기가 시작되며 이동거리, 페이스, 소요시간, 속도, 나의 경로를 확인할 수 있습니다.
- **5.4** 달리는 동안 실시간으로 나를 포함한 5명의 등수, 거리를 확인할 수 있습니다.
- **5.5** 달리기를 마친 후 나의 기록(심박수, 이동거리, 페이스, 소요시간 ,속도, 나의경로)을 그래프로 확인할 수 있습니다.

## 6. 마이페이지

- **6.1** 내 정보에서 내 기록과 아바타, 프로필 수정을 진행할 수 있습니다.
- **6.2** 내 기록의 경우 모드 별, 날짜 별로 상세 정보를 확인할 수 있습니다.
- **6.3** 아바타의 경우 나의 레벨과 이미지를 확인할 수 있습니다.
- **6.4** 프로필 수정의 경우 이미지, 닉네임, 성별, 생년월일을 수정할 수 있으며, 로그아웃, 탈퇴하기가 가능합니다.
- **6.5** 변경된 프로필 정보를 확인합니다.

