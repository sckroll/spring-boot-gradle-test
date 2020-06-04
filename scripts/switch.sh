#!/usr/bin/env bash

ABSPATH=$(readlink -f $0)
ABSDIR=$(dirname $ABSPATH)
source ${ABSDIR}/profile.sh

function switch_proxy() {
    IDLE_PORT=$(find_idle_port)

    echo "> 전환할 포트: $IDLE_PORT"
    echo "> 포트 전환"

    # 하나의 문장을 만들어 파이프라인으로 넘겨주기 위해 echo 사용
    # 엔진엑스가 변경할 프록시 주소 생성
    # 사용하지 않으면 $service_url을 그대로 인식하지 못하고 변수를 찾게 됨
    # 파이프라인 이후의 명령어는 앞에서 넘겨준 문장을 service-url.inc에 덮어쓴다는 의미
    echo "set \$service_url http://127.0.0.1:${IDLE_PORT};" | sudo tee /etc/nginx/conf.d/service-url.inc

    # 엔진엑스의 설정을 다시 불러옴 (restart와는 다름!!)
    # reload는 끊김 없이 다시 불러올 수 있음 -> 여기서는 외부의 설정 파일인 service-url을 다시 불러오므로 reload 사용
    # restart는 잠시 끊기는 현상이 있음 -> 중요한 설정의 반영이 필요할 때에는 restart를 사용해야 함
    echo "> 엔진엑스 Reload"
    sudo service nginx reload
}