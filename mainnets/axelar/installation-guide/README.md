## Manual node setup
If you want to setup Axelar fullnode manually follow the steps below

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
rm -rf axelar-core
git clone https://github.com/axelarnetwork/axelar-core.git
cd axelar-core
git checkout v0.33.2
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
AXELAR_WALLET="<YOUR_WALLET_NAME>"
AXELAR_NODENAME="<YOUR_MONIKER>"
AXELAR_CHAIN_ID="axelar-dojo-1"
```

```
echo "
export AXELAR_WALLET=${AXELAR_WALLET}
export AXELAR_NODENAME=${AXELAR_NODENAME}
export AXELAR_CHAIN_ID=${AXELAR_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
axelard config chain-id ${AXELAR_CHAIN_ID}
```

### Initialize your node
```
axelard init ${AXELAR_NODENAME} --chain-id ${AXELAR_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/axelar-mainnet/genesis.json" > $HOME/.axelar/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/axelar-mainnet/addrbook.json" > $HOME/.axelar/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
AXELAR_PORT=<SET_CUSTOM_PORT> #Example: AXELAR_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${AXELAR_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${AXELAR_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${AXELAR_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${AXELAR_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${AXELAR_PORT}660\"%" /$HOME/.axelar/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${AXELAR_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${AXELAR_PORT}317\"%; s%^address = \":8080\"%address = \":${AXELAR_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${AXELAR_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${AXELAR_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${AXELAR_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${AXELAR_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${AXELAR_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${AXELAR_PORT}546\"%" /$HOME/.axelar/config/app.toml
```


### Set seeds and peers
```
PEERS="ba30dded0636b0e8bb3ed911c915cef9e76d8af7@axelar-mainnet.peers.l0vd.com:11656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.axelar/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.axelar/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.007uaxl\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.axelar/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/axelard.service > /dev/null <<EOF
[Unit]
Description=Axelar mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which axelard) start
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
sudo systemctl enable axelard
axelard tendermint unsafe-reset-all --home $HOME/.axelar --keep-addr-book
sudo systemctl restart axelard && sudo journalctl -u axelard -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
axelard keys add ${AXELAR_WALLET}
```
##### (OR)

#### 1. Recover your key
```
axelard keys add ${AXELAR_WALLET} --recover
```

```
AXELAR_WALLET_ADDR=$(axelard keys show ${AXELAR_WALLET} -a)
echo "export AXELAR_WALLET_ADDR=${AXELAR_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
axelard tx staking create-validator \
--amount 1000000uaxl \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(axelard tendermint show-validator) \
--moniker ${AXELAR_NODENAME} \
--chain-id ${AXELAR_CHAIN_ID} \
--from ${AXELAR_WALLET_ADDR} \
--gas-prices 0.007uaxl \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

