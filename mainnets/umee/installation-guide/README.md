## Manual node setup
If you want to setup Umee fullnode manually follow the steps below

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
rm -rf umee
git clone https://github.com/umee-network/umee.git
cd umee
git checkout v6.2.0
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
UMEE_WALLET="<YOUR_WALLET_NAME>"
UMEE_NODENAME="<YOUR_MONIKER>"
UMEE_CHAIN_ID="umee-1"
```

```
echo "
export UMEE_WALLET=${UMEE_WALLET}
export UMEE_NODENAME=${UMEE_NODENAME}
export UMEE_CHAIN_ID=${UMEE_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
umeed config chain-id ${UMEE_CHAIN_ID}
```

### Initialize your node
```
umeed init ${UMEE_NODENAME} --chain-id ${UMEE_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/umee-mainnet/genesis.json" > $HOME/.umee/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/umee-mainnet/addrbook.json" > $HOME/.umee/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
UMEE_PORT=<SET_CUSTOM_PORT> #Example: UMEE_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${UMEE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${UMEE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${UMEE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${UMEE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${UMEE_PORT}660\"%" /$HOME/.umee/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${UMEE_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${UMEE_PORT}317\"%; s%^address = \":8080\"%address = \":${UMEE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${UMEE_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${UMEE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${UMEE_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${UMEE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${UMEE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${UMEE_PORT}546\"%" /$HOME/.umee/config/app.toml
```


### Set seeds and peers
```
PEERS="109443243e1f2dc873b38de11bcdd6195143179f@umee-mainnet.peers.l0vd.com:10656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.umee/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.umee/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.2uumee\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.umee/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/umeed.service > /dev/null <<EOF
[Unit]
Description=Umee mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which umeed) start
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
sudo systemctl enable umeed
umeed tendermint unsafe-reset-all --home $HOME/.umee --keep-addr-book
sudo systemctl restart umeed && sudo journalctl -u umeed -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
umeed keys add ${UMEE_WALLET}
```
##### (OR)

#### 1. Recover your key
```
umeed keys add ${UMEE_WALLET} --recover
```

```
UMEE_WALLET_ADDR=$(umeed keys show ${UMEE_WALLET} -a)
echo "export UMEE_WALLET_ADDR=${UMEE_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
umeed tx staking create-validator \
--amount 1000000uumee \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(umeed tendermint show-validator) \
--moniker ${UMEE_NODENAME} \
--chain-id ${UMEE_CHAIN_ID} \
--from ${UMEE_WALLET_ADDR} \
--gas-prices 0.2uumee \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

## Set up Price-feeder

### Install price-feeder

```
cd $HOME
git clone https://github.com/ojo-network/price-feeder.git
cd price-feeder
git checkout umee/v2.1.6-1
make install
```

```
mkdir -p $HOME/umee-price-feeder
```

```
wget -O $HOME/umee-price-feeder/price-feeder.toml "https://raw.githubusercontent.com/ojo-network/price-feeder/umee/price-feeder.example.toml"
```

### Add price-feeder key

```
umeed keys add UMEE_PFD_WALLET
```


```
echo "
export UMEE_PFD_WALLET=$(umeed keys show UMEE_PFD_WALLET -a)
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Fund price-feeder wallet

### Set up variables

```
UMEE_KEYRING_PASS="xxxxxxxxx"
UMEE_GRPC_PORT="${UMEE_PORT}090"
UMEE_RPC_PORT="${UMEE_PORT}657"
UMEE_HOME="$HOME/.umee"
UMEE_VALOPER=$(umeed keys show $UMEE_WALLET_ADDR --bech val -a)
```

### Export variables

```
echo "
export UMEE_KEYRING_PASS=${UMEE_KEYRING_PASS}
export UMEE_GRPC_PORT=${UMEE_GRPC_PORT}
export UMEE_RPC_PORT=${UMEE_RPC_PORT}
export UMEE_HOME=${UMEE_HOME}
export UMEE_VALOPER=${UMEE_VALOPER}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Set up price-feeder config

```
sed -i "s/^listen_addr *=.*/listen_addr = \"0.0.0.0:7173\"/;\
s/^address *=.*/address = \"$UMEE_PFD_WALLET\"/;\
s/^chain_id *=.*/chain_id = \"umee-1\"/;\
s/^validator *=.*/validator = \"$UMEE_VALOPER\"/;\
s/^backend *=.*/backend = \"os\"/;\
s|^dir *=.*|dir = \"${UMEE_HOME}\"|;\
s|^pass *=.*|pass = \"${UMEE_KEYRING_PASS}\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${UMEE_GRPC_PORT}\"|;\
s|^tmrpc_endpoint *=.*|tmrpc_endpoint = \"http://localhost:${UMEE_RPC_PORT}\"|;\
s|^global-labels *=.*|global-labels = [[\"chain_id\", \"$UMEE_CHAIN_ID\"]]|;" $HOME/umee-price-feeder/price-feeder.toml
```

### Create price-feeder service

```
sudo tee /etc/systemd/system/price-feeder.service > /dev/null <<EOF
[Unit]
Description=umee-price-feeder
After=network.target
[Service]
User=$USER
Environment="PRICE_FEEDER_PASS=${UMEE_KEYRING_PASS}"
Type=simple
ExecStart=$(which price-feeder) $HOME/umee-price-feeder/price-feeder.toml --skip-provider-check --log-level debug
RestartSec=10
Restart=on-failure
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl enable price-feeder
```

### Delegate price-feeder

```
umeed tx oracle delegate-feed-consent $UMEE_WALLET_ADDR $UMEE_PFD_WALLET --fees 40000uumee
```

### Start price-feeder

```
sudo systemctl start price-feeder && journalctl -u price-feeder -f -o cat
```
