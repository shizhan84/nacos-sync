#!/bin/bash

ACTION=$1

cygwin=false
darwin=false
os400=false
case "`uname`" in
CYGWIN*) cygwin=true;;
Darwin*) darwin=true;;
OS400*) os400=true;;
esac
error_exit ()
{
    echo "ERROR: $1 !!"
    exit 1
}

export BASE_DIR=`cd $(dirname $0)/..; pwd`


JAVA_OPT="${JAVA_OPT} -server -Xms512m -Xmx512m "
JAVA_OPT="${JAVA_OPT} -XX:-OmitStackTraceInFastThrow -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=${BASE_DIR}/nacossync_java_heapdump.hprof"
JAVA_OPT="${JAVA_OPT} -XX:-UseLargePages"
JAVA_OPT="${JAVA_OPT} -Dspring.config.location=${BASE_DIR}/conf/application.properties"
JAVA_OPT="${JAVA_OPT} -DnacosSync.home=${BASE_DIR}"


JAVA_OPT="${JAVA_OPT} -jar ${BASE_DIR}/nacosSync-server.jar"
JAVA_OPT="${JAVA_OPT} --logging.config=${BASE_DIR}/conf/logback-spring.xml"

echo "=============BASE_DIR:"$BASE_DIR

if [  ! -d "${BASE_DIR}/logs" ]; then
        mkdir "${BASE_DIR}/logs"
fi


usage(){
    echo "command error"
}

start(){

echo "$JAVA ${JAVA_OPT}" > ${BASE_DIR}/logs/nacossync_start.out 2>&1 &
nohup java ${JAVA_OPT} >> ${BASE_DIR}/logs/nacossync_start.out 2>&1 &
echo "nacossync is starting，you can check the ${BASE_DIR}/logs/nacossync_start.out"

}


case "$ACTION" in
    start)
        start
    ;;
    *)
        usage
    ;;
esac
