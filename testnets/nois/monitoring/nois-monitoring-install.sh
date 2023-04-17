#!/bin/bash
installed()
{
  [ -n  "$(ps -A | grep $1)" ]
}

exist()
{
  command -v "$1" >/dev/null 2>&1
}


echo "=================================================="
echo -e '\033[0;35m\033[5m'
echo "                                                                 ";
echo "██       ██████  ██    ██ ██████      ██████  ██████  ███    ███ ";
echo "██      ██  ████ ██    ██ ██   ██    ██      ██    ██ ████  ████ ";
echo "██      ██ ██ ██ ██    ██ ██   ██    ██      ██    ██ ██ ████ ██ ";
echo "██      ████  ██  ██  ██  ██   ██    ██      ██    ██ ██  ██  ██ ";
echo "███████  ██████    ████   ██████  ██  ██████  ██████  ██      ██ ";
echo "                                                                 ";
echo -e "\e[0m"
echo "=================================================="

sleep 2

echo ''
echo -e 'INSTALLING NOIS NODE MONITORING'

sleep 2

if exist curl;
then :
else sudo apt update && sudo apt -y install curl
fi

if exist wget;
then :
else sudo apt update && sudo apt -y install bc 
fi

if exist jq;
then :
else sudo apt update && sudo apt -y install jq
fi

if exist bc;
then :
else sudo apt update && sudo apt -y install bc 
fi

if installed telegraf;
then echo -e '\n\e[42mTelegraf is already installed\e[0m\n';
else 
echo -e '\n\e[42mInstalling telegraf\e[0m\n'

sudo cat <<EOF | sudo tee /etc/apt/sources.list.d/influxdata.list
deb https://repos.influxdata.com/ubuntu bionic stable
EOF

sudo apt update && sudo apt -y install telegraf
sudo systemctl enable --now telegraf
sudo systemctl is-enabled telegraf

# make the telegraf user sudo and adm to be able to execute scripts as nois user
sudo adduser telegraf sudo
sudo adduser telegraf adm
sudo -- bash -c 'echo "telegraf ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
fi


sleep 2

echo ''
echo -e '\e[32mCloning github repo\e[39m'
echo ''

cd $HOME
mkdir nois-monitoring
cd nois-monitoring
wget https://raw.githubusercontent.com/L0vd/Nois/main/Monitoring/monitor.sh

COS_BIN=noisd
COS_BIN_NAME=$(which $COS_BIN)
COS_PORT_RPC=$($COS_BIN config | jq -r .node | cut -d : -f 3)
COS_MONIKER=$(curl -s localhost:$COS_PORT_RPC/status | jq -r '.result.node_info.moniker')
LOGENTRY=nois

PUBLIC_VALIDATOR_KEY=$(jq -r '.result.validator_info.pub_key.value' <<<$(curl -s localhost:$COS_PORT_RPC/status))
COS_VALOPER=$(jq -r '.operator_address' <<<$(${COS_BIN_NAME} q staking validators -o json --limit=3000 --node "tcp://localhost:${COS_PORT_RPC}" \
| jq -r  --arg PUBLIC_VALIDATOR_KEY "$PUBLIC_VALIDATOR_KEY" '.validators[] | select(.consensus_pubkey.key==$PUBLIC_VALIDATOR_KEY)'))

cat > variables.sh <<EOL
#Nois monitoring variables template 
COS_BIN_NAME=$COS_BIN_NAME             # example: /root/go/bin/noisd or /home/user/go/bin/noisd
COS_PORT_RPC=$COS_PORT_RPC         # default: 26657
COS_VALOPER=$COS_VALOPER           # example: noisvaloper1234545636767376535673
LOGENTRY=$LOGENTRY
EOL


chmod +x monitor.sh variables.sh

cat > telegraf_nois.conf <<EOL
# Global Agent Configuration
[agent]
  hostname = "$COS_MONIKER" # set this to a name you want to identify your node in the grafana dashboard
  flush_interval = "15s"
  interval = "15s"
# Input Plugins
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  collect_cpu_time = false
  report_active = false
[[inputs.disk]]
  ignore_fs = ["devtmpfs", "devfs"]
[[inputs.io]]
[[inputs.mem]]
[[inputs.net]]
[[inputs.system]]
[[inputs.swap]]
[[inputs.netstat]]
[[inputs.diskio]]
# Output Plugin InfluxDB
[[outputs.influxdb]]
  database = "noismetricsdb"
  urls = [ "http://95.216.2.219:8086" ] 
  username = "metric" 
  password = "password" 
[[inputs.exec]]
  commands = ["sudo su -c /root/nois-monitoring/monitor.sh -s /bin/bash root"] # change path to your monitor.sh file and username to the one that validator runs at (e.g. root)
  interval = "15s"
  timeout = "5s"
  data_format = "influx"
  data_type = "integer"
EOL

cat > /etc/systemd/system/telegraf_nois.service <<EOL
[Unit]
Description=The plugin-driven server agent for reporting metrics into InfluxDB
Documentation=https://github.com/influxdata/telegraf
After=network.target

[Service]
EnvironmentFile=-/etc/default/telegraf
User=telegraf
ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf_nois.conf -config-directory /etc/telegraf/telegraf.d $TELEGRAF_OPTS
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group

[Install]
WantedBy=multi-user.target
EOL

sudo mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.orig
sudo mv telegraf_nois.conf /etc/telegraf/telegraf_nois.conf


sudo systemctl daemon-reload
sudo systemctl enable telegraf_nois
sudo systemctl restart telegraf_nois
sleep 4

#check telegraf
echo ''
echo -e '\e[32mChecking telegraf status\e[39m' && sleep 4
echo ''
if [[ `sudo systemctl status telegraf_nois | grep active` =~ "running" ]]; then
  echo -e '\e[7mTelegraf is installed and works!\e[0m'
else
  echo -e "Your telegraf \e[31mwas not installed correctly\e[39m, please reinstall."
  echo -e "You can check telegraf logs by following command \e[7msudo journalctl -u telegraf -f\e[0m"
fi

echo ''
echo -e '\e[7mYour Nois node monitoring is installed!\e[0m'
echo ''
echo -e "Your node info:"
echo ''
echo -e "Node moniker: $COS_MONIKER"
echo -e "Node operator address: $COS_VALOPER"
echo -e "Node RPC port: $COS_PORT_RPC"
echo -e ''
echo -e 'Check telegraf logs: \e[7msudo journalctl -u telegraf_nois -f\e[0m'
