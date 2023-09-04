## Manual node setup
If you want to setup  fullnode manually follow the steps below

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
rm -rf 
git clone 
cd 
git checkout 
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
_WALLET="<YOUR_WALLET_NAME>"
_NODENAME="<YOUR_MONIKER>"
_CHAIN_ID="galileo-3"
```

```
echo "
export _WALLET=${_WALLET}
export _NODENAME=${_NODENAME}
export _CHAIN_ID=${_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
 config chain-id ${}
```

### Initialize your node
```
 init ${} --chain-id ${}
```

### Download genesis
```
curl -Ls "" > $HOME//config/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
_PORT=<SET_CUSTOM_PORT> #Example: _PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${_PORT}660\"%" /$HOME//config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${_PORT}317\"%; s%^address = \":8080\"%address = \":${_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${_PORT}546\"%" /$HOME//config/app.toml
```


### Set seeds and peers
```
PEERS="@.peers.l0vd.com:"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME//config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME//config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME//config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME//config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME//config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"\"/" $HOME//config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME//config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/.service > /dev/null <<EOF
[Unit]
Description= 
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ) start
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
sudo systemctl enable 
 tendermint unsafe-reset-all --home $HOME/ --keep-addr-book
sudo systemctl restart  && sudo journalctl -u  -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
 keys add ${wallet}
```
##### (OR)

#### 1. Recover your key
```
 keys add ${wallet} --recover
```

```
_WALLET_ADDR=$( keys show ${_WALLET} -a)
echo "export _WALLET_ADDR=${_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
 tx staking create-validator \
--amount 1000000 \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $( tendermint show-validator) \
--moniker ${} \
--chain-id ${} \
--from ${_WALLET_ADDR} \
--gas-prices  \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

