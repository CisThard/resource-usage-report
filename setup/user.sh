#!/usr/bin/env bash

# root 권한 확인
# 이미 유저가 존재하는지 확인 -> 필수. cron.sh에서 sourcr로 이 파일 부르면 이미 존재하는 계정이라고 계속 출력됨
# 아래 생성한 계정 sudo 권한 제거
# 홈 디렉토리 권한 정리
# 기본 디렉토리 구조 생성
# 디렉토리 권한 명시
# 요약 출력

MONITOR_USER="monitoring"
MONITOR_HOME="/home/${MONITOR_USER}"
MONITOR_SHELL="/bin/bash"

useradd \
	--create-home \
	--home-dir "${MONITOR_HOME}" \
	--shell "${MONITOR_SHELL}" \
	--comment "System resource monitoring user" \
	"${MONITOR_USER}"	
