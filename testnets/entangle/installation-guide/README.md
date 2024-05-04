## Manual node setup
If you want to setup Entangle fullnode manually follow the steps below

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
rm -rf entangle-blockchain
git clone https://github.com/Entangle-Protocol/entangle-blockchain.git
cd entangle-blockchain
git checkout v1.0.1
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
ENTANGLE_WALLET="<YOUR_WALLET_NAME>"
ENTANGLE_NODENAME="<YOUR_MONIKER>"
ENTANGLE_CHAIN_ID="entangle_33133-1"
```

```
echo "
export ENTANGLE_WALLET=${ENTANGLE_WALLET}
export ENTANGLE_NODENAME=${ENTANGLE_NODENAME}
export ENTANGLE_CHAIN_ID=${ENTANGLE_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
entangled config chain-id ${ENTANGLE_CHAIN_ID}
```

### Initialize your node
```
entangled init ${ENTANGLE_NODENAME} --chain-id ${ENTANGLE_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/entangle-testnet/genesis.json" > $HOME/.entangled/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/entangle-testnet/addrbook.json" > $HOME/.entangled/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
ENTANGLE_PORT=<SET_CUSTOM_PORT> #Example: ENTANGLE_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ENTANGLE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ENTANGLE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ENTANGLE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ENTANGLE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ENTANGLE_PORT}660\"%" /$HOME/.entangled/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ENTANGLE_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${ENTANGLE_PORT}317\"%; s%^address = \":8080\"%address = \":${ENTANGLE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ENTANGLE_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${ENTANGLE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ENTANGLE_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${ENTANGLE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ENTANGLE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ENTANGLE_PORT}546\"%" /$HOME/.entangled/config/app.toml
```
```
entangled config node tcp://localhost:${ENTANGLE_PORT}657
```

### Set seeds and peers
```
PEERS="d13f727f544d31c2b07c8d9a794109b24acf76b2@entangle-testnet.peers.l0vd.com:14656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.entangled/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.entangled/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"10aNGL\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.entangled/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/entangled.service > /dev/null <<EOF
[Unit]
Description=Entangle testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which entangled) start
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
sudo systemctl enable entangled
entangled tendermint unsafe-reset-all --home $HOME/.entangled --keep-addr-book
sudo systemctl restart entangled && sudo journalctl -u entangled -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
entangled keys add ${ENTANGLE_WALLET}
```
##### (OR)

#### 1. Recover your key
```
entangled keys add ${ENTANGLE_WALLET} --recover
```

```
ENTANGLE_WALLET_ADDR=$(entangled keys show ${ENTANGLE_WALLET} -a)
echo "export ENTANGLE_WALLET_ADDR=${ENTANGLE_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
entangled tx staking create-validator \
--amount 1000000aNGL \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(entangled tendermint show-validator) \
--moniker ${ENTANGLE_NODENAME} \
--chain-id ${ENTANGLE_CHAIN_ID} \
--from ${ENTANGLE_WALLET_ADDR} \
--gas-prices 10aNGL \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

