## Manual node setup
If you want to setup Mantra fullnode manually follow the steps below

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
mkdir -p $HOME/go/bin/
wget https://github.com/MANTRA-Finance/public/raw/main/mantrachain-testnet/mantrachaind-linux-amd64.zip
unzip mantrachaind-linux-amd64.zip
rm mantrachaind-linux-amd64.zip
mv mantrachaind $HOME/go/bin/
sudo wget -P /usr/lib https://github.com/CosmWasm/wasmvm/releases/download/v1.3.0/libwasmvm.x86_64.so

mantrachaind version
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
MANTRA_WALLET="<YOUR_WALLET_NAME>"
MANTRA_NODENAME="<YOUR_MONIKER>"
MANTRA_CHAIN_ID="mantrachain-1"
```

```
echo "
export MANTRA_WALLET=${MANTRA_WALLET}
export MANTRA_NODENAME=${MANTRA_NODENAME}
export MANTRA_CHAIN_ID=${MANTRA_CHAIN_ID}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### Configure your node
```
mantrachaind config chain-id ${MANTRA_CHAIN_ID}
```

### Initialize your node
```
mantrachaind init ${MANTRA_NODENAME} --chain-id ${MANTRA_CHAIN_ID}
```

### Download genesis & addrbook
```
curl -Ls "https://snapshots.l0vd.com/axelar-mainnet/genesis.json" > $HOME/.mantrachain/config/genesis.json
curl -Ls "https://snapshots.l0vd.com/axelar-mainnet/addrbook.json" > $HOME/.mantrachain/config/addrbook.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
MANTRA_PORT=<SET_CUSTOM_PORT> #Example: MANTRA_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${MANTRA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${MANTRA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${MANTRA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${MANTRA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${MANTRA_PORT}660\"%" /$HOME/.mantrachain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${MANTRA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${MANTRA_PORT}317\"%; s%^address = \":8080\"%address = \":${MANTRA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${MANTRA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${MANTRA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${MANTRA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${MANTRA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${MANTRA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${MANTRA_PORT}546\"%" /$HOME/.mantrachain/config/app.toml
```
```
mantrachaind config node tcp://localhost:${MANTRA_PORT}657
```

### Set seeds and peers
```
PEERS="8df752df7047a8dabf89f8a01e2c1235f86283b8@mantra-testnet.peers.l0vd.com:24656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.mantrachain/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mantrachain/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uaum\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.mantrachain/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/mantrachaind.service > /dev/null <<EOF
[Unit]
Description=Mantra testnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which mantrachaind) start
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
sudo systemctl enable mantrachaind
mantrachaind tendermint unsafe-reset-all --home $HOME/.mantrachain --keep-addr-book
sudo systemctl restart mantrachaind && sudo journalctl -u mantrachaind -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
mantrachaind keys add ${MANTRA_WALLET}
```
##### (OR)

#### 1. Recover your key
```
mantrachaind keys add ${MANTRA_WALLET} --recover
```

```
MANTRA_WALLET_ADDR=$(mantrachaind keys show ${MANTRA_WALLET} -a)
echo "export MANTRA_WALLET_ADDR=${MANTRA_WALLET_ADDR}" >> $HOME/.bash_profile

source $HOME/.bash_profile
```


### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
mantrachaind tx staking create-validator \
--amount 1000000uaum \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey $(mantrachaind tendermint show-validator) \
--moniker ${MANTRA_NODENAME} \
--chain-id ${MANTRA_CHAIN_ID} \
--from ${MANTRA_WALLET_ADDR} \
--gas-prices 0uaum \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

