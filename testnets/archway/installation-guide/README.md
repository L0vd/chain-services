## Manual node setup
If you want to setup Archway fullnode manually follow the steps below

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
rm -rf archway
git clone https://github.com/archway-network/archway.git
cd archway
git checkout v0.5.2
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export ARCHWAY_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export ARCHWAY_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export ARCHWAY_CHAIN_ID="constantine-3"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
archwayd config chain-id $ARCHWAY_CHAIN_ID
```

### Initialize your node
```
archwayd init $ARCHWAY_NODENAME --chain-id $ARCHWAY_CHAIN_ID
```

### Download genesis
```
wget "$HOME/.archway/config/genesis.json" https://raw.githubusercontent.com/archway-network/networks/main/constantine-3/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
ARCHWAY_PORT=<SET_CUSTOM_PORT> #Example: ARCHWAY_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ARCHWAY_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ARCHWAY_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ARCHWAY_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ARCHWAY_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ARCHWAY_PORT}660\"%" $HOME/.archway/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ARCHWAY_PORT}317\"%; s%^address = \":8080\"%address = \":${ARCHWAY_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ARCHWAY_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ARCHWAY_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ARCHWAY_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ARCHWAY_PORT}546\"%" $HOME/.archway/config/app.toml
```


### Set seeds and peers
```
SEEDS="3c5bc400c786d8e57ae2b85639273d1aec79829a@35.223.36.227:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.archway/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.archway/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0aconst\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.archway/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/archwayd.service > /dev/null <<EOF
[Unit]
Description=Archway
After=network-online.target

[Service]
User=$USER
ExecStart=$(which archwayd) start
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
sudo systemctl enable archwayd
archwayd tendermint unsafe-reset-all --home $HOME/.archway --keep-addr-book
sudo systemctl restart archwayd && sudo journalctl -u archwayd -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
archwayd keys add $ARCHWAY_WALLET
```
##### (OR)

#### 1. Recover your key
```
archwayd keys add $ARCHWAY_WALLET --recover
```

#### 2. Request tokens from faucet


#### 3. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
archwayd tx staking create-validator \
--amount 1000000aconst \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(archwayd tendermint show-validator) \
--moniker $ARCHWAY_NODENAME \
--chain-id $ARCHWAY_CHAIN_ID \
--from $ARCHWAY_WALLET \
--fees 100000000000000000000aarch \
--yes
```
