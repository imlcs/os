- alertmanager.yml: alertmanager 进程配置文件示例
- down_rules.yml: 报警条件示例
- prometheus.yml: prometheus server 进程配置文件示例
- 软件下载地址: https://prometheus.io/download/
#### 进程启动命令
```
# alertmanager 启动：
alertmanager --config.file=alertmanager.yml

#prometheus server 启动
prometheus --config.file=prometheus.yml
```

#### prometheus-webhook-dingtalk 配置
- 插件仓库地址: https://github.com/timonwong/prometheus-webhook-dingtalk

```
# 安装 go 环境
yum install golang -y

# 编译文件
cd /root/go/src/github.com/timonwong/
git clone https://github.com/timonwong/prometheus-webhook-dingtalk.git
cd prometheus-webhook-dingtalk && make

# 启动 prometheus-webhook-dingtalk
# dev 为 alertmanager 配置文件中 http://localhost:8060/dingtalk/dev/send 倒数第二个单词
./prometheus-webhook-dingtalk --ding.profile="dev=https://oapi.dingtalk.com/robot/send?access_token=xxx"
```
