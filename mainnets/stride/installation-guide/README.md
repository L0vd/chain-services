## Manual node setup
If you want to setup Stride fullnode manually follow the steps below

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
rm -rf stride
git clone https://github.com/Stride-Labs/stride.git
cd stride
git checkout v16.0.0
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
STRIDE_WALLET="<YOUR_WALLET_NAME>"
STRIDE_NODENAME="<YOUR_MONIKER>"
STRIDE_CHAIN_ID="stride-1"
```

```
echo "
export STRIDE_WALLET=${STRIDE_WALLET}
export STRIDE_NODENAME=${STRIDE_NODENAME}
export STRIDE_CHAIN_ID=${STRIDE_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
strided config chain-id ${STRIDE_CHAIN_ID}
```

### Initialize your node
```
strided init ${STRIDE_NODENAME} --chain-id ${STRIDE_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/stride-mainnet/genesis.json" > $HOME/.stride/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/stride-mainnet/addrbook.json" > $HOME/.stride/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
STRIDE_PORT=<SET_CUSTOM_PORT> #Example: STRIDE_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${STRIDE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${STRIDE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${STRIDE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${STRIDE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${STRIDE_PORT}660\"%" /$HOME/.stride/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${STRIDE_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${STRIDE_PORT}317\"%; s%^address = \":8080\"%address = \":${STRIDE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${STRIDE_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${STRIDE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${STRIDE_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${STRIDE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${STRIDE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${STRIDE_PORT}546\"%" /$HOME/.stride/config/app.toml
```


### Set seeds and peers
```
PEERS="e4ef38aea46aed22c4241f691104e164df6fc15a@stride-mainnet.peers.l0vd.com:15656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.stride/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0005ustrd\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.stride/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/strided.service > /dev/null <<EOF
[Unit]
Description=Stride mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which strided) start
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
sudo systemctl enable strided
strided tendermint unsafe-reset-all --home $HOME/.stride --keep-addr-book
sudo systemctl restart strided && sudo journalctl -u strided -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
strided keys add ${STRIDE_WALLET}
```
##### (OR)

#### 1. Recover your key
```
strided keys add ${STRIDE_WALLET} --recover
```

```
STRIDE_WALLET_ADDR=$(strided keys show ${STRIDE_WALLET} -a)
echo "export STRIDE_WALLET_ADDR=${STRIDE_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
strided tx staking create-validator \
--amount 1000000ustrd \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(strided tendermint show-validator) \
--moniker ${STRIDE_NODENAME} \
--chain-id ${STRIDE_CHAIN_ID} \
--from ${STRIDE_WALLET_ADDR} \
--gas-prices 0.0005ustrd \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

