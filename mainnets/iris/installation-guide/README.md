## Manual node setup
If you want to setup Iris fullnode manually follow the steps below

### Update and upgrade
```
sudo apt update && sudo apt upgrade -y
```

### Install GO
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.19.3"
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
rm -rf irishub
git clone https://github.com/irisnet/irishub.git
cd irishub
git checkout v2.0.0
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
IRIS_WALLET="<YOUR_WALLET_NAME>"
IRIS_NODENAME="<YOUR_MONIKER>"
IRIS_CHAIN_ID="irishub-1"
```

```
echo "
export IRIS_WALLET=${IRIS_WALLET}
export IRIS_NODENAME=${IRIS_NODENAME}
export IRIS_CHAIN_ID=${IRIS_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
iris config chain-id ${IRIS_CHAIN_ID}
```

### Initialize your node
```
iris init ${IRIS_NODENAME} --chain-id ${IRIS_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/archway-mainnet/genesis.json" > $HOME/.iris/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/archway-mainnet/addrbook.json" > $HOME/.iris/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
IRIS_PORT=<SET_CUSTOM_PORT> #Example: IRIS_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${IRIS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${IRIS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${IRIS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${IRIS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${IRIS_PORT}660\"%" /$HOME/.iris/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${IRIS_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${IRIS_PORT}317\"%; s%^address = \":8080\"%address = \":${IRIS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${IRIS_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${IRIS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${IRIS_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${IRIS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${IRIS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${IRIS_PORT}546\"%" /$HOME/.iris/config/app.toml
```
```
iris config node tcp://localhost:${IRIS_PORT}657
```

### Set seeds and peers
```
PEERS="3ddf22082bda8607289bd94b649e0e2595f1fffd@iris-mainnet.peers.l0vd.com:19656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.iris/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.iris/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uiris\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.iris/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/iris.service > /dev/null <<EOF
[Unit]
Description=Iris mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which iris) start
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
sudo systemctl enable iris
iris tendermint unsafe-reset-all --home $HOME/.iris --keep-addr-book
sudo systemctl restart iris && sudo journalctl -u iris -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
iris keys add ${IRIS_WALLET}
```
##### (OR)

#### 1. Recover your key
```
iris keys add ${IRIS_WALLET} --recover
```

```
IRIS_WALLET_ADDR=$(iris keys show ${IRIS_WALLET} -a)
echo "export IRIS_WALLET_ADDR=${IRIS_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
iris tx staking create-validator \
--amount 1000000uiris \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(iris tendermint show-validator) \
--moniker ${IRIS_NODENAME} \
--chain-id ${IRIS_CHAIN_ID} \
--from ${IRIS_WALLET_ADDR} \
--gas-prices 0.025uiris \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

