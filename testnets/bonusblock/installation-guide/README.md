## Manual node setup
If you want to setup Bonusblock fullnode manually follow the steps below

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
rm -rf BonusBlock-chain/
git clone https://github.com/BBlockLabs/BonusBlock-chain
cd BonusBlock-chain/
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export BBLOCK_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export BBLOCK_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export BBLOCK_CHAIN_ID="blocktopia-01"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
bonus-blockd config chain-id $BBLOCK_CHAIN_ID
```

### Initialize your node
```
bonus-blockd init $BBLOCK_NODENAME --chain-id $BBLOCK_CHAIN_ID
```

### Download genesis
```
wget "$HOME/.bonusblock/config/genesis.json" https://ss-t.bonusblock.nodestake.top/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
BBLOCK_PORT=<SET_CUSTOM_PORT> #Example: BBLOCK_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BBLOCK_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BBLOCK_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BBLOCK_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BBLOCK_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BBLOCK_PORT}660\"%" $HOME/.bonusblock/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BBLOCK_PORT}317\"%; s%^address = \":8080\"%address = \":${BBLOCK_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BBLOCK_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BBLOCK_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BBLOCK_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BBLOCK_PORT}546\"%" $HOME/.bonusblock/config/app.toml
```


### Set seeds and peers
```
PEERS="e5e04918240cfe63e20059a8abcbe62f7eb05036@bonusblock-testnet-p2p.alter.network:26656,6ae1dfa46884560e13962d73462e5bda0bb8c019@bonusblock-testnet.peers.l0vd.com:17656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.bonusblock/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.bonusblock/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubonus\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.bonusblock/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/bonus-blockd.service > /dev/null <<EOF
[Unit]
Description=Bonusblock
After=network-online.target

[Service]
User=$USER
ExecStart=$(which bonus-blockd) start
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
sudo systemctl enable bonus-blockd
bonus-blockd tendermint unsafe-reset-all --home $HOME/.bonusblock --keep-addr-book
sudo systemctl restart bonus-blockd && sudo journalctl -u bonus-blockd -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
bonus-blockd keys add $BBLOCK_WALLET
```
##### (OR)

#### 1. Recover your key
```
bonus-blockd keys add $BBLOCK_WALLET --recover
```

#### 2. Request tokens from [faucet](https://docs.bonusblock.io/docs/becoming-a-validator/testnet-faucet)


### 3. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
bonus-blockd tx staking create-validator \
--amount 1000000ubonus \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(bonus-blockd tendermint show-validator) \
--moniker $BBLOCK_NODENAME \
--chain-id $BBLOCK_CHAIN_ID \
--from $BBLOCK_WALLET \
--gas-prices 0.1ubonus \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
