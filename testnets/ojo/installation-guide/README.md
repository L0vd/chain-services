## Manual node setup
If you want to setup Ojo fullnode manually follow the steps below

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
git clone https://github.com/ojo-network/ojo.git
cd ojo
git checkout v0.1.2
make install
```


### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
echo "export OJO_WALLET="<YOUR_WALLET_NAME>"" >> $HOME/.bash_profile
echo "export OJO_NODENAME="<YOUR_MONIKER>"" >> $HOME/.bash_profile
echo "export OJO_CHAIN_ID="ojo-devnet"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```


### Configure your node
```
ojod config chain-id $OJO_CHAIN_ID
```

### Initialize your node
```
ojod init $OJO_NODENAME --chain-id $OJO_CHAIN_ID
```

### Download genesis
```
wget "$HOME/.ojo/config/genesis.json" https://raw.githubusercontent.com/L0vd/chain-services/main/testnets/ojo/installation-guide/genesis.json
```

### (OPTIONAL) Set custom ports

#### If you want to use non-default ports
```
OJO_PORT=<SET_CUSTOM_PORT> #Example: OJO_PORT=56 (numbers from 1 to 64)
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OJO_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OJO_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OJO_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OJO_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OJO_PORT}660\"%" $HOME/.ojo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OJO_PORT}317\"%; s%^address = \":8080\"%address = \":${OJO_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OJO_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OJO_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OJO_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OJO_PORT}546\"%" $HOME/.ojo/config/app.toml
```


### Set seeds and peers
```
SEEDS=""
PEERS="d2beb0153f6ee3d2a5a90f96848c71bff2b25eb0@65.109.90.171:36656,978cf9aca38f819fd8189272379fc3c2ae2682a8@213.239.218.210:56656,b2291ae6c53a078f414f5652b37ecf59b6eabb09@91.107.237.224:26656,d1c5c6bf4641d1800e931af6858275f08c20706d@23.88.5.169:18656,a98484ac9cb8235bd6a65cdf7648107e3d14dab4@116.202.231.58:50656,d5519e378247dfb61dfe90652d1fe3e2b3005a5b@65.109.68.190:50656,0ccc4bd8386fbec1421e3c19c24124eeb00b3293@46.101.144.90:28656,d5b2ae8815b09a30ab253957f7eca052dde3101d@65.108.9.164:24656,3d11a6c7a5d4b3c5752be0c252c557ed4acc2c30@167.235.57.142:36656,e052b7c899bae41f6d89f70f81de50e28b72a7bf@38.242.237.100:26656"
sed -i -e "s/^seeds *=.*/seeds = \"$SEEDS\"/; s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.ojo/config/config.toml
```

### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ojo/config/app.toml
```

### Set minimum gas price and null indexer
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uojo\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.ojo/config/config.toml
```

### Create Service
```
sudo tee /etc/systemd/system/ojod.service > /dev/null <<EOF
[Unit]
Description=Ojo
After=network-online.target

[Service]
User=$USER
ExecStart=$(which ojod) start
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
sudo systemctl enable ojod
ojod tendermint unsafe-reset-all --home $HOME/.ojo --keep-addr-book
sudo systemctl restart ojod && sudo journalctl -u ojod -f -o cat
```

### (OPTIONAL) Use State Sync

#### [State Sync]()


### Starting a validator

#### 1. Add a new key
```
ojod keys add $OJO_WALLET
```
##### (OR)

#### 1. Recover your key
```
ojod keys add $OJO_WALLET --recover
```

#### 2. Request tokens from faucet


### 3. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
ojod tx staking create-validator \
--amount 1000000uojo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--details "" \
--pubkey=$(ojod tendermint show-validator) \
--moniker $OJO_NODENAME \
--chain-id $OJO_CHAIN_ID \
--from $OJO_WALLET \
--gas-prices 0.1uojo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```

### 4. Price-feeder setup

{% hint style="info" %}
Not running a price-feeder would result in being jailed! To run price-feeder you must be in active set.
{% endhint %}

#### Install price-feeder binary
```
cd $HOME
git clone https://github.com/ojo-network/price-feeder
cd price-feeder
git checkout v0.1.1
make install
```

#### Add wallet for price-feeder
```
ojod keys add pfd_wallet --keyring-backend os
```

{% hint style="info" %}
You must fund this wallet with some uojo tokens.
{% endhint %}

#### Set up password for price-feeder
```
OJO_PFD_PASS="<INSERT YOUR PASSWORD FROM pfd_wallet YOU CREATED IN PREVIOUS STEP>"
```

#### Set up variables
```
echo "export OJO_VALIDATOR_ADDRESS=$(ojod keys show $OJO_WALLET --bech val -a)" >> $HOME/.bash_profile
echo "export OJO_MAIN_WALLET_ADDRESS=$(ojod keys show $OJO_WALLET -a)" >> $HOME/.bash_profile
echo "export OJO_PFD_ADDRESS=$(ojod keys show pfd_wallet -a)" >> $HOME/.bash_profile
echo "export OJO_RPC_PORT=${OJO_PORT}657" >> $HOME/.bash_profile
echo "export OJO_GRPC_PORT=${OJO_PORT}090" >> $HOME/.bash_profile
echo "export OJO_PFD_LISTEN_PORT=7172" >> $HOME/.bash_profile
echo "export OJO_KEYRING="os"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### Remove data from price-feeder dir and move price-feeder config
```
rm $HOME/.ojo-price-feeder -rf
mkdir $HOME/.ojo-price-feeder_config
mv $HOME/price-feeder/price-feeder.example.toml $HOME/.ojo-price-feeder-config/config.toml
```

#### Set values in price-feeder config.toml
```
sed -i "s/^address *=.*/address = \"$OJO_PFD_ADDRESS\"/;\
s/^chain_id *=.*/chain_id = \"$OJO_CHAIN_ID\"/;\
s/^validator *=.*/validator = \"$OJO_VALIDATOR_ADDRESS\"/;\
s/^backend *=.*/backend = \"$OJO_KEYRING\"/;\
s|^dir *=.*|dir = \"$HOME/.ojo\"|;\
s|^pass *=.*|pass = \"$OJO_PFD_PASS\"|;\
s|^grpc_endpoint *=.*|grpc_endpoint = \"localhost:${OJO_GRPC_PORT}\"|;\
s|^service-name *=.*|service-name = \"ojo-price-feeder\"|;" $HOME/.ojo-price-feeder-config/config.toml
```

#### Delegate price-feeder rights to pfd_wallet
```
ojod tx oracle delegate-feed-consent $OJO_MAIN_WALLET_ADDRESS $OJO_PFD_ADDRESS --from $OJO_WALLET --gas-adjustment 1.5 --gas auto --gas-prices 0.1uojo --yes
```

#### Create Service File for ojo-price-feeder
```
sudo tee /etc/systemd/system/ojo-price-feeder.service > /dev/null <<EOF
[Unit]
Description=Ojo_price_feeder
After=network-online.target

[Service]
User=$USER
ExecStart=$(which price-feeder) $HOME/.ojo-price-feeder-config/config.toml
Restart=on-failure
RestartSec=30
LimitNOFILE=65535
Environment="PRICE_FEEDER_PASS=$OJO_PFD_PASS"

[Install]
WantedBy=multi-user.target
EOF
```

#### Enable and start price-feeder service
```
sudo systemctl daemon-reload
sudo systemctl enable ojo-price-feeder
sudo systemctl restart ojo-price-feeder
```

#### Check price-feeder logs to make sure it's operating 
```
sudo journalctl -u ojo-price-feeder -f
```

Your output should be like this and contain "successfully broadcasted tx" phrase

```
9:16PM INF broadcasting vote exchange_rates=ATOM:10.661720568811112843,USDT:1.000353934759403065 feeder=ojo1yp40atwuagh34lj5rt3z79pcn92r2322rvkmyl module=oracle validator=ojovaloper1n2v9c342a6zj94l5gawtktny03268epnfx0hdw
9:16PM INF successfully broadcasted tx module=oracle_client tx_code=0 tx_hash=7D562CB44C6D1C3BC0D527C58F9AB4354E63E0440210023FF8A43D6CB485F60D tx_height=0
```
