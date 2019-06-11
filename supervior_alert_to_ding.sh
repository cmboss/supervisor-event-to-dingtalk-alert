#!/bin/bash

# 正式URL	'https://oapi.dingtalk.com/robot/send?access_token=e7b8419c488934cdd6b345481f112af47c94fc29f0a7474899bc32b1234324324324234234234324f3a48c003c2f'
# 测试URL       'https://oapi.dingtalk.com/robot/send?access_token=e7b8419c488934dgr5cdd6b81f112af47c94fc29f0a7474899bc32b1234234324234324423432f3a48c003c2f'
LOG_DIR=/data/logs/supervisor
LOG_FILENAME=supervior_all_alert_to_ding.log
HTTP_HEADER="Content-Type: application/json"
DING_HOOK_URL='https://oapi.dingtalk.com/robot/send?access_token=dada0742bba6f31b032432653445d49df16099be237a6aa04b4b19b88d6234324324324324324324324324279727285eee61'
DING_HOOK_TEST_URL='https://oapi.dingtalk.com/robot/send?access_token=e7b8419c488934cdd6b8234321f112af423423432423432432424347c94fc29f0a7474899bc32b1f3a48c003c2f'
#DING_TEMPLATE="{ \"msgtype\": \"markdown\", \"markdown\": { \"title\": \"prometheus alert\", \"text\": '![](https://cdnimg.lolseatour.com/warningok.png)\n ### 告警名称: ${alert_name}\n ### 告警类型: ${alert_type}\n ### 告警主机: ${alert_host}\n ### 告警摘要:\nSupervior-alert \n ### 告警详情:\n ${alert_details}\n ### [点击详情]( @18916612261)' }, \"at\": { \"atMobiles\": [ \"18916612261\" ], \"isAtAll\": false } }"

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
	
		alert_summary="${ALERT_TIME} 线上服务 ${alert_name} 异常停止服务..."
	else
		alert_summary="${ALERT_TIME} 线上服务 ${alert_name} 非异常停止服务..."
	fi
	curl ${DING_HOOK_URL} -H "${HTTP_HEADER}" -d "{ \"msgtype\": \"markdown\", \"markdown\": { \"title\": \"Supervior alert\", \"text\": '![](https://cdnimg.lolseatour.com/warningok.png)\n ### 告警服务: ${alert_name}\n ### 告警类型: ${alert_type}\n ### 告警主机: ${alert_host}\n ### 告警摘要:\n ${alert_summary} \n ### 告警详情:\n ${alert_details}\n ### [点击详情]( @18916612261)' }, \"at\": { \"atMobiles\": [ \"18916612261\" ], \"isAtAll\": false } }" >>  ${LOG_DIR}/${LOG_FILENAME}
	[[ $? == 0]] && echo " ---> 钉钉Hook发送成功..." >> ${LOG_DIR}/${LOG_FILENAME}
done

