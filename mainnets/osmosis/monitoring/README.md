# Monitoring

Advantages  of using our free service:
* Our monitoring service is working on dedicated server (24/7 online)
* No need to install database  (InfluxDB)
* No need to install and configure  Grafana Dashboard
* On Grafana dashboard you will find all necessary metrics of your node (we use this monitoring service by ourselves, so we've configured dashboard properly)

# One line installation:
```
. <(wget -qO- https://raw.githubusercontent.com/L0vd/chain-services/main/mainnets/osmosis/monitoring/osmosis-monitoring-install.sh)
```

# OR Manual installation of telegraf and monitoring script

Install telegraf
```
sudo apt update
sudo apt -y install curl jq bc

# install telegraf
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.14.1-1_amd64.deb
dpkg -i telegraf_*.deb

sudo systemctl enable --now telegraf
sudo systemctl is-enabled telegraf

# make the telegraf user sudo and adm to be able to execute scripts as osmosis user
sudo adduser telegraf sudo
sudo adduser telegraf adm
sudo -- bash -c 'echo "telegraf ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers'
```
You can check telegraf service status:
```
sudo systemctl status telegraf
```
Status can be not ok with default Telegraf's config. Next steps will fix it.

Get files from this project repo and copy variable script template
```
cd $HOME
mkdir osmosis-mainnet-monitoring
cd osmosis-mainnet-monitoring
wget https://raw.githubusercontent.com/L0vd/chain-services/main/mainnets/osmosis/monitoring/monitor.sh
wget https://raw.githubusercontent.com/L0vd/chain-services/main/mainnets/osmosis/monitoring/telegraf.conf
wget https://raw.githubusercontent.com/L0vd/chain-services/main/mainnets/osmosis/monitoring/variables.sh
```

```
nano variables.sh
```

Insert your parameters to **variables.sh**:
* full path to osmosis binary to COS_BIN_NAME ( check ```which d```)
* node PRC port to COS_PORT_RPC ( check in file ```path_to_osmosis_node_config/config/config.toml```)
* node validator address to COS_VALOPER ( like ```osmovaloper********```)

Save changes in variables.sh and enable execution permissions:

```
chmod +x monitor.sh variables.sh
```

Create telegraf service for osmosis-mainnet-node monitoring
```
cat > /etc/systemd/system/telegraf_osmosis_mainnet.service <<EOL
[Unit]
Description=The plugin-driven server agent for reporting metrics into InfluxDB
Documentation=https://github.com/influxdata/telegraf
After=network.target
[Service]
EnvironmentFile=-/etc/default/telegraf
User=telegraf
ExecStart=/usr/bin/telegraf -config /etc/telegraf/telegraf_osmosis_mainnet.conf -config-directory /etc/telegraf/telegraf.d $TELEGRAF_OPTS
ExecReload=/bin/kill -HUP $MAINPID
Restart=on-failure
RestartForceExitStatus=SIGPIPE
KillMode=control-group
[Install]
WantedBy=multi-user.target
EOL
```

Edit telegraf configuration
```
sudo mv /etc/telegraf/telegraf.conf /etc/telegraf/telegraf.conf.orig
sudo mv telegraf_osmosis_mainnet.conf /etc/telegraf/telegraf_osmosis_mainnet.conf
```
Restart telegraf service

```
sudo systemctl daemon-reload
sudo systemctl enable telegraf_osmosis_mainnet
sudo systemctl restart telegraf_osmosis_mainnet
```

## Dashboard interface 

Dashboard has main cosmos-based node information and common system metrics. There is a description for each metric.

Go to our comunity dashboard and select you node from the server list: 
## [Dashboard link](https://monitoring-dashboards.l0vd.com/d/Osmosis_mainnet/osmosis-mainnet-monitoring-by-l0vd?orgId=1&refresh=30s&from=now-1h&to=now)


![Screenshot_1](https://user-images.githubusercontent.com/43213686/169405751-8ff53124-e128-4078-8d68-229a18ea4e25.png)
![Screenshot_2](https://user-images.githubusercontent.com/43213686/169405777-eb9965a5-9fe8-4ecf-944b-4482c41c019b.png)



### Mon health
Complex parameter can show problem concerning receiving metrics from node. Normal value is "OK"

### Sync status
Node catching_up parameter

### Block height
Latest blockheight of node 

### Time since latest block
Time interval in seconds between taking the metric and node latest block time. Value greater 15s may indicate some kind of synchronization problem.

### Peers
Number of connected peers 

### Jailed status
Validator jailed status. 

### Missed blocks
Number of missed blocks in 10000 blocks running window. If the validator misses more than 500 blocks, it will end up in jail.

### Bonded status
Validator stake bonded info

### Voting power
Validator voting power. If the value of this parameter is zero, your node isn't in the active pool of validators 

### Delegated tokens
Number of delegated tokens

### Version
Version of d binary

### Vali Rank
Your node stake rank 

### Active validator numbers
Total number of active validators

### Other common system metrics: CPU/RAM/FS load, etc.
No comments needed
