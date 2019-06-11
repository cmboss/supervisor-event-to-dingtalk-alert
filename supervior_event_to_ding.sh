#!/bin/bash

# 正式URL       'https://oapi.dingtalk.com/robot/send?access_token=e7b8419c488934cdd6b81f112a'
# 测试URL       'https://oapi.dingtalk.com/robot/send?access_token=e7b8419c488934cdd6b81f112a'

LOG_DIR=/data/logs/supervisor
LOG_FILENAME=supervior_all_alert_to_ding.log
HTTP_HEADER="Content-Type: application/json"
DING_HOOK_URL='your dingding hook url'


test -d ${LOG_DIR} || mkdir -p ${LOG_DIR}

echo  "READY"

while read line
do
	ALERT_TIME=$(date '+%Y-%m-%d %H:%M:%S')
	echo -e "\033[31m[ ${ALERT_TIME} -- HEAD: ${line} ]\033[0m" >> ${LOG_DIR}/${LOG_FILENAME}
        body_length=$(echo $line | awk -F'len:' '{print $2}' | awk '{print $1}')
        read -n ${body_length} body_line
	echo -e "\033[31m[ ${ALERT_TIME} -- BODY: ${body_line} ]\033[0m" >> ${LOG_DIR}/${LOG_FILENAME}
        alert_info="${line} ${body_line}"
        echo  "RESULT 2"
        echo  "OKREADY"
	alert_name=$(echo $alert_info | awk -F'processname:' '{print $2}' | awk '{print $1}')
	alert_type=$(echo $alert_info | awk -F'eventname:' '{print $2}' | awk '{print $1}')
	alert_summary=$(echo $alert_info | awk -F'expected:' '{print $2}' | awk '{print $1}')
	alert_host=$(hostname ;hostname -I | awk '{print $1}' )
	alert_details=${body_line}
	if [[  "${alert_summary}" == "0" ]];then
	
		alert_summary="${ALERT_TIME} Online services ${alert_name} Abnormal stop service..."
	else
		alert_summary="${ALERT_TIME} Online services ${alert_name} Stop service without exception..."
	fi
	curl ${DING_HOOK_URL} -H "${HTTP_HEADER}" -d "{ \"msgtype\": \"markdown\", \"markdown\": { \"title\": \"Supervior alert\", \"text\": '![](https://your-url.com/your.png)\n ### The alert of service: ${alert_name}\n ### The  alert types: ${alert_type}\n ### The  alert host: ${alert_host}\n ### The  alert summary:\n ${alert_summary} \n ### Details of the  alert:\n ${alert_details}\n ### [Click on the details]( @+8613888888888)' }, \"at\": { \"atMobiles\": [ \"+8613888888888\" ], \"isAtAll\": false } }" >>  ${LOG_DIR}/${LOG_FILENAME}
	[[ $? == 0 ]] &&  echo " ---> dingding Hook Send  success..." >> ${LOG_DIR}/${LOG_FILENAME}
	
done

