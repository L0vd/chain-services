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
git checkout v5.0.1
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export UMEE_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export UMEE_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export UMEE_CHAIN_ID="canon-3"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
umeed config chain-id $UMEE_CHAIN_ID
```

### Initialize your node
```
umeed init $UMEE_NODENAME --chain-id $UMEE_CHAIN_ID
```

### Download genesis
```
curl https://canon-3.rpc.network.umee.cc/genesis | jq .result.genesis > $HOME/.umee/config/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
UMEE_PORT=<SET_CUSTOM_PORT> #Example: UMEE_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${UMEE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${UMEE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${UMEE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${UMEE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${UMEE_PORT}660\"%" $HOME/.umee/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${UMEE_PORT}317\"%; s%^address = \":8080\"%address = \":${UMEE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${UMEE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${UMEE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${UMEE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${UMEE_PORT}546\"%" $HOME/.umee/config/app.toml
```


### Set seeds and peers
```
PEERS="c054701ade2bdbeb61c4a8800450da744e252506@umee-testnet.peers.l0vd.com:11656"
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.1uumee\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.umee/config/config.toml
sed -i '/\[mempool\]/, /^version =/ s/=.*/= "v1"/' $UMEE_HOME/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/umeed.service > /dev/null <<EOF
[Unit]
Description=Umee_testnet
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


### Starting a validator

#### 1. Add a new key
```
umeed keys add $UMEE_WALLET
```
##### (OR)

#### 1. Recover your key
```
umeed keys add $UMEE_WALLET --recover
```

#### Use faucet
https://faucet.umee.cc/

### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
umeed tx staking create-validator \
--amount 10000000uumee \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(umeed tendermint show-validator) \
--moniker $UMEE_NODENAME \
--chain-id $UMEE_CHAIN_ID \
--from $UMEE_WALLET \
--gas-prices 0.1uumee \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

## Set up Peggo

### Install peggo

```
cd $HOME
git clone https://github.com/umee-network/peggo.git
cd peggo
git checkout v1.4.0
make install
```

### Create orchestrator key

```
umeed keys add UMEE_ORCH_WALLET 
```

### Fund orchestrator wallet


### Set up variables for peggo

```
UMEE_ORCH_ADDR=$(umeed keys show UMEE_ORCH_WALLET -a)
UMEE_KEYRING="os"
UMEE_KEYRING_PASS="xxxxxxxxx"
UMEE_GRPC_PORT="${UMEE_PORT}090"
UMEE_RPC_PORT="${UMEE_PORT}657"
UMEE_HOME="$HOME/.umee"
UMEE_VALOPER=$(umeed keys show $UMEE_WALLET --bech val -a)
```

```
UMEE_PEGGO_ETH_ADDR="<ENTER YOUR PEGGO ETH ADDRESS HERE>"
```

```
UMEE_PEGGO_ETH_PK="<ENTER YOUR PEGGO ETH ADDRESS PRIVATE KEY HERE>"
```

Add ETH Endpoints
```
ETH_RPC="https://goerli.infura.io/v3/xxxxxxxxxxxxxxxxxxxxxxxxxxxx"
ALCHEMY_ENDPOINT="wss://eth-goerli.g.alchemy.com/v2/xxxxxxxxxxxxxxxxxxxxxxxxx"
```

### Export variables

```
echo "
export UMEE_KEYRING=${UMEE_KEYRING}
export UMEE_KEYRING_PASS=${UMEE_KEYRING_PASS}
export UMEE_GRPC_PORT=${UMEE_GRPC}
export UMEE_RPC_PORT=${UMEE_RPC}
export UMEE_PEGGO_ETH_ADDR=${UMEE_PEGGO_ETH_ADDR}
export UMEE_ORCH_ADDR=${UMEE_ORCH_ADDR}
export UMEE_HOME=${UMEE_HOME}
export UMEE_VALOPER=${UMEE_VALOPER}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```

### Create peggo service

```
sudo tee /etc/systemd/system/peggod.service > /dev/null <<EOF
[Unit]
Description=Umee Peggo Service
After=network.target
[Service]
User=$USER
Type=simple
ExecStart=$(which peggo) orchestrator 0x36D61fF14e4A2FcC3aF6813edE3F0Ce244026b69 \
  --eth-rpc="${ETH_RPC}" \
  --relay-batches=true \
  --valset-relay-mode=minimum \
  --cosmos-gas-prices="0.1uumee" \
  --cosmos-chain-id="${UMEE_CHAIN_ID}" \
  --cosmos-keyring-dir="${UMEE_HOME}" \
  --cosmos-keyring="${UMEE_KEYRING}" \
  --cosmos-from="${UMEE_ORCH_WALLET}" \
  --cosmos-from-passphrase="${UMEE_KEYRING_PASS}" \
  --cosmos-grpc="tcp://localhost:${UMEE_GRPC_PORT}" \
  --tendermint-rpc="tcp://localhost:${UMEE_RPC_PORT}" \
  --eth-alchemy-ws="${ALCHEMY_ENDPOINT}" \
  --log-level debug \
  --log-format text
Environment="PEGGO_ETH_PK=${UMEE_PEGGO_ETH_PK}"
Restart=on-failure
RestartSec=10
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

```
sudo systemctl daemon-reload
sudo systemctl enable peggod
```

### Set orchestrator address

```
umeed tx gravity set-orchestrator-address $UMEE_VALOPER $UMEE_ORCH_ADDR $UMEE_PEGGO_ETH_ADDR --from $UMEE_WALLET --chain-id $UMEE_CHAIN_ID  --fees 40000uumee
```

### Run peggo

```
sudo systemctl start peggod && journalctl -u peggod -f -o cat
```


## Set up Price-feeder

### Install price-feeder

```
cd $HOME
git clone https://github.com/ojo-network/price-feeder.git
cd price-feeder
git checkout umee/v2.1.4
make install
```

```
mkdir -p $HOME/umee-price-feeder
```

```
wget -O $HOME/umee-price-feeder/price-feeder.toml "https://raw.githubusercontent.com/ojo-network/price-feeder/83c49fea9824152120ab79708e6cd1ced1c3e89e/price-feeder.example.toml"
```

### Add price-feeder key

```
umeed keys add UMEE_PFD_WALLET
```


```
echo "
export UMEE_PFD_WALLET=$(umeed keys show UMEE_ORCH_WALLET -a)
" >> $HOME/.bash_profile
```

### Fund price-feeder wallet

### Set up price-feeder config

```
sed -i "s/^listen_addr *=.*/listen_addr = \"0.0.0.0:7173\"/;\
s/^address *=.*/address = \"$UMEE_PFD_WALLET\"/;\
s/^chain_id *=.*/chain_id = \"$UMEE_CHAIN_ID\"/;\
s/^validator *=.*/validator = \"$UMEE_VALOPER\"/;\
s/^backend *=.*/backend = \"os\"/;\
s|^dir *=.*|dir = \"${UMEE_HOME}\"|;\
s|^pass *=.*|pass = \"${UMEE_KEYRING_PASS}\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${UMEE_GRPC_PORT}090\"|;\
s|^tmrpc_endpoint *=.*|tmrpc_endpoint = \"http://${UMEE_GRPC_PORT}657\"|;\
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
umeed tx oracle delegate-feed-consent $UMEE_WALLET $UMEE_PFD_WALLET --fees 40000uumee
```

### Start price-feeder

```
sudo systemctl start price-feeder && journalctl -u price-feeder -f -o cat
```
