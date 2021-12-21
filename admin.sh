#!/bin/bash

SERVER="apiserver"
BASE_DIR=$PWD
INTERVAL=2

# 命令行参数，需要手动指定
ARGS=""

function start()
{
	# shellcheck disable=SC2006
	if [ "`pgrep $SERVER -u $UID`" != "" ];then
		echo "$SERVER already running"
		exit 1
	fi

	nohup "$BASE_DIR"/$SERVER "$ARGS"  server &>/dev/null &

	echo "sleeping..." &&  sleep $INTERVAL

	# check status
	# shellcheck disable=SC2006
	if [ "`pgrep $SERVER -u $UID`" == "" ];then
		echo "$SERVER start failed"
		exit 1
	fi
}

function status()
{
	# shellcheck disable=SC2006
	if [ "`pgrep $SERVER -u $UID`" != "" ];then
		echo $SERVER is running
	else
		echo $SERVER is not running
	fi
}

function stop()
{
	# shellcheck disable=SC2006
	if [ "`pgrep $SERVER -u $UID`" != "" ];then
		# shellcheck disable=SC2046
		kill -9 `pgrep $SERVER -u $UID`
	fi

	echo "sleeping..." &&  sleep $INTERVAL

	# shellcheck disable=SC2006
	if [ "`pgrep $SERVER -u $UID`" != "" ];then
		echo "$SERVER stop failed"
		exit 1
	fi
}

case "$1" in
	'start')
	start
	;;
	'stop')
	stop
	;;
	'status')
	status
	;;
	'restart')
	stop && start
	;;
	*)
	echo "usage: $0 {start|stop|restart|status}"
	exit 1
	;;
esac
