## Manual node setup
If you want to setup Osmosis fullnode manually follow the steps below

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
rm -rf osmosis
git clone https://github.com/osmosis-labs/osmosis.git
cd osmosis
git checkout v
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
OSMOSIS_WALLET="<YOUR_WALLET_NAME>"
OSMOSIS_NODENAME="<YOUR_MONIKER>"
OSMOSIS_CHAIN_ID=""
```

```
echo "
export OSMOSIS_WALLET=${OSMOSIS_WALLET}
export OSMOSIS_NODENAME=${OSMOSIS_NODENAME}
export OSMOSIS_CHAIN_ID=${OSMOSIS_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
d config chain-id ${OSMOSIS_CHAIN_ID}
```

### Initialize your node
```
d init ${OSMOSIS_NODENAME} --chain-id ${OSMOSIS_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/osmosis-mainnet/genesis.json" > $HOME/.osmosisd/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/osmosis-mainnet/addrbook.json" > $HOME/.osmosisd/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
OSMOSIS_PORT=<SET_CUSTOM_PORT> #Example: OSMOSIS_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OSMOSIS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OSMOSIS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OSMOSIS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OSMOSIS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OSMOSIS_PORT}660\"%" /$HOME/.osmosisd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OSMOSIS_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${OSMOSIS_PORT}317\"%; s%^address = \":8080\"%address = \":${OSMOSIS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OSMOSIS_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${OSMOSIS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OSMOSIS_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${OSMOSIS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OSMOSIS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OSMOSIS_PORT}546\"%" /$HOME/.osmosisd/config/app.toml
```


### Set seeds and peers
```
PEERS="10539f7c0e3ab233cf0deec9930aa8b660aeeabf@osmosis-mainnet.peers.l0vd.com:12656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.osmosisd/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.osmosisd/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uosmo\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.osmosisd/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/d.service > /dev/null <<EOF
[Unit]
Description=Osmosis mainnet
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
d tendermint unsafe-reset-all --home $HOME/.osmosisd --keep-addr-book
sudo systemctl restart d && sudo journalctl -u d -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
d keys add ${OSMOSIS_WALLET}
```
##### (OR)

#### 1. Recover your key
```
d keys add ${OSMOSIS_WALLET} --recover
```

```
OSMOSIS_WALLET_ADDR=$(d keys show ${OSMOSIS_WALLET} -a)
echo "export OSMOSIS_WALLET_ADDR=${OSMOSIS_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
d tx staking create-validator \
--amount 1000000uosmo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(d tendermint show-validator) \
--moniker ${OSMOSIS_NODENAME} \
--chain-id ${OSMOSIS_CHAIN_ID} \
--from ${OSMOSIS_WALLET_ADDR} \
--gas-prices 0.0025uosmo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

