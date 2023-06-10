## Manual node setup
If you want to setup Empower fullnode manually follow the steps below

### Update and upgrade
```
sudo apt update && sudo apt upgrade -y
```

### Install GO
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.20.1"
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
rm -rf empowerchain
git clone https://github.com/EmpowerPlastic/empowerchain
cd empowerchain/chain
git checkout v1.0.0-rc2
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export EMPOWER_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export EMPOWER_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export EMPOWER_CHAIN_ID="circulus-1"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
empowerd config chain-id ${EMPOWER_CHAIN_ID}
```

### Initialize your node
```
empowerd init ${EMPOWER_NODENAME} --chain-id ${EMPOWER_CHAIN_ID}
```

### Download genesis
```
wget "$HOME/.empowerchain/config/genesis.json" "http://snapshots.l0vd.com/empower/genesis.json" 
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
EMPOWER_PORT=<SET_CUSTOM_PORT> #Example: EMPOWER_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:$"EMPOWER_PORT"658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:$"EMPOWER_PORT"657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:$"EMPOWER_PORT"060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:$"EMPOWER_PORT"656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":$"EMPOWER_PORT"660\"%" $HOME/.empowerchain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:$"EMPOWER_PORT"317\"%; s%^address = \":8080\"%address = \":$"EMPOWER_PORT"080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:$"EMPOWER_PORT"090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:$"EMPOWER_PORT"091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:$"EMPOWER_PORT"545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:$"EMPOWER_PORT"546\"%" $HOME/.empowerchain/config/app.toml
```


### Set seeds and peers
```
PEERS="5e8a0ef0c941f7b68f45610cf280ccc1a208e6d0@empower-testnet.peers.l0vd.com:24657"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.empowerchain/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.empowerchain/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0umpwr\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.empowerchain/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/empowerd.service > /dev/null <<EOF
[Unit]
Description=Empower mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which empowerd) start
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
sudo systemctl enable empowerd
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain --keep-addr-book
sudo systemctl restart empowerd && sudo journalctl -u empowerd -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
empowerd keys add ${EMPOWER_WALLET}
```
##### (OR)

#### 1. Recover your key
```
empowerd keys add ${EMPOWER_WALLET} --recover
```



### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
empowerd tx staking create-validator \
--amount 1000000umpwr \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(empowerd tendermint show-validator) \
--moniker ${EMPOWER_NODENAME} \
--chain-id ${EMPOWER_CHAIN_ID} \
--from ${EMPOWER_WALLET} \
--gas-prices 0.1umpwr \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

