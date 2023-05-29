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
git clone https://github.com/notional-labs/composable-testnet.git
cd composable-testnet
git checkout v2.3.3-testnet2fork
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export BANKSY_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export BANKSY_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export BANKSY_CHAIN_ID="banksy-testnet-2"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
banksyd config chain-id $BANKSY_CHAIN_ID
```

### Initialize your node
```
banksyd init $BANKSY_NODENAME --chain-id $BANKSY_CHAIN_ID
```

### Download genesis
```
wget "https://raw.githubusercontent.com/notional-labs/composable-networks/main/testnet-2/genesis.json" 
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
BANKSY_PORT=<SET_CUSTOM_PORT> #Example: BANKSY_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BANKSY_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BANKSY_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BANKSY_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BANKSY_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BANKSY_PORT}660\"%" $HOME/.banksy/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BANKSY_PORT}317\"%; s%^address = \":8080\"%address = \":${BANKSY_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BANKSY_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BANKSY_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BANKSY_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BANKSY_PORT}546\"%" $HOME/.banksy/config/app.toml
```


### Set seeds and peers
```
PEERS="a8da45683cc35c4743e27eac5e2d33498b7a700d@65.108.225.126:56656,06206d0f5afb5b6d9d1c4efdd9b753da2553fa4f@96.234.160.22:30456,c4c51318e4d9a863c019fb277e5ed6748590e5c6@66.45.233.110:26657,7a4247261bad16289428543538d8e7b0c785b42c@135.181.22.94:26656,1d1b341ee37434cbcf23231d89fa410aeb970341@65.108.206.74:36656,73190b1ec85654eeb7ccdc42538a2bb4a98b2802@194.163.165.176:46656,a03d37eb137b4825da89183c3a1cc85b30541040@195.3.220.169:26656,837d9bf9a4ce4d8fd0e7b0cbe51870a2fa29526a@65.109.85.170:58656,f9cf7b4b1df105e67c632364847a4a00f86aa5c8@93.115.28.169:36656,55809d43e11bd97904a24c380968b414243fa247@65.109.154.182:47656,829fe9bab86000a420d00292c5e83fc1c3961d94@65.108.206.118:60756,085e6b4cf1f1d6f7e2c0b9d06d476d070cbd7929@banksy.sergo.dev:11813,a2041248892180f37fd8e8fe21d7d6b1972efa41@65.21.139.155:32656,b3df58870bc6ff98a88cae66f6eb616198c3b118@144.76.45.59:26656,3c091edbe051f9b0e1bcf46200db163e667a114a@65.108.129.94:26656,d9b5a5910c1cf6b52f79aae4cf97dd83086dfc25@65.108.229.93:27656,8ef48cb0abd32aba27e0b7dea59d625afae99028@65.21.5.205:26656,f42036053761675bc7ad48c4b1510e67254d9e24@65.109.28.226:20656,561b5acc7d6ae8994442855aac6b9a2ea94970d1@5.161.97.184:26656,a117b8ea8b909cb9a62ac0734e0e83787939a298@178.63.52.213:26656,81a92793f2e3266e45d304d5325905e0e587e0b7@65.109.61.113:26656,d0f54e60e10ca4d657b48c9cfc5549fb2a8c7a96@65.109.31.55:26656,18f86a7b2b8233e340b85733b77c649daa2533dc@138.201.59.93:26656,7b8f4a6d2aedf1d300edd447b5020ea174376f03@65.108.231.238:26677,32dfb88dbfae25475202c20adcdcca720f7268c9@65.21.200.161:15956,b3c715e6d140ea5de371db8bab081cb9923f45b2@65.108.78.107:26656,e8ff96b052acfc2cc10458fa163dc733a8328ae1@109.236.86.96:15956,ca63700c8a456548ebeb9859e73e7fc03cfa273b@peer1.apeironnodes.com:44003,
8dc332a8cfff6c349374244303ae0c856681bb83@composable-testnet-2.peers.l0vd.com:20656"
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
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0upica\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.banksy/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/banksyd.service > /dev/null <<EOF
[Unit]
Description=Composable-testnet-2
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

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
banksyd keys add $BANKSY_WALLET
```
##### (OR)

#### 1. Recover your key
```
banksyd keys add $BANKSY_WALLET --recover
```

#### 2. Request tokens from [faucet](https://discord.com/channels/828751308060098601/1095204570378022952)


### 3. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
banksyd tx staking create-validator \
--amount 1000000upica \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(banksyd tendermint show-validator) \
--moniker $BANKSY_NODENAME \
--chain-id $BANKSY_CHAIN_ID \
--from $BANKSY_WALLET \
--gas-prices 0.1upica \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
