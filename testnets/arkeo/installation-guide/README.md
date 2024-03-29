## Manual node setup
If you want to setup Arkeo fullnode manually follow the steps below

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
wget https://snapshots.l0vd.com/arkeo-testnet/arkeod
chmod +x arkeod
mv arkeod /root/go/bin/
arkeod version
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
ARKEO_WALLET="<YOUR_WALLET_NAME>"
ARKEO_NODENAME="<YOUR_MONIKER>"
ARKEO_CHAIN_ID="arkeo"
```

```
echo "
export ARKEO_WALLET=${ARKEO_WALLET}
export ARKEO_NODENAME=${ARKEO_NODENAME}
export ARKEO_CHAIN_ID=${ARKEO_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
arkeod config chain-id ${ARKEO_CHAIN_ID}
```

### Initialize your node
```
arkeod init ${ARKEO_NODENAME} --chain-id ${ARKEO_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/arkeo-testnet/genesis.json" > $HOME/.arkeo/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/arkeo-testnet/addrbook.json" > $HOME/.arkeo/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
ARKEO_PORT=<SET_CUSTOM_PORT> #Example: ARKEO_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ARKEO_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ARKEO_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ARKEO_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ARKEO_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ARKEO_PORT}660\"%" /$HOME/.arkeo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ARKEO_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${ARKEO_PORT}317\"%; s%^address = \":8080\"%address = \":${ARKEO_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ARKEO_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${ARKEO_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ARKEO_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${ARKEO_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ARKEO_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ARKEO_PORT}546\"%" /$HOME/.arkeo/config/app.toml
```


### Set seeds and peers
```
PEERS="cb9401d70e1bd59e3ed279942ce026dae82aca1f@arkeo-testnet.peers.l0vd.com:27656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.arkeo/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.arkeo/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uarkeo\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.arkeo/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/arkeod.service > /dev/null <<EOF
[Unit]
Description=Arkeo testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which arkeod) start
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
sudo systemctl enable arkeod
arkeod tendermint unsafe-reset-all --home $HOME/.arkeo --keep-addr-book
sudo systemctl restart arkeod && sudo journalctl -u arkeod -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
arkeod keys add ${ARKEO_WALLET}
```
##### (OR)

#### 1. Recover your key
```
arkeod keys add ${ARKEO_WALLET} --recover
```

```
ARKEO_WALLET_ADDR=$(arkeod keys show ${ARKEO_WALLET} -a)
echo "export ARKEO_WALLET_ADDR=${ARKEO_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
arkeod tx staking create-validator \
--amount 1000000uarkeo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(arkeod tendermint show-validator) \
--moniker ${ARKEO_NODENAME} \
--chain-id ${ARKEO_CHAIN_ID} \
--from ${ARKEO_WALLET_ADDR} \
--gas-prices 0uarkeo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

