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
├── 쉽게 실행하는 방법
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
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기

## II . Kibana 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기

## II . Elasticsearch 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기

## II . Redis 빌드 및 배포
### 1. 환경변수 형태
### 2. 빌드하기
### 3. 배포하기
1. sudo mkdir redis
2. docker run --name redis -p 6379:6379 -v /home/ubuntu/redis:/data -v /home/ubuntu/redis/redis.conf:/usr/local/etc/redis/redis.conf -d redis redis-server /usr/local/etc/redis/redis.conf 

## 공통 환경변수

### Front
```


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
Wadada.sql

### 4. 서비스 이용 방법
서비스를 이용하는 방법은 다음과 같습니다:

# **테스트 케이스**

# 서비스 이용 방법 안내서

# 앱 사용 가이드

## 1. 앱 시작 및 카카오 로그인

- **1.1** '카카오 로그인'을 클릭합니다.
- **1.2** 카카오 계정 로그인 화면으로 이동한 뒤, 계정 정보를 입력하여 로그인을 완료합니다.
- **1.3** 로그인이 성공하면 자동으로 앱의 메인 페이지로 이동합니다.
- **1.4** 도움말 화면이 빠르게 표시됩니다.

## 2. 프로필 생성 및 선택

- **2.1** 프로필 선택 화면에서 '프로필 추가'를 클릭합니다.
- **2.2** 이름, 닉네임, 생일, 성별을 입력하고 '프로필 생성'을 클릭하여 프로필을 생성합니다.
- **2.3** 프로필이 성공적으로 생성된 후, 해당 프로필을 삭제합니다.
- **2.4** 프로필 리스트 페이지에서 게임을 진행할 프로필(김싸피)을 선택합니다.
- **2.5** 프로필을 선택한 후, 퀴즈 메인 페이지로 이동합니다.

## 3. 찰칵 퀴즈 진행

- **3.1** 메인 페이지에서 "찰칵 퀴즈"를 선택합니다.
- **3.2** 카테고리 선택 화면에서 "SSAFY"를 선택합니다.
- **3.3** 순서대로 브로콜리(O), 의자(O), 강아지(X), 노트북(O), 리모컨(O)을 진행합니다.
- **3.4** 점수를 확인합니다. (80점)
- **3.5** 확인 후 메인 페이지로 돌아갑니다.

## 4. 딸깍 퀴즈 진행

- **4.1** 메인 페이지에서 "딸깍 퀴즈"를 선택합니다.
- **4.2** 카테고리 선택 화면에서 "SSAFY"를 선택합니다.
- **4.3** 순서대로 브로콜리(O), 의자(O), 강아지(O), 노트북(O), 리모컨(O)을 진행합니다.
- **4.4** 문제의 정답을 확인한 뒤, '다음으로' 버튼을 눌러 이동합니다.
- **4.5** 점수를 확인합니다. (100점) 축하 메시지도 확인합니다.
- **4.6** 확인 후 메인 페이지로 돌아갑니다.

## 5. 다시 풀기

- **5.1** 메인 페이지에서 "다시 풀기"를 선택합니다.
- **5.2** 날짜와 퀴즈 모드에 일치하는 내용을 표시합니다.
- **5.3** 메인 페이지로 다시 돌아갑니다.

## 6. 마이페이지

- **6.1** 우측 상단에 위치한 프로필 이미지 버튼을 눌러 "마이페이지"로 이동합니다.
- **6.2** 더미 데이터를 사용하여 달력에 푼 날짜가 3일로 표시됩니다. (4/1, 4/2, 4/4)
- **6.3** 오늘이 아닌 이전 날짜를 달력에서 선택하여, 우측 하단에 상세 문제 기록을 확인합니다.
- **6.4** '프로필 수정하기'를 통해 닉네임과 이름을 수정한 후 완료합니다.
- **6.5** 변경된 프로필 정보를 확인합니다.

