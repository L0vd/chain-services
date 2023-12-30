## Manual node setup
If you want to setup Namada fullnode manually follow the steps below

### Update and upgrade
```
sudo apt update && sudo apt upgrade -y
```

### Install GO
```
if ! [ -x "$(command -v go)" ]; then
  ver="1.20.3"
  cd $HOME
  wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi
```

# Install rust
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y 
source $HOME/.cargo/env
```

# Install protobuf
```
sudo apt update
sudo apt install protobuf-compiler
```

### Setting up vars
You should replace values in <> <br />
<YOUR_MONIKER> Here you should put name of your moniker (validator) that will be visible in explorer <br />
<YOUR_WALLET> Here you shoud put the name of your wallet

```
NAMADA_WALLET="<YOUR_WALLET_NAME>"
NAMADA_NODENAME="<YOUR_MONIKER>"
NAMADA_CHAIN_ID="public-testnet-15.0dacadb8d663"
EMAIL="<YOUR EMAIL>"
```
```
echo "
export NAMADA_WALLET=${NAMADA_WALLET}
export NAMADA_NODENAME=${NAMADA_NODENAME}
export NAMADA_CHAIN_ID=${NAMADA_CHAIN_ID}
export EMAIL=${EMAIL}
" >> $HOME/.bash_profile

source $HOME/.bash_profile
```
 
# Install binaries
```
git clone https://github.com/anoma/namada.git
cd namada
git checkout v0.28.2
make install
sudo chmod +x ~/.cargo/bin/namada*
sudo mv ~/.cargo/bin/namada* /usr/local/bin
```

# Install CometBft
```
cd $HOME; mkdir cometbft
wget https://github.com/cometbft/cometbft/releases/download/v0.37.2/cometbft_0.37.2_linux_amd64.tar.gz
tar xvf cometbft_0.37.2_linux_amd64.tar.gz -C ./cometbft
chmod +x cometbft/cometbft
sudo mv cometbft/cometbft /usr/local/bin/
rm -rf cometbft*
```

# Initialize your Node
```
namada client utils join-network --chain-id $CHAIN_ID
```

# Create Service
```
sudo tee /etc/systemd/system/namadad.service << EOF
[Unit]
Description=Namada Node
After=network.target
[Service]
User=$USER
WorkingDirectory=$HOME/.local/share/namada
Type=simple
ExecStart=/usr/local/bin/namada --base-dir=$HOME/.local/share/namada node ledger run
Environment=NAMADA_CMT_STDOUT=true
Environment=TM_LOG_LEVEL=p2p:none,pex:error
RemainAfterExit=no
Restart=on-failure
RestartSec=10s
LimitNOFILE=65535
[Install]
WantedBy=multi-user.target
EOF
```

# Enable your Node
```
sudo systemctl enable namadad.service
sudo systemctl daemon-reload
```

# Sync node using [State sync](testnets/namada/state-sync/README.md)

# Starting a validator

## 1. Add a new key
```
namadaw key gen --alias "${NAMADA_WALLET}"
```
### (OR)

## 1. Recover your key
```
namadaw key derive --alias "${NAMADA_WALLET}"
```

# 2. Create validator

{% hint style="info" %}
Wait until the node is synchronized.
{% endhint %}

```
namadac  init-validator \
 --alias "${NAMADA_NODENAME}" \
 --account-keys "${NAMADA_WALLET}" \
 --signing-keys "${NAMADA_WALLET}" \
 --commission-rate 0.5 \
 --max-commission-rate-change 0.05 \
 --email "${EMAIL}"
```

# Stake more tokens to your validator
```
namadac bond \
 --source "${NAMADA_WALLET}" \
 --validator "${NAMADA_NODENAME}" \
 --amount 900
```
