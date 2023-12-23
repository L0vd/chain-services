{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
pryzmd keys add <key_name>
```
### Recover keys from seed
```
pryzmd keys add <key_name> --recover
```
### Show all keys
```
pryzmd keys list
```
### Delete key
```
pryzmd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
PRYZM_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${PRYZM_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${PRYZM_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${PRYZM_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${PRYZM_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${PRYZM_PORT}660\"%" /$HOME/.pryzm/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${PRYZM_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${PRYZM_PORT}317\"%; s%^address = \":8080\"%address = \":${PRYZM_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${PRYZM_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${PRYZM_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${PRYZM_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${PRYZM_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${PRYZM_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${PRYZM_PORT}546\"%" /$HOME/.pryzm/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.pryzm/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.pryzm/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.pryzm/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.015upryzm\"/" $HOME/.pryzm/config/app.toml
```

## Validator configuration

### Create validator
```
pryzmd tx staking create-validator \
--amount 1000000upryzm \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(pryzmd tendermint show-validator) \
--moniker <PRYZM_NODENAME> \
--chain-id indigo-1 \
--from <PRYZM_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.015upryzm \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
pryzmd tx staking edit-validator \
--new-moniker <PRYZM_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id indigo-1 \
--commission-rate 0.05 \
--from <PRYZM_WALLET> \
--gas-prices 0.015upryzm \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
pryzmd q staking validator $(pryzmd keys show <PRYZM_WALLET> --bech val -a)
```
### Unjail validator
```
pryzmd tx slashing unjail --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
pryzmd query slashing signing-info $(pryzmd tendermint show-validator)
```

## Token operations

### Send tokens
```
pryzmd tx bank send wallet <DEST_WALLET_ADDRESS> 100upryzm --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
pryzmd tx staking delegate $(pryzmd keys show <PRYZM_WALLET> --bech val -a) 100upryzm --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
pryzmd tx staking delegate <VALOPER_ADDRESS> 100upryzm --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
pryzmd tx staking redelegate $(pryzmd keys show <PRYZM_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100upryzm --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
pryzmd tx staking unbond $(pryzmd keys show <PRYZM_WALLET> --bech val -a) 100upryzm --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
pryzmd tx distribution withdraw-all-rewards --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
pryzmd tx distribution withdraw-rewards $(pryzmd keys show <PRYZM_WALLET> --bech val -a) --commission --from wallet --chain-id indigo-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.015upryzm -y

```

## Governance
### Vote "YES"
```
pryzmd tx gov vote <proposal_id> yes --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
pryzmd tx gov vote <proposal_id> no --from <PRYZM_WALLET> --chain-id indigo-1 --gas-prices 0.015upryzm --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
pryzmd tx gov vote <proposal_id> abstain --from <PRYZM_WALLET> --chain-id indigo-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.015upryzm -y
```


## General commands
### Check node status
```
pryzmd status | jq
```
### Check service status
```
sudo systemctl status pryzmd
```
### Check logs
```
sudo journalctl -u pryzmd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart pryzmd
```
### Stop service
```
sudo systemctl stop pryzmd
```
### Start service
```
sudo systemctl start pryzmd
```
### Disable service
```
sudo systemctl disable pryzmd
```
### Enable service
```
sudo systemctl enable pryzmd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```

## Feeder commands
### Check logs
```
docker logs -f pryzm-feeder
```
### Stop feeder
```
docker stop pryzm-feeder
```

### Restart feeder
```
docker restart pryzm-feeder
```
