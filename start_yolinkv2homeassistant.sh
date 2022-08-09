#!/bin/bash

DEBUG=1

FLOCK=/usr/bin/flock
LOCK_FILE=/tmp/yolinkv2ha.lockfile
FLOCK_OPTS="-n"

YOLINK_PATH=$HOME/YoLinkAPI_V2/src
YOLINK_FILE=yolinkv2homeassistant.py
YOLINK_DFILE=yolink_data.local.json

YOLINK_SCRIPT=$YOLINK_PATH/$YOLINK_FILE
YOLINK_CONF=$YOLINK_PATH/$YOLINK_DFILE

if [[ $DEBUG -eq 1 ]]; then
    YOLINK_ARGS="--config ${YOLINK_CONF} --debug"
else
    YOLINK_ARGS="--config ${YOLINK_CONF}"
fi

$FLOCK $FLOCK_OPTS $LOCK_FILE $YOLINK_SCRIPT $YOLINK_ARGS
