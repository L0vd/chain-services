
## System requirements

{% hint style="info" %} Ubuntu must be 22.04 or newer. {% endhint %}

| Node | RAM | DRIVE | CPU |
| ------ | ------ |
| Validator node | 16GB | 1TB | 4cores |
| Full node | 8GB | 1TB | 2cores |
| Light Node | TBD | TBD | TBD |


## Full Node Setup

### 1. Using our auto-installation script

```
. <(wget -qO- https://raw.githubusercontent.com/L0vd/chain-services/main/testnets/namada-se/installation-guide/one-liner.sh)
```

Wait until the script completes successfully and then go to [step 3](/testnets/namada-se/installation-guide/README.md#3-adding-wallets).

### 2. Manual installation

#### 2.1 Set up variables

```
CHAIN_ID="shielded-expedition.b40d8e9055"
WALLET_ALIAS="<SET YOUR WALLET ALIAS>"
VALIDATOR_ALIAS="<SET YOUR VALIDATOR ALIAS>"
```

Export variables:
```
echo "export WALLET_ALIAS="$WALLET_ALIAS"" >> $HOME/.bash_profile
echo "export VALIDATOR_ALIAS="$VALIDATOR_ALIAS"" >> $HOME/.bash_profile
echo "export WORKING_DIR="$HOME/.local/share/namada"" >> $HOME/.bash_profile
echo "export PUBLIC_IP=$(wget -qO- eth0.me)" >> $HOME/.bash_profile
echo "export CHAIN_ID="$CHAIN_ID"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### 2.2 Install prerequisites


Update packages and install dependencies:

```
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y curl git jq lz4 make git-core libssl-dev pkg-config libclang-12-dev build-essential protobuf-compiler
```

Install Go:

```
sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go1.20.10.linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

```

Install Rust:

```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env
```

Install CometBFT:

```
cd $HOME
rm -rf cometbft
git clone https://github.com/cometbft/cometbft.git
cd cometbft
git checkout v0.37.2
make build
sudo cp $HOME/cometbft/build/cometbft /usr/local/bin/
cometbft version
```

#### 2.3 Install Namada binary

```
cd $HOME
rm -rf namada
git clone https://github.com/anoma/namada
cd namada
wget https://github.com/anoma/namada/releases/download/v0.31.0/namada-v0.31.0-Linux-x86_64.tar.gz
tar -xvf namada-v0.31.0-Linux-x86_64.tar.gz
rm namada-v0.31.0-Linux-x86_64.tar.gz
cd namada-v0.31.0-Linux-x86_64
sudo mv namad* /usr/local/bin/
if [ ! -d "$WORKING_DIR" ]; then
    mkdir -p "$WORKING_DIR"
fi
```

Check namada version:

```
namada --version
```

#### 2.4 Initialize the chain configuration 

For genesis validators:
```
namada client utils join-network --chain-id $CHAIN_ID --genesis-validator $VALIDATOR_ALIAS
```

For post-genesis validators and Full nodes:
```
namada client utils join-network --chain-id $CHAIN_ID
```

Check everything works fine :

```
namadac epoch
```

Output should be like: "Last committed epoch: 150"

#### 2.5 Create service file
```
sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=namada
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$WORKING_DIR
Environment=TM_LOG_LEVEL=p2p:none,pex:error
Environment=NAMADA_CMT_STDOUT=true
Environment=NAMADA_LOG=info
ExecStart=$(which namada) node ledger run
StandardOutput=syslog
StandardError=syslog
Restart=always
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF
```

#### 2.6 Start a node
```
sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl restart namadad && sudo journalctl -u namadad -f
```

## 3. Adding wallets

### 3.1 Add new keypair (or restore)

```
namada wallet gen --alias $WALLET_ALIAS
```

or restore:

```
namada wallet derive --alias $WALLET_ALIAS --hd-path default
```

### 3.2 Check keys

```
namada wallet find --alias $WALLET_ALIAS
```

{% hint style="info" %} Wait until the node is synchronized. {% endhint %}

Command to check your node status ("latest_block_height" should be not 0 and "catching up" - false):
```
curl localhost:26657/status | jq 
```

### 3.3 Check key balance

```
namada client balance --owner $WALLET_ALIAS
```

## 4. Validator Setup

{% hint style="info" %} Following validator setup is optional for Crew Members. Wait until your node is synced! {% endhint %}

Command to check your node status ("latest_block_height" should be not 0 and "catching up" - false):
```
curl localhost:26657/status | jq 
```

### 4.1 Create validator
```
namada client init-validator \
 --alias $VALIDATOR_ALIAS \
 --account-keys $WALLET_ALIAS \
 --signing-keys $WALLET_ALIAS \
 --commission-rate 0.1 \
 --max-commission-rate-change 0.1 \
 --email <ENTER YOUR EMAIL>
```

### 4.2 Restart your node

```
systemctl restart namadad
```
### 4.3 Stake (bond) your validator

```
namada client bond --source $WALLET_ALIAS  --validator $VALIDATOR_ALIAS  --amount 100
```

{% hint style="info" %} Wait > 2 epochs and then check bond status. {% endhint %}

### 4.4 Check your validator status

```
namada client bonds --owner $WALLET_ALIAS
```
