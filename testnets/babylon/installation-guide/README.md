## Manual node setup
If you want to setup Babylon fullnode manually follow the steps below

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
rm -rf babylon
git clone https://github.com/babylonchain/babylon.git
cd babylon
git checkout v0.7.2
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
BABYLON_WALLET="<YOUR_WALLET_NAME>"
BABYLON_NODENAME="<YOUR_MONIKER>"
BABYLON_CHAIN_ID="bbn-test-2"
```

```
echo "
export BABYLON_WALLET=${BABYLON_WALLET}
export BABYLON_NODENAME=${BABYLON_NODENAME}
export BABYLON_CHAIN_ID=${BABYLON_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
babylond config chain-id ${BABYLON_CHAIN_ID}
babylond config keyring-backend test
```

### Initialize your node
```
babylond init ${BABYLON_NODENAME} --chain-id ${BABYLON_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/axelar-mainnet/genesis.json" > $HOME/.babylond/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/axelar-mainnet/addrbook.json" > $HOME/.babylond/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
BABYLON_PORT=<SET_CUSTOM_PORT> #Example: BABYLON_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BABYLON_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BABYLON_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BABYLON_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BABYLON_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BABYLON_PORT}660\"%" /$HOME/.babylond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BABYLON_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${BABYLON_PORT}317\"%; s%^address = \":8080\"%address = \":${BABYLON_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BABYLON_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${BABYLON_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BABYLON_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${BABYLON_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BABYLON_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BABYLON_PORT}546\"%" /$HOME/.babylond/config/app.toml
```
```
babylond config node tcp://localhost:${BABYLON_PORT}657
```

### Set seeds and peers
```
PEERS="@babylon-testnet.peers.l0vd.com:"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.babylond/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.babylond/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00001ubbn\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.babylond/config/config.toml
```
### Set custom for Babylon node timeout_commit
```
sed -i -e "s|^timeout_commit *=.*|timeout_commit = \"10s\"|" $HOME/.babylond/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/babylond.service > /dev/null <<EOF
[Unit]
Description=Babylon testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which babylond) start
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
sudo systemctl enable babylond
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book
sudo systemctl restart babylond && sudo journalctl -u babylond -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
babylond keys add ${BABYLON_WALLET}
```
##### (OR)

#### 1. Recover your key
```
babylond keys add ${BABYLON_WALLET} --recover
```

```
BABYLON_WALLET_ADDR=$(babylond keys show ${BABYLON_WALLET} -a)
echo "export BABYLON_WALLET_ADDR=${BABYLON_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```

#### 1.1 Add a BLS key
```
babylond create-bls-key $(babylond keys show ${BABYLON_WALLET} -a)
```

### 1.2 Add to config.toml name of the key created in p.1

```
sed -i -e "s|^key-name *=.*|key-name = \"${BABYLON_WALLET}\"|" $HOME/.babylond/config/config.toml
```

### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
babylond tx checkpointing create-validator \
--amount 1000000ubbn \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(babylond tendermint show-validator) \
--moniker ${BABYLON_NODENAME} \
--chain-id ${BABYLON_CHAIN_ID} \
--from ${BABYLON_WALLET_ADDR} \
--gas-prices 0.00001ubbn \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

