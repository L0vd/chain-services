## Manual node setup
If you want to setup Humans fullnode manually follow the steps below

### Update and upgrade
```
sudo apt update && sudo apt upgrade -y
```

### Install GO
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.18.3"
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
git clone https://github.com/humansdotai/humans
cd humans
git checkout v1.0.0
go build -o humansd cmd/humansd/main.go
mv humansd root/go/bin/humansd
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export HUMANS_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export HUMANS_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export HUMANS_CHAIN_ID="testnet-1"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
humansd config chain-id $HUMANS_CHAIN_ID
```

### Initialize your node
```
humansd init $HUMANS_NODENAME --chain-id $HUMANS_CHAIN_ID
```

### Download genesis and addrbook
```
wget -O $HOME/.humans/config/genesis.json "https://raw.githubusercontent.com/L0vd/chain-services/main/testnets/humans/installation-guide/genesis.json"
wget -O $HOME/.humans/config/addrbook.json "https://raw.githubusercontent.com/L0vd/chain-services/main/testnets/humans/installation-guide/addrbook.json"
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
HUMANS_PORT=<SET_CUSTOM_PORT> #Example: HUMANS_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${HUMANS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${HUMANS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${HUMANS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${HUMANS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${HUMANS_PORT}660\"%" $HOME/.humans/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${HUMANS_PORT}317\"%; s%^address = \":8080\"%address = \":${HUMANS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${HUMANS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${HUMANS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${HUMANS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${HUMANS_PORT}546\"%" $HOME/.humans/config/app.toml
```


### Set seeds and peers
```
SEEDS=""
PEERS="1df6735ac39c8f07ae5db31923a0d38ec6d1372b@45.136.40.6:26656,9726b7ba17ee87006055a9b7a45293bfd7b7f0fc@45.136.40.16:26656,6e84cde074d4af8a9df59d125db3bf8d6722a787@45.136.40.18:26656,eda3e2255f3c88f97673d61d6f37b243de34e9d9@45.136.40.13:26656,4de8c8acccecc8e0bed4a218c2ef235ab68b5cf2@45.136.40.12:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.humans/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.humans/config/app.toml
```

### Set minimum gas price and timeout commit
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uheart\"/" $HOME/.humans/config/app.toml
```

### Create Service
```
sudo tee /etc/systemd/system/humansd.service > /dev/null <<EOF
[Unit]
Description=Humans
After=network-online.target

[Service]
User=$USER
ExecStart=$(which humansd) start
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
sudo systemctl enable humansd
humansd tendermint unsafe-reset-all --home $HOME/.humans --keep-addr-book
sudo systemctl restart humansd && sudo journalctl -u humansd -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync guide](https://github.com/L0vd/Humans/tree/main/StateSync)


### Starting a validator

#### 1. Add a new key
```
humansd keys add $HUMANS_WALLET
```
##### (OR)

#### 1. Recover your key
```
humansd keys add $HUMANS_WALLET --recover
```

#### 2. Request tokens from [faucet](https://discord.com/channels/999302051538411671/1039540296540770385)

#### 3. Create validator
```
humansd tx staking create-validator \
--amount 9990000uheart \
--commission-max-change-rate "0.1" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(humansd tendermint show-validator) \
--moniker $HUMANS_NODENAME \
--chain-id $HUMANS_CHAIN_ID \
--gas-prices 0.025uheart \
--from $HUMANS_WALLET \
--gas-prices 0.1uheart\
--gas-adjustment 1.5 \
--gas auto \
--yes
```
