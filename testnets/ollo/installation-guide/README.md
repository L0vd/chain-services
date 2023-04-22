## Manual node setup
If you want to setup Ollo fullnode manually follow the steps below

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
git clone https://github.com/OLLO-Station/ollo.git
cd ollo
git checkout v0.0.1
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export OLLO_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export OLLO_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export OLLO_CHAIN_ID="ollo-testnet-1"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
ollod config chain-id $OLLO_CHAIN_ID
```

### Initialize your node
```
ollod init $OLLO_NODENAME --chain-id $OLLO_CHAIN_ID
```

### Download genesis
```
wget "$HOME/.ollo/config/genesis.json" https://raw.githubusercontent.com/OLLO-Station/networks/master/ollo-testnet-1/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
OLLO_PORT=<SET_CUSTOM_PORT> #Example: OLLO_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OLLO_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OLLO_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OLLO_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OLLO_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OLLO_PORT}660\"%" $HOME/.ollo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OLLO_PORT}317\"%; s%^address = \":8080\"%address = \":${OLLO_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OLLO_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OLLO_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OLLO_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OLLO_PORT}546\"%" $HOME/.ollo/config/app.toml
```


### Set seeds and peers
```
SEEDS=""
PEERS="a99fc4e81770ca32d574cac2e8680dccc9b55f74@18.144.61.148:26656,70ba32724461c7ed4ec8d6ddc8b5e0b1cfb9e237@54.219.57.63:26656,7864a2e4b42e5af76a83a8b644b9172fa1e40fa5@52.8.174.235:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ollo/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ollo/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utollo\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.ollo/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/ollod.service > /dev/null <<EOF
[Unit]
Description=Ollo
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ollod) start
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
sudo systemctl enable ollod
ollod tendermint unsafe-reset-all --home $HOME/.ollo --keep-addr-book
sudo systemctl restart ollod && sudo journalctl -u ollod -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
ollod keys add $OLLO_WALLET
```
##### (OR)

#### 1. Recover your key
```
ollod keys add $OLLO_WALLET --recover
```

#### 2. Request tokens from faucet


#### 3. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
ollod tx staking create-validator \
--amount 1000000utollo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(ollod tendermint show-validator) \
--moniker $OLLO_NODENAME \
--chain-id $OLLO_CHAIN_ID \
--from $OLLO_WALLET \
--gas-prices 0.1utollo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
