# Keys

## Add new key
```
noisd keys add <key_name>
```
## Recover keys from seed
```
noisd keys add <key_name> --recover
```
## Show all keys
```
noisd keys list
```
## Delete key
```
noisd keys delete <key_name>
```

# Node configuration

## Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
NOIS_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${NOIS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${NOIS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${NOIS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${NOIS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${NOIS_PORT}660\"%" $HOME/.noisd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${NOIS_PORT}317\"%; s%^address = \":8080\"%address = \":${NOIS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${NOIS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${NOIS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${NOIS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${NOIS_PORT}546\"%" $HOME/.noisd/config/app.toml
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
## Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.noisd/config/config.toml
```
## Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0unois\"/" $HOME/.noisd/config/app.toml
```

# Validator configuration

## Create validator
```
noisd tx staking create-validator \
--amount 1000000unois \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(noisd tendermint show-validator) \
--moniker <NOIS_NODENAME> \
--chain-id nois-testnet-005 \
--from <NOIS_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1unois \
--gas-adjustment 1.5
--gas auto
--yes
```
## Edit validator
```
noisd tx staking edit-validator \
--new-moniker "NOIS_NODENAME" \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id nois-testnet-005 \
--commission-rate 0.05 \
--from <NOIS_WALLET> \
--gas-prices 0.1unois \
--gas-adjustment 1.5
--gas auto
--yes
```
## View validator info
```
noisd q staking validator $(noisd keys show <NOIS_WALLET> --bech val -a)
```
## Unjail validator
```
noisd tx slashing unjail --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes 
```
## Signing info
```
noisd query slashing signing-info $(noisd tendermint show-validator)
```

# Token operations

## Send tokens
```
noisd tx bank send wallet <DEST_WALLET_ADDRESS> 100unois --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Delegate token to your validator
```
noisd tx staking delegate $(noisd keys show <NOIS_WALLET> --bech val -a) 100unois --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Delegate token to another validator
```
noisd tx staking delegate <VALOPER_ADDRESS> 100unois --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Redelegate tokens to another validator
```
noisd tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100unois --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Unbond tokens from staking
```
noisd tx staking unbond <VALOPER_ADDRESS> 100unois --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Withdraw all rewards from staking
```
noisd tx distribution withdraw-all-rewards --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```

# Governance
## Vote "YES"
```
noisd tx gov vote <proposal_id> yes --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Vote "NO"
```
noisd tx gov vote <proposal_id> no --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-prices 0.1unois --gas-adjustment 1.5 --gas auto --yes
```
## Abstain from voting
```
noisd tx gov vote <proposal_id> abstain --from <NOIS_WALLET> --chain-id nois-testnet-005 --gas-adjustment 1.5 --gas auto --gas-prices 0.1unois -y
```

# General commands
## Check node status
```
noisd status | jq
```
## Check service status
```
sudo systemctl status noisd
```
## Check logs
```
sudo journalctl -u noisd -f --no-hostname -o cat
```
## Restart service
```
sudo systemctl restart noisd
```
## Stop service
```
sudo systemctl stop noisd
```
## Start service
```
sudo systemctl start noisd
```
## Disable service
```
sudo systemctl disable noisd
```
## Enable service
```
sudo systemctl enable noisd
```
## Reload service after changes
```
sudo systemctl daemon-reload
```
