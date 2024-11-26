## Manual node setup
If you want to setup Bitcanna fullnode manually follow the steps below

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
rm -rf bcna
git clone https://github.com/BitCannaGlobal/bcna.git
cd bcna
git checkout v
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
BITCANNA_WALLET="<YOUR_WALLET_NAME>"
BITCANNA_NODENAME="<YOUR_MONIKER>"
BITCANNA_CHAIN_ID=""
```

```
echo "
export BITCANNA_WALLET=${BITCANNA_WALLET}
export BITCANNA_NODENAME=${BITCANNA_NODENAME}
export BITCANNA_CHAIN_ID=${BITCANNA_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
d config chain-id ${BITCANNA_CHAIN_ID}
```

### Initialize your node
```
d init ${BITCANNA_NODENAME} --chain-id ${BITCANNA_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/bitcanna-mainnet/genesis.json" > $HOME/.bcna/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/bitcanna-mainnet/addrbook.json" > $HOME/.bcna/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
BITCANNA_PORT=<SET_CUSTOM_PORT> #Example: BITCANNA_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BITCANNA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BITCANNA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BITCANNA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BITCANNA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BITCANNA_PORT}660\"%" /$HOME/.bcna/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BITCANNA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${BITCANNA_PORT}317\"%; s%^address = \":8080\"%address = \":${BITCANNA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BITCANNA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${BITCANNA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BITCANNA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${BITCANNA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BITCANNA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BITCANNA_PORT}546\"%" /$HOME/.bcna/config/app.toml
```
```
d config node tcp://localhost:${BITCANNA_PORT}657
```

### Set seeds and peers
```
PEERS="858b5cf31f1cc5e6b4da25bb21d4b58b76460038@bitcanna-mainnet.peers.l0vd.com:12656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.bcna/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.bcna/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.bcna/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/d.service > /dev/null <<EOF
[Unit]
Description=Bitcanna mainnet
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
d tendermint unsafe-reset-all --home $HOME/.bcna --keep-addr-book
sudo systemctl restart d && sudo journalctl -u d -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
d keys add ${BITCANNA_WALLET}
```
##### (OR)

#### 1. Recover your key
```
d keys add ${BITCANNA_WALLET} --recover
```

```
BITCANNA_WALLET_ADDR=$(d keys show ${BITCANNA_WALLET} -a)
echo "export BITCANNA_WALLET_ADDR=${BITCANNA_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
d tx staking create-validator \
--amount 1000000 \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(d tendermint show-validator) \
--moniker ${BITCANNA_NODENAME} \
--chain-id ${BITCANNA_CHAIN_ID} \
--from ${BITCANNA_WALLET_ADDR} \
--gas-prices 0 \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

