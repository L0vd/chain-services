<p style="font-size:14px" align="right">
<a href="https://t.me/L0vd_staking" target="_blank">Join our telegram <img src="https://raw.githubusercontent.com/L0vd/screenshots/main/Telegram_logo.png" width="30"/></a>
<a href="https://l0vd.com/" target="_blank">Visit our website <img src="https://raw.githubusercontent.com/L0vd/screenshots/main/L0vd.png" width="30"/></a>
</p>



# Table of contents <br />
[Node setup](#node_setup) <br />
[State Sync](#state_sync) <br />
[Starting a validator](#starting_validator) <br />
[Useful commands](#useful_commands)



<a name="node_setup"></a>
# Manual node setup
If you want to setup Nois fullnode manually follow the steps below

## Update and upgrade
```
sudo apt update && sudo apt upgrade -y
```

## Install GO
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

## Install node
```
cd $HOME
git clone https://github.com/noislabs/noisd
cd noisd
git checkout v1.0.1
make install
```


## Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export NOIS_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export NOIS_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export NOIS_CHAIN_ID="nois-testnet-005"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


## Configure your node
```
noisd config chain-id $NOIS_CHAIN_ID
```

## Initialize your node
```
noisd init $NODENAME --chain-id $CHAIN_ID
```

## Download genesis
```
wget -O "$HOME/.noisd/config/genesis.json" https://raw.githubusercontent.com/noislabs/testnets/main/nois-testnet-003/genesis.json
```

## (OPTIONAL) Set custom ports

### If you want to use non-default ports
```
NOIS_PORT=<SET_CUSTOM_PORT> #Example: NOIS_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${NOIS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${NOIS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${NOIS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${NOIS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${NOIS_PORT}660\"%" $HOME/.noisd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${NOIS_PORT}317\"%; s%^address = \":8080\"%address = \":${NOIS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${NOIS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${NOIS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${NOIS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${NOIS_PORT}546\"%" $HOME/.noisd/config/app.toml
```


## Set seeds and peers
```
SEEDS=""
PEERS="3aa7f66499a700625056b674bf26d4f457dc38da@95.216.2.219:28656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.noisd/config/config.toml
```

## Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.noisd/config/app.toml
```

## Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unois\"/" $HOME/.noisd/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.noisd/config/config.toml
```

## Create Service
```
sudo tee /etc/systemd/system/noisd.service > /dev/null <<EOF
[Unit]
Description=Lava
After=network-online.target

[Service]
User=$USER
ExecStart=$(which noisd) start
Restart=on-failure
RestartSec=3
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

## Reset blockchain info and restart your node
```
sudo systemctl daemon-reload
sudo systemctl enable noisd
noisd tendermint unsafe-reset-all --home $HOME/.noisd --keep-addr-book
sudo systemctl restart noisd && sudo journalctl -u noisd -f -o cat
```

<a name="state_sync"></a>
## (OPTIONAL) Use State Sync

### [State Sync guide](https://github.com/L0vd/Nois/tree/main/StateSync)


<a name="starting_validator"></a>
## Starting a validator

### 1. Add a new key
```
noisd keys add $NOIS_WALLET
```
#### (OR)

### 1. Recover your key
```
noisd keys add $NOIS_WALLET --recover
```

### 2. Request tokens from [faucet](https://discord.com/channels/1007329761229545512/1025144166117814404)

### 3. Create validator
```
noisd tx staking create-validator \
--amount 1000000unois \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(noisd tendermint show-validator) \
--moniker $NOIS_NODENAME \
--chain-id $NOIS_CHAIN_ID \
--gas-prices 0.025unois \
--from $NOIS_WALLET \
--yes
```
<a name="useful_commands"></a>
## Useful commands

### Check status
```
noisd status | jq
```

### Check logs
```
sudo journalctl -u noisd -f
```

### Check wallets
```
noisd keys list
```

### Check balance
```
noisd q bank balances $NOIS_WALLET
```

### Send tokens
```
noisd tx bank send <FROM_WALLET_ADDRESS> <TO_WALLET_ADDRESS> <AMOUNT>unois --fees 0unois
```

### Delegate tokens to validator
```
noisd tx staking delegate <MONIKER> <AMOUNT>unois --from $NOIS_WALLET --chain-id $NOIS_CHAIN_ID --fees 0unois
```

### Vote for proposal
#### Yes
```
noisd tx gov vote <PROPOSAL_NUMBER> yes --from $NOIS_WALLET --chain-id $NOIS_CHAIN_ID --fees 0unois
```
#### No
```
noisd tx gov vote <PROPOSAL_NUMBER> no --from $NOIS_WALLET --chain-id $NOIS_CHAIN_ID --fees 0unois
```
