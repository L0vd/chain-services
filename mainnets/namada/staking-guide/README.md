# Namada Staking guide

You can complete this with or without running your own node.

## 1. Running own Full node

Install and sync your node using our guide [here](/mainnets/namada/installation-guide#full-node-setup) then move to step [Task: Delegating stake](/mainnets/namada/staking-guide#task-delegating-stake)

## 2. Using Namada Client and Public RPC

If you have a VPS/VDS with Linux you can use namada client to delegate (bond) tokens. You are not required to run your own RPC node here, as all txs can be executed via public RPC.

If you don't have a VPS/VDS with Linux, you can rent a cheap server here: [Contabo](https://contabo.com/en/), [PQ](https://pq.hosting/), [Mevspace](https://mevspace.com/ru/vps).

{% hint style="info" %} Cheap VPS/VDS might not meet system requirements to run Full node, so if you want to run Full node, see system requirements [here](https://docs.namada.net/operators/hardware)  {% endhint %}

### 2. Namada CLI installation

#### System requirements

{% hint style="info" %} Ubuntu must be 22.04 or newer. {% endhint %}

#### 2.1 Install prerequisites


Update packages and install dependencies:

```
sudo apt update && sudo apt upgrade -y
sudo apt-get install -y make git-core libssl-dev pkg-config libclang-12-dev build-essential protobuf-compiler
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
git checkout v0.37.11
make build
sudo cp $HOME/cometbft/build/cometbft /usr/local/bin/
cometbft version
```

#### 2.2 Install Namada binary

```
cd $HOME
rm -rf namada
git clone https://github.com/anoma/namada
cd namada
wget https://github.com/anoma/namada/releases/download/v1.0.0/namada-v1.0.0-Linux-x86_64.tar.gz
tar -xvf namada-v1.0.0-Linux-x86_64.tar.gz
rm namada-v1.0.0-Linux-x86_64.tar.gz
cd namada-v1.0.0-Linux-x86_64
sudo mv namad* /usr/local/bin/
if [ ! -d "$WORKING_DIR" ]; then
    mkdir -p "$WORKING_DIR"
fi
```

Check namada version:

```
namadac --version
```

#### 2.3 Initialize the chain configuration 

```
namada client utils join-network --chain-id "shielded-expedition.88f17d1d14"
```

Check everything works fine 
(flag --node needs to be added after any transaction):

```
namadac epoch --node https://namada-mainnet.rpc.l0vd.com:443
```

Output should be like: "Last committed epoch: 150"

### 3. Adding wallets 

```
WALLET_ALIAS="<SET YOUR WALLET ALIAS>" # Name of your key
VALIDATOR_ALIAS="L0vd" # Name of validator you want to stake to.
```
:heart: If you found the guide helpful, please delegate to us, we appreciate it greatly

Export variables:
```
echo "export WALLET_ALIAS="$WALLET_ALIAS"" >> $HOME/.bash_profile
echo "export VALIDATOR_ALIAS="$VALIDATOR_ALIAS"" >> $HOME/.bash_profile
source $HOME/.bash_profile
```

#### 3.1 Add new keypair (or restore)

```
namada wallet gen --alias $WALLET_ALIAS
```

or

```
namada wallet restore --alias $WALLET_ALIAS --hd-path default
```

#### 3.2 Check keys and balance

```
namada wallet find --alias $WALLET_ALIAS
```

```
namada client balance --owner $WALLET_ALIAS --node https://namada-mainnet.rpc.l0vd.com:443
```

### Task: Delegating stake 

#### 3.1 Stake (bond) validator

```
namadac bond --source $WALLET_ALIAS --validator $VALIDATOR_ALIAS --amount 1000 --node https://namada-mainnet.rpc.l0vd.com:443
```

#### 3.2 Check bond status

{% hint style="info" %} Wait > 2 epochs and then check bond status. {% endhint %}

```
namada client bonds --owner $WALLET_ALIAS --node https://namada-mainnet.rpc.l0vd.com:443
```

### Task: Withdrawing rewards
#### 3.3 Withdraw rewards

```
namada client claim-rewards --validator $VALIDATOR_ALIAS --node https://namada-mainnet.rpc.l0vd.com:443
```
