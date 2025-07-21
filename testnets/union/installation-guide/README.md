## Manual node setup
If you want to setup Union fullnode manually follow the steps below

### Update and upgrade
```
sudo apt update && sudo apt upgrade -y
```

### Install GO
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.24.2"
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
wget https://github.com/unionlabs/union/releases/download/uniond%2Fv1.0.0-rc3.alpha1/uniond-release-x86_64-linux
chmod +x uniond
mv uniond /root/go/bin/
uniond version
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
UNION_WALLET="<YOUR_WALLET_NAME>"
UNION_NODENAME="<YOUR_MONIKER>"
UNION_CHAIN_ID=""
```

```
echo "
export UNION_WALLET=${UNION_WALLET}
export UNION_NODENAME=${UNION_NODENAME}
export UNION_CHAIN_ID=${UNION_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
uniond config chain-id ${UNION_CHAIN_ID} --home $HOME/.union
```

### Initialize your node
```
uniond init ${UNION_NODENAME} --chain-id ${UNION_CHAIN_ID} --home $HOME/.union
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/union-testnet/genesis.json" > $HOME/.union/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/union-testnet/addrbook.json" > $HOME/.union/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
UNION_PORT=<SET_CUSTOM_PORT> #Example: UNION_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${UNION_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${UNION_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${UNION_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${UNION_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${UNION_PORT}660\"%" /$HOME/.union/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${UNION_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${UNION_PORT}317\"%; s%^address = \":8080\"%address = \":${UNION_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${UNION_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${UNION_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${UNION_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${UNION_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${UNION_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${UNION_PORT}546\"%" /$HOME/.union/config/app.toml
```


### Set seeds and peers
```
PEERS="@union-testnet.peers.l0vd.com:"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.union/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.union/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.union/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.union/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.union/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0muno\"/" $HOME/.union/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.union/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/uniond.service > /dev/null <<EOF
[Unit]
Description=Union testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which uniond) start --home $HOME/.union
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
sudo systemctl enable uniond
uniond tendermint unsafe-reset-all --home $HOME/.union --keep-addr-book
sudo systemctl restart uniond && sudo journalctl -u uniond -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
uniond keys add ${UNION_WALLET} --home $HOME/.union
```
##### (OR)

#### 1. Recover your key
```
uniond keys add ${UNION_WALLET} --recover --home $HOME/.union
```

```
UNION_WALLET_ADDR=$(uniond keys show ${UNION_WALLET} -a)
echo "export UNION_WALLET_ADDR=${UNION_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
uniond tx staking create-validator \
--amount 1000000muno \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(uniond tendermint show-validator) \
--moniker ${UNION_NODENAME} \
--chain-id ${UNION_CHAIN_ID} \
--from ${UNION_WALLET_ADDR} \
--gas-prices 0muno \
--gas-adjustment 1.5 \
--gas auto \
--home $HOME/.union \
--yes 
```

