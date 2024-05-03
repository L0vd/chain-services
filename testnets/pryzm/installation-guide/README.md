## Manual node setup
If you want to setup Pryzm fullnode manually follow the steps below

### Update and upgrade
```
sudo apt update -y
sudo apt-get install -y git jq lz4 build-essential make gcc curl 
sudo apt update -y
```

### Install GO
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.20.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

### Install node
```
cd $HOME
wget https://storage.googleapis.com/pryzm-resources/pryzmd-v-linux-amd64.tar.gz
tar -xzvf pryzmd-v-linux-amd64.tar.gz
mv d /root/go/bin
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
PRYZM_WALLET="<YOUR_WALLET_NAME>"
PRYZM_NODENAME="<YOUR_MONIKER>"
PRYZM_CHAIN_ID="indigo-1"
```

```
echo "
export PRYZM_WALLET=${PRYZM_WALLET}
export PRYZM_NODENAME=${PRYZM_NODENAME}
export PRYZM_CHAIN_ID=${PRYZM_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
d config chain-id ${PRYZM_CHAIN_ID}
```

### Initialize your node
```
d init ${PRYZM_NODENAME} --chain-id ${PRYZM_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/pryzm-testnet/genesis.json" > $HOME/.pryzm/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/pryzm-testnet/addrbook.json" > $HOME/.pryzm/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
PRYZM_PORT=<SET_CUSTOM_PORT> #Example: PRYZM_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PRYZM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PRYZM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PRYZM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PRYZM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PRYZM_PORT}660\"%" /$HOME/.pryzm/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PRYZM_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${PRYZM_PORT}317\"%; s%^address = \":8080\"%address = \":${PRYZM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PRYZM_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PRYZM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PRYZM_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PRYZM_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PRYZM_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PRYZM_PORT}546\"%" /$HOME/.pryzm/config/app.toml
```


### Set seeds and peers
```
PEERS="84b9de17882dc6c9af824395a2072b321bc409ea@pryzm-testnet.peers.l0vd.com:36656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.pryzm/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.pryzm/config/app.toml
```

### Set minimum gas price and kv indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.015upryzm\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.pryzm/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/d.service > /dev/null <<EOF
[Unit]
Description=Pryzm testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which d) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

### Reset blockchain info and restart your node
```
sudo systemctl daemon-reload
sudo systemctl enable d
d tendermint unsafe-reset-all --home $HOME/.pryzm --keep-addr-book
sudo systemctl restart d && sudo journalctl -u d -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
d keys add ${PRYZM_WALLET}
```
##### (OR)

#### 1. Recover your key
```
d keys add ${PRYZM_WALLET} --recover
```

```
PRYZM_WALLET_ADDR=$(d keys show ${PRYZM_WALLET} -a)
echo "export PRYZM_WALLET_ADDR=${PRYZM_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
d tx staking create-validator \
--amount 1000000upryzm \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(d tendermint show-validator) \
--moniker ${PRYZM_NODENAME} \
--chain-id ${PRYZM_CHAIN_ID} \
--from ${PRYZM_WALLET_ADDR} \
--gas-prices 0.015upryzm \
--gas-adjustment 1.2 \
--gas auto \
--yes
```

## Set up Price-feeder

### Install docker compose

[Docker install guide](https://docs.docker.com/compose/install/linux/#install-the-plugin-manually)

### Get docker compose file
```
cd $HOME
mkdir pryzm-feeder
cd pryzm-feeder
wget https://storage.googleapis.com/pryzm-zone/feeder/docker-compose.yml
```

### Get config and sql.init files
```
cd $HOME
cd pryzm-feeder
wget https://storage.googleapis.com/pryzm-zone/feeder/config.yaml
wget https://storage.googleapis.com/pryzm-zone/feeder/init.sql
```

### Create and fund price-feeder wallet using [Faucet](https://testnet.pryzm.zone/faucet)
```
PRYZM_FEEDER_WALLET_NAME=<YOUR_FEEDER_WALLET_NAME>
```

```
pryzmd keys add $PRYZM_FEEDER_WALLET_NAME
```

### Set manually these fields in config.yaml file 
```
feeder: "<YOUR FEEDER WALLET ADDRESS>"
feederMnemonic: "<YOUR FEEDER WALLET ADDRESS SEED PHRASE>"
validator: "<YOUR VALOPER (przymvaloper...)>"
rpcUrl: "http://localhost:{YOUR_PORT}"
lcdUrl: "http://localhost:{YOUR_PORT}"
grpcWebUrl: "http://localhost:{YOUR_PORT}"
wsUrl: "ws://localhost:{YOUR_PORT}"
```

### Delegate rights to feeder
```
pryzmd tx oracle delegate-feed-consent <YOUR FEEDER ADDRESS> --fees 2000factory/pryzm15k9s9p0ar0cx27nayrgk6vmhyec3lj7vkry7rx/uusdsim,3000upryzm --from <YOUR VALIDATOR WALLET ADDRESS>
```

### Run your feeder
```
cd $HOME/pryzm-feeder
docker compose up -d
```

### Check logs
```
docker logs -f pryzm-feeder
```
