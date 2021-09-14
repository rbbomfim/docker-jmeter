#!/bin/bash
#
# Test the JMeter Docker image using a trivial test plan.

# Example for using User Defined Variables with JMeter
# These will be substituted in JMX test script
# See also: http://stackoverflow.com/questions/14317715/jmeter-changing-user-defined-variables-from-command-line
export TARGET_HOST="www.map5.nl"
export TARGET_PORT="80"
export TARGET_PATH="/kaarten.html"
export TARGET_KEYWORD="Kaartdiensten"

MY_SCRIPT="JMETER"
DATETIME="$(date +%F)"
THREAD=10
THREAD_START=5
THREAD_NEXT=5
RAMPUP_TIME=60
HOLD_TIME=600
THREAD_RAMPDOWN=5
RAMPDOWN_TIME=5
JMX="Templete_Jmeter"
PROJETO="App"
CICLO="Teste"

# Reporting dir: start fresh
DIR="$(pwd)/output/$DATETIME"
rm -rf ${DIR} > /dev/null 2>&1
mkdir -p ${R_DIR}

/bin/rm -f ${T_DIR}/test-plan.jtl ${T_DIR}/jmeter.log  > /dev/null 2>&1

./run.sh -Dlog_level.jmeter=DEBUG \
	-JTARGET_HOST=${TARGET_HOST} -JTARGET_PORT=${TARGET_PORT} \
	-JTARGET_PATH=${TARGET_PATH} -JTARGET_KEYWORD=${TARGET_KEYWORD} \
	-Jthreads=$THREAD \
	-Jthreads_start=$THREAD_START \
	-Jthreads_next=$THREAD_NEXT \
	-Jrampup_time=$HOLD_TIME \
	-Jhold_time=$HOLD_TIME \
	-Jthreads_rampdown=$THREAD_RAMPDOWN \
	-Jrampdown_time=$RAMPDOWN_TIME \
	-f -n -t ./$JMX.jmx -l $DIR/report_$PROJETO_$CICLO_DATETIME.csv -j $DIR/jmeter.log \
	-e -o $DIR/report_$PROJETO_$CICLO_DATETIME

echo "==== jmeter.log ===="
cat $DIR/jmeter.log

echo "==== Raw Test Report ===="
cat $DIR/report_$PROJETO_$CICLO_DATETIME.csv

echo "==== HTML Test Report ===="
echo "See HTML test report in $DIR/report_$PROJETO_$CICLO_DATETIME"
