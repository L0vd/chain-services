{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
artelad keys add <key_name>
```
### Recover keys from seed
```
artelad keys add <key_name> --recover
```
### Show all keys
```
artelad keys list
```
### Delete key
```
artelad keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
artela_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${artela_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${artela_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${artela_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${artela_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${artela_PORT}660\"%" /$HOME/.artela/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${artela_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${artela_PORT}317\"%; s%^address = \":8080\"%address = \":${artela_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${artela_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${artela_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${artela_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${artela_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${artela_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${artela_PORT}546\"%" /$HOME/.artela/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.artela/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.artela/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.artela/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.02uartuart\"/" $HOME/.artela/config/app.toml
```

## Validator configuration

### Create validator
```
artelad tx staking create-validator \
--amount 1000000uart \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(artelad tendermint show-validator) \
--moniker <artela_NODENAME> \
--chain-id artela_11822-1 \
--from <artela_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.02uartuart \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
artelad tx staking edit-validator \
--new-moniker <artela_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id artela_11822-1 \
--commission-rate 0.05 \
--from <artela_WALLET> \
--gas-prices 0.02uartuart \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
artelad q staking validator $(artelad keys show <artela_WALLET> --bech val -a)
```
### Unjail validator
```
artelad tx slashing unjail --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
artelad query slashing signing-info $(artelad tendermint show-validator)
```

## Token operations

### Send tokens
```
artelad tx bank send wallet <DEST_WALLET_ADDRESS> 100uart --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
artelad tx staking delegate $(artelad keys show <artela_WALLET> --bech val -a) 100uart --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
artelad tx staking delegate <VALOPER_ADDRESS> 100uart --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
artelad tx staking redelegate $(artelad keys show <artela_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uart --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
artelad tx staking unbond $(artelad keys show <artela_WALLET> --bech val -a) 100uart --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
artelad tx distribution withdraw-all-rewards --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
artelad tx distribution withdraw-rewards $(artelad keys show <artela_WALLET> --bech val -a) --commission --from wallet --chain-id artela_11822-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.02uartuart -y

```

## Governance
### Vote "YES"
```
artelad tx gov vote <proposal_id> yes --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
artelad tx gov vote <proposal_id> no --from <artela_WALLET> --chain-id artela_11822-1 --gas-prices 0.02uartuart --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
artelad tx gov vote <proposal_id> abstain --from <artela_WALLET> --chain-id artela_11822-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.02uartuart -y
```


## General commands
### Check node status
```
artelad status | jq
```
### Check service status
```
sudo systemctl status artelad
```
### Check logs
```
sudo journalctl -u artelad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart artelad
```
### Stop service
```
sudo systemctl stop artelad
```
### Start service
```
sudo systemctl start artelad
```
### Disable service
```
sudo systemctl disable artelad
```
### Enable service
```
sudo systemctl enable artelad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
