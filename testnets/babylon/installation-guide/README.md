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
If you want to setup Babylon fullnode manually follow the steps below

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
cd $HOME && rm -rf babylon
git clone https://github.com/babylonchain/babylon.git
cd babylon
git checkout v0.5.0
make install
```


## Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export BABYLON_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export BABYLON_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export BABYLON_CHAIN_ID="bbn-test1"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


## Configure your node
```
babylond config chain-id $BABYLON_CHAIN_ID
babylond config keyring-backend test
```

## Initialize your node
```
babylond init $BABYLON_NODENAME --chain-id $BABYLON_CHAIN_ID
```

## Download genesis
```
wget -O $HOME/.babylond/config/genesis.json "https://raw.githubusercontent.com/L0vd/Babylon/main/Node_installation_guide/genesis.json"
```

## (OPTIONAL) Set custom ports

### If you want to use non-default ports
```
BABYLON_PORT=<SET_CUSTOM_PORT> #Example: BABYLON_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BABYLON_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BABYLON_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BABYLON_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BABYLON_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BABYLON_PORT}660\"%" $HOME/.babylond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BABYLON_PORT}317\"%; s%^address = \":8080\"%address = \":${BABYLON_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BABYLON_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BABYLON_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BABYLON_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BABYLON_PORT}546\"%" $HOME/.babylond/config/app.toml
```


## Set seeds and peers
```
SEEDS="03ce5e1b5be3c9a81517d415f65378943996c864@18.207.168.204:26656,a5fabac19c732bf7d814cf22e7ffc23113dc9606@34.238.169.221:26656"
PEERS=""
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.babylond/config/config.toml
```

## Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.babylond/config/app.toml
```

## Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubbn\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.babylond/config/config.toml
```

## Change btc-network and btc-tag in app.toml file.
### Values specified here https://github.com/babylonchain/networks/tree/main/bbn-test1


## Create Service
```
sudo tee /etc/systemd/system/babylond.service > /dev/null <<EOF
[Unit]
Description=Babylon
After=network-online.target

[Service]
User=$USER
ExecStart=$(which babylond) start
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
sudo systemctl enable babylond
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book
sudo systemctl restart babylond && sudo journalctl -u babylond -f -o cat
```

<a name="state_sync"></a>
## (OPTIONAL) Use State Sync

### [State Sync guide](https://github.com/L0vd/Babylon/tree/main/StateSync)


<a name="starting_validator"></a>
## Starting a validator

### 1. Add a new key
```
babylond keys add $BABYLON_WALLET
```
#### (OR)

### 1. Recover your key
```
babylond keys add $BABYLON_WALLET --recover
```

### 2. Request tokens from [faucet](https://discord.com/channels/1046686458070700112/1075371070493831259)

### 3. Create a BLS key
```
babylond create-bls-key $(babylond keys show $BABYLON_WALLET -a)
```

### 4. Restart your node
```
systemctl restart babylond
```

### 5. Create validator
```
babylond tx checkpointing create-validator \
--amount 1ubbn \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(babylond tendermint show-validator) \
--moniker $BABYLON_NODENAME \
--chain-id $BABYLON_CHAIN_ID \
--fees=0ubbn\
--keyring-backend=test \
--from $BABYLON_WALLET \
--yes
```
<a name="useful_commands"></a>
## Useful commands

### Check status
```
babylond status | jq
```

### Check logs
```
sudo journalctl -u babylond -f
```

### Check wallets
```
babylond keys list
```

### Check balance
```
babylond q bank balances $BABYLON_WALLET
```

### Send tokens
```
babylond tx bank send <FROM_WALLET_ADDRESS> <TO_WALLET_ADDRESS> <AMOUNT>ubbn --fees 0ubbn
```

### Delegate tokens to validator
```
babylond tx staking delegate <MONIKER> <AMOUNT>ubbn --from $BABYLON_WALLET --chain-id $BABYLON_CHAIN_ID --fees 0ubbn
```

### Vote for proposal
#### Yes
```
babylond tx gov vote <PROPOSAL_NUMBER> yes --from $BABYLON_WALLET --chain-id $BABYLON_CHAIN_ID --fees 0ubbn
```
#### No
```
babylond tx gov vote <PROPOSAL_NUMBER> no --from $BABYLON_WALLET --chain-id $BABYLON_CHAIN_ID --fees 0ubbn
```
