#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

REPOSITORY=/home/ec2-user/app/step3
PROJECT_NAME=spring-boot-gradle-test

echo "> Build 파일 복사"
cp $REPOSITORY/zip/*.jar $REPOSITORY/

echo "> 새 애플리케이션 배포"
JAR_NAME=$(ls -tr $REPOSITORY/*.jar | tail -n 1)

echo "> JAR Name: $JAR_NAME"
echo "> $JAR_NAME 에 실행권한 추가"
chmod +x $JAR_NAME

# nohup 실행 시 CodeDeploy는 무한 대기하므로 nohup.out 파일을 표준 입출력용으로 별도로 사용
# 이렇게 하지 않으면 nohup.out 파일이 생기지 않고, CodeDeploy 로그에 표준 입출력이 출력됨
# nohup이 끝나기 전까지 CodeDeploy도 끝나지 않으므로 반드시 아래와 같이 작성할 것
echo "> $JAR_NAME 실행"
IDLE_PROFILE=$(find_idle_profile)

# step2의 deploy.sh와 비슷하지만
# classpath:/application-$IDLE_PROFILE.properties 와
# -Dspring.profiles.active=$IDLE_PROFILE $JAR_NAME 가 다름 (real -> $IDLE_PROFILE)
echo "> $JAR_NAME 를 profile=$IDLE_PROFILE 로 실행합니다."
nohup java -jar -Dspring.config.location=classpath:/application.properties,\
classpath:/application-$IDLE_PROFILE.properties,\
/home/ec2-user/app/application-oauth.properties,\
/home/ec2-user/app/application-real-db.properties \
-Dspring.profiles.active=$IDLE_PROFILE \
$JAR_NAME > $REPOSITORY/nohup.out 2>&1 &