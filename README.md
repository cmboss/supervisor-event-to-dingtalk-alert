# supervisor
supervisor alert to dingding  
supervisor 钉钉告警插件，捕获托管的服务的异常退出，然后将信息发送给钉钉；


1、在supervisor的配置文件添加事件监控项；

[eventlistener:all_alert_to_ding]
command=sh -c /opt/scripts/supervior_alert_to_ding.sh
events=PROCESS_STATE_EXITED
user=root
autostart=true
;autorestart=true
stderr_logfile=/tmp/supervisor_error.log
stdout_logfile=/tmp/supervisor_app_stdout.log

2、把shell脚本插件放到你认为合适的地方，注意配置文件里的shell脚本路径；


3、 测试 
