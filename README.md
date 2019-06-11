# supervisor alert  to  dingding  shell 
supervisor alert to dingding  
supervisor 钉钉告警插件，捕获托管的服务的异常退出，然后将信息发送给钉钉；

注：实现了supervisor托管的服务异常退出后，将告警通过钉钉钩子发送到钉钉的功能，当然可以调用supervisor提供的几乎所有事件。本代码只是实现功能，对于代码的健壮性有待优化；


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
