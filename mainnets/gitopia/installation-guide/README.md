## Manual node setup
If you want to setup Gitopia fullnode manually follow the steps below

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
rm -rf gitopia
git clone https://github.com/gitopia-network/gitopia.git
cd gitopia
git checkout vnull
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
GITOPIA_WALLET="<YOUR_WALLET_NAME>"
GITOPIA_NODENAME="<YOUR_MONIKER>"
GITOPIA_CHAIN_ID="gitopia"
```

```
echo "
export GITOPIA_WALLET=${GITOPIA_WALLET}
export GITOPIA_NODENAME=${GITOPIA_NODENAME}
export GITOPIA_CHAIN_ID=${GITOPIA_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
nulld config chain-id ${GITOPIA_CHAIN_ID}
```

### Initialize your node
```
nulld init ${GITOPIA_NODENAME} --chain-id ${GITOPIA_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/gitopia-mainnet/genesis.json" > $HOME/.gitopia/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/gitopia-mainnet/addrbook.json" > $HOME/.gitopia/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
GITOPIA_PORT=<SET_CUSTOM_PORT> #Example: GITOPIA_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${GITOPIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${GITOPIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${GITOPIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${GITOPIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${GITOPIA_PORT}660\"%" /$HOME/.gitopia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${GITOPIA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${GITOPIA_PORT}317\"%; s%^address = \":8080\"%address = \":${GITOPIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${GITOPIA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${GITOPIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${GITOPIA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${GITOPIA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${GITOPIA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${GITOPIA_PORT}546\"%" /$HOME/.gitopia/config/app.toml
```


### Set seeds and peers
```
PEERS="aa26aa0baa5dfc41c126d16d4dc48bb45151d560@gitopia-mainnet.peers.l0vd.com:22656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gitopia/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gitopia/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.001ulore\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.gitopia/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/nulld.service > /dev/null <<EOF
[Unit]
Description=Gitopia mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which nulld) start
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
sudo systemctl enable nulld
nulld tendermint unsafe-reset-all --home $HOME/.gitopia --keep-addr-book
sudo systemctl restart nulld && sudo journalctl -u nulld -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
nulld keys add ${GITOPIA_WALLET}
```
##### (OR)

#### 1. Recover your key
```
nulld keys add ${GITOPIA_WALLET} --recover
```

```
GITOPIA_WALLET_ADDR=$(nulld keys show ${GITOPIA_WALLET} -a)
echo "export GITOPIA_WALLET_ADDR=${GITOPIA_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
nulld tx staking create-validator \
--amount 1000000ulore \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(nulld tendermint show-validator) \
--moniker ${GITOPIA_NODENAME} \
--chain-id ${GITOPIA_CHAIN_ID} \
--from ${GITOPIA_WALLET_ADDR} \
--gas-prices 0.001ulore \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

