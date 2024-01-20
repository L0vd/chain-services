## Manual node setup
If you want to setup Artela fullnode manually follow the steps below

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
rm -rf artela
git clone https://github.com/artela-network/artela.git
cd artela
git checkout v0.4.7-rc6
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
artela_WALLET="<YOUR_WALLET_NAME>"
artela_NODENAME="<YOUR_MONIKER>"
artela_CHAIN_ID="artela_11822-1"
```

```
echo "
export artela_WALLET=${artela_WALLET}
export artela_NODENAME=${artela_NODENAME}
export artela_CHAIN_ID=${artela_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
artelad config chain-id ${artela_CHAIN_ID}
```

### Initialize your node
```
artelad init ${artela_NODENAME} --chain-id ${artela_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/artela-testnet/genesis.json" > $HOME/.artela/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/artela-testnet/addrbook.json" > $HOME/.artela/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
artela_PORT=<SET_CUSTOM_PORT> #Example: artela_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${artela_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${artela_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${artela_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${artela_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${artela_PORT}660\"%" /$HOME/.artela/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${artela_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${artela_PORT}317\"%; s%^address = \":8080\"%address = \":${artela_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${artela_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${artela_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${artela_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${artela_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${artela_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${artela_PORT}546\"%" /$HOME/.artela/config/app.toml
```
```
artelad config node tcp://localhost:${artela_PORT}657
```

### Set seeds and peers
```
PEERS="fc1e0fc76767255ae8c7f1bef72e16c7c59dfc48@artela-testnet.peers.l0vd.com:4556"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.artela/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.artela/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.02uart\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.artela/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/artelad.service > /dev/null <<EOF
[Unit]
Description=Artela testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which artelad) start
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
sudo systemctl enable artelad
artelad tendermint unsafe-reset-all --home $HOME/.artela --keep-addr-book
sudo systemctl restart artelad && sudo journalctl -u artelad -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
artelad keys add ${artela_WALLET}
```
##### (OR)

#### 1. Recover your key
```
artelad keys add ${artela_WALLET} --recover
```

```
artela_WALLET_ADDR=$(artelad keys show ${artela_WALLET} -a)
echo "export artela_WALLET_ADDR=${artela_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
artelad tx staking create-validator \
--amount 1000000uart \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(artelad tendermint show-validator) \
--moniker ${artela_NODENAME} \
--chain-id ${artela_CHAIN_ID} \
--from ${artela_WALLET_ADDR} \
--gas-prices 0.02uart \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

