## Manual node setup
If you want to setup Composable fullnode manually follow the steps below

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
rm -rf composable-centauri
git clone https://github.com/notional-labs/composable-centauri.git
cd composable-centauri
git checkout v2.3.5
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export COMPOSABLE_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export COMPOSABLE_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export COMPOSABLE_CHAIN_ID="centauri-1"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
banksyd config chain-id ${COMPOSABLE_CHAIN_ID}
```

### Initialize your node
```
banksyd init ${COMPOSABLE_NODENAME} --chain-id ${COMPOSABLE_CHAIN_ID}
```

### Download genesis
```
wget "$HOME/.banksy/config/genesis.json" "https://raw.githubusercontent.com/notional-labs/composable-networks/main/mainnet/genesis.json" 
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
COMPOSABLE_PORT=<SET_CUSTOM_PORT> #Example: COMPOSABLE_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:$"COMPOSABLE_PORT"658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:$"COMPOSABLE_PORT"657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:$"COMPOSABLE_PORT"060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:$"COMPOSABLE_PORT"656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":$"COMPOSABLE_PORT"660\"%" $HOME/.banksy/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:$"COMPOSABLE_PORT"317\"%; s%^address = \":8080\"%address = \":$"COMPOSABLE_PORT"080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:$"COMPOSABLE_PORT"090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:$"COMPOSABLE_PORT"091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:$"COMPOSABLE_PORT"545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:$"COMPOSABLE_PORT"546\"%" $HOME/.banksy/config/app.toml
```


### Set seeds and peers
```
PEERS="253f190c96d14ce98da8b7596385c1593a7be982@composable-mainnet.rpc.l0vd.com:23656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.banksy/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.banksy/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ppica\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.banksy/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/banksyd.service > /dev/null <<EOF
[Unit]
Description=Composable mainnet
After=network-online.target

[Service]
User=$USER
ExecStart=$(which banksyd) start
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
sudo systemctl enable banksyd
banksyd tendermint unsafe-reset-all --home $HOME/.banksy --keep-addr-book
sudo systemctl restart banksyd && sudo journalctl -u banksyd -f -o cat
```

### (OPTIONAL) Use State Sync

### Starting a validator

#### 1. Add a new key
```
banksyd keys add ${COMPOSABLE_WALLET}
```
##### (OR)

#### 1. Recover your key
```
banksyd keys add ${COMPOSABLE_WALLET} --recover
```



### 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
banksyd tx staking create-validator \
--amount 1000000ppica \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(banksyd tendermint show-validator) \
--moniker ${COMPOSABLE_NODENAME} \
--chain-id ${COMPOSABLE_CHAIN_ID} \
--from ${COMPOSABLE_WALLET} \
--gas-prices 0.1ppica \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

