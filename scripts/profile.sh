#!/usr/bin/env bash

# 쉬고 있는 profile 찾기: real1이 사용 중이면 real2가 쉬고 있고, 반대면 real1이 쉬고 있음

function find_idle_profile() {
    # 현재 엔진엑스가 바라보고 있는 스프링 부트가 정상적으로 수행 중인지 확인
    RESPONSE_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost/profile)

    # 응답값을 HttpStatus로 받는데, 오류가 발생한다면 400 ~ 503 사이로 발생하므로
    # 400 이상은 모두 예외로 보고 real2를 현재 profile로 사용
    if [ ${RESPONSE_CODE} -ge 400 ]
    then
        CURRENT_PROFILE=real2
    else
        CURRENT_PROFILE=$(curl -s http://localhost/profile)
    fi

    # IDLE_PROFILE: 엔진엑스와 연결되지 않은 profile
    # 스프링 부트 프로젝트를 이 profile로 연결하기 위해 반환
    if [ ${CURRENT_PROFILE} == real1 ]
    then
        IDLE_PROFILE=real2
    else
        IDLE_PROFILE=real1
    fi

    # bash 스크립트는 값을 반환하는 기능이 없으므로
    # 제일 마지막 줄에 echo로 결과를 출력 후 클라이언트에서 그 값을 잡아서 사용
    # 이럴 경우에는 중간에 echo를 사용하면 안 됨
    echo "${IDLE_PROFILE}"
}

# 쉬고 있는 profile의 포트 찾기
function find_idle_port() {
    IDLE_PROFILE=$(find_idle_profile)

    if [ ${IDLE_PROFILE} == real1 ]
    then
        echo "8081"
    else
        echo "8082"
    fi
}