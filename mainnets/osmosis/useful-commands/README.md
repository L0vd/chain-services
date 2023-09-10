{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
osmosisd keys add <key_name>
```
### Recover keys from seed
```
osmosisd keys add <key_name> --recover
```
### Show all keys
```
osmosisd keys list
```
### Delete key
```
osmosisd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
OSMOSIS_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OSMOSIS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OSMOSIS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OSMOSIS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OSMOSIS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OSMOSIS_PORT}660\"%" /$HOME/.osmosisd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OSMOSIS_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${OSMOSIS_PORT}317\"%; s%^address = \":8080\"%address = \":${OSMOSIS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OSMOSIS_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${OSMOSIS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OSMOSIS_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${OSMOSIS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OSMOSIS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OSMOSIS_PORT}546\"%" /$HOME/.osmosisd/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.osmosisd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.osmosisd/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.osmosisd/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025uosmo\"/" $HOME/.osmosisd/config/app.toml
```

## Validator configuration

### Create validator
```
osmosisd tx staking create-validator \
--amount 1000000uosmo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(osmosisd tendermint show-validator) \
--moniker <OSMOSIS_NODENAME> \
--chain-id osmosis-1 \
--from <OSMOSIS_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.0025uosmo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
osmosisd tx staking edit-validator \
--new-moniker <OSMOSIS_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id osmosis-1 \
--commission-rate 0.05 \
--from <OSMOSIS_WALLET> \
--gas-prices 0.0025uosmo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
osmosisd q staking validator $(osmosisd keys show <OSMOSIS_WALLET> --bech val -a)
```
### Unjail validator
```
osmosisd tx slashing unjail --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
osmosisd query slashing signing-info $(osmosisd tendermint show-validator)
```

## Token operations

### Send tokens
```
osmosisd tx bank send wallet <DEST_WALLET_ADDRESS> 100uosmo --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
osmosisd tx staking delegate $(osmosisd keys show <OSMOSIS_WALLET> --bech val -a) 100uosmo --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
osmosisd tx staking delegate <VALOPER_ADDRESS> 100uosmo --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
osmosisd tx staking redelegate $(osmosisd keys show <OSMOSIS_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uosmo --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
osmosisd tx staking unbond $(osmosisd keys show <OSMOSIS_WALLET> --bech val -a) 100uosmo --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
osmosisd tx distribution withdraw-all-rewards --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
osmosisd tx distribution withdraw-rewards $(osmosisd keys show <OSMOSIS_WALLET> --bech val -a) --commission --from wallet --chain-id osmosis-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.0025uosmo -y

```

## Governance
### Vote "YES"
```
osmosisd tx gov vote <proposal_id> yes --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
osmosisd tx gov vote <proposal_id> no --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-prices 0.0025uosmo --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
osmosisd tx gov vote <proposal_id> abstain --from <OSMOSIS_WALLET> --chain-id osmosis-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.0025uosmo -y
```


## General commands
### Check node status
```
osmosisd status | jq
```
### Check service status
```
sudo systemctl status osmosisd
```
### Check logs
```
sudo journalctl -u osmosisd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart osmosisd
```
### Stop service
```
sudo systemctl stop osmosisd
```
### Start service
```
sudo systemctl start osmosisd
```
### Disable service
```
sudo systemctl disable osmosisd
```
### Enable service
```
sudo systemctl enable osmosisd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
