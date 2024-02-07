#!/bin/bash

CHAIN_ID="shielded-expedition.88f17d1d14"
COMETBFT_VERSION="0.37.2"
#TM_HASH=""
GO_VERSION="1.20.10"
VERSION_TAG="0.31.2"

exists()
{
    command -v "$1" >/dev/null 2>&1
}

echo "=================================================="
echo -e '\033[0;35m\033[5m'
echo "                                   ";
echo "██       ██████  ██    ██ ██████   ";
echo "██      ██  ████ ██    ██ ██   ██  ";
echo "██      ██ ██ ██ ██    ██ ██   ██  ";
echo "██      ████  ██  ██  ██  ██   ██  ";
echo "███████  ██████    ████   ██████   ";
echo "                                   ";
echo -e "\e[0m"
echo "=================================================="

sleep 2

echo ''
echo -e 'Installing Namada Node'

sleep 2

echo -e '\n\e[42mUpdate packages and install dependencies\e[0m\n'

sudo apt update && sudo apt upgrade -y
sudo apt-get install -y curl git jq lz4 make git-core libssl-dev pkg-config libclang-12-dev build-essential protobuf-compiler

sleep 2

echo -e '\n\e[42mInstalling Go\e[0m\n'

sudo rm -rf /usr/local/go
curl -Ls https://go.dev/dl/go"$GO_VERSION".linux-amd64.tar.gz | sudo tar -xzf - -C /usr/local
eval $(echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/golang.sh)
eval $(echo 'export PATH=$PATH:$HOME/go/bin' | tee -a $HOME/.profile)

sleep 2

echo -e '\n\e[42mInstalling Rust\e[0m\n'

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env


sleep 2

echo -e '\n\e[42mInstalling CometBFT\e[0m\n'

cd $HOME
rm -rf cometbft
git clone https://github.com/cometbft/cometbft.git
cd cometbft
git checkout v$COMETBFT_VERSION
make build
sudo cp $HOME/cometbft/build/cometbft /usr/local/bin/
cometbft version

sleep 2

echo -e '\n\e[42mSet variable names\e[0m\n'

read -p "Enter wallet alias: " WALLET_ALIAS
read -p "Enter validator alias: " VALIDATOR_ALIAS

echo "export WALLET="$WALLET_ALIAS"" >> $HOME/.bash_profile
echo "export VALIDATOR="$VALIDATOR_ALIAS"" >> $HOME/.bash_profile
echo "export BASE_DIR="$HOME/.local/share/namada"" >> $HOME/.bash_profile
echo "export PUBLIC_IP=$(wget -qO- eth0.me)" >> $HOME/.bash_profile
echo "export CHAIN_ID="$CHAIN_ID"" >> $HOME/.bash_profile
source $HOME/.bash_profile

sleep 2 

echo -e '\n\e[42mInstalling Namada binary\e[0m\n'

cd $HOME
rm -rf namada
git clone https://github.com/anoma/namada
cd namada
wget https://github.com/anoma/namada/releases/download/v$VERSION_TAG/namada-v$VERSION_TAG-Linux-x86_64.tar.gz
tar -xvf namada-v$VERSION_TAG-Linux-x86_64.tar.gz
rm namada-v$VERSION_TAG-Linux-x86_64.tar.gz
cd namada-v$VERSION_TAG-Linux-x86_64
sudo mv namad* /usr/local/bin/
if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

namada --version

sleep 2 

echo -e '\n\e[42mJoin Namada network\e[0m\n'

namada client utils join-network --chain-id $CHAIN_ID

sleep 2 

echo -e '\n\e[42mCreate service\e[0m\n'

sudo tee /etc/systemd/system/namadad.service > /dev/null <<EOF
[Unit]
Description=namada
After=network-online.target

[Service]
User=$USER
WorkingDirectory=$BASE_DIR
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

sleep 2 

echo -e '\n\e[42mStarting namada node\e[0m\n'

sudo systemctl daemon-reload
sudo systemctl enable namadad
sudo systemctl restart namadad

sleep 2

echo ''
echo -e '\e[32mChecking namada status\e[39m' && sleep 4
echo ''
if [[ `sudo systemctl status namadad | grep active` =~ "running" ]]; then
  echo -e '\e[ Namada node is installed and works!\e[0m'
else
  echo -e "Your Namada node \e[31mwas not installed correctly\e[39m, please reinstall."
  echo -e "You can check namada logs by following command \e[7msudo journalctl -u namadad -f\e[0m"
fi
