## Manual node setup
If you want to setup Cosmoshub fullnode manually follow the steps below

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
rm -rf gaia
git clone https://github.com/cosmos/gaia.git
cd gaia
git checkout v11.0.0
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
COSMOSHUB_WALLET="<YOUR_WALLET_NAME>"
COSMOSHUB_NODENAME="<YOUR_MONIKER>"
COSMOSHUB_CHAIN_ID="cosmoshub-4"
```

```
echo "
export COSMOSHUB_WALLET=${COSMOSHUB_WALLET}
export COSMOSHUB_NODENAME=${COSMOSHUB_NODENAME}
export COSMOSHUB_CHAIN_ID=${COSMOSHUB_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
gaiad config chain-id ${COSMOSHUB_CHAIN_ID}
```

### Initialize your node
```
gaiad init ${COSMOSHUB_NODENAME} --chain-id ${COSMOSHUB_CHAIN_ID}
```

### Download genesis
```
curl -Ls "" > $HOME/.gaia/config/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
COSMOSHUB_PORT=<SET_CUSTOM_PORT> #Example: COSMOSHUB_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOSHUB_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOSHUB_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOSHUB_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOSHUB_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOSHUB_PORT}660\"%" /$HOME/.gaia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOSHUB_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${COSMOSHUB_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOSHUB_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOSHUB_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${COSMOSHUB_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOSHUB_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${COSMOSHUB_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOSHUB_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOSHUB_PORT}546\"%" /$HOME/.gaia/config/app.toml
```


### Set seeds and peers
```
PEERS="e25465e89f2466fdfc71294bee9565ea6b00b9fc@cosmoshub-mainnet.peers.l0vd.com:16656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.gaia/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gaia/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uatom\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.gaia/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/gaiad.service > /dev/null <<EOF
[Unit]
Description=Cosmoshub mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which gaiad) start
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
sudo systemctl enable gaiad
gaiad tendermint unsafe-reset-all --home $HOME/.gaia --keep-addr-book
sudo systemctl restart gaiad && sudo journalctl -u gaiad -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
gaiad keys add ${COSMOSHUB_WALLET}
```
##### (OR)

#### 1. Recover your key
```
gaiad keys add ${COSMOSHUB_WALLET} --recover
```

```
COSMOSHUB_WALLET_ADDR=$(gaiad keys show ${COSMOSHUB_WALLET} -a)
echo "export COSMOSHUB_WALLET_ADDR=${COSMOSHUB_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
gaiad tx staking create-validator \
--amount 1000000uatom \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(gaiad tendermint show-validator) \
--moniker ${COSMOSHUB_NODENAME} \
--chain-id ${COSMOSHUB_CHAIN_ID} \
--from ${COSMOSHUB_WALLET_ADDR} \
--gas-prices 0uatom \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

