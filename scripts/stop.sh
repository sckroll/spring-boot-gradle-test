#!/usr/bin/env bash

# 현재 stop.sh가 속해 있는 경로 탐색
# start.sh와 같이 profile.sh의 여러 function을 사용할 수 있게 됨
ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)

# 일종의 import 구문
# 해당 코드로 인해 stop.sh에서도 profile의 여러 function을 사용할 수 있음
source ${ABSDIR}/profile.sh

IDLE_PORT=$(find_idle_port)

echo "> $IDLE_PORT 에서 구동 중인 애플리케이션 pid 확인"
IDLE_PID=$(lsof -ti tcp:${IDLE_PORT})

if [ -z ${IDLE_PID} ]
then
    echo "> 현재 구동 중인 애플리케이션이 없으므로 종료하지 않습니다."
else
    echo "> kill -15 $IDLE_PID"
    kill -15 ${IDLE_PID}
    sleep 5
fi