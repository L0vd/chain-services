{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
archwayd keys add <key_name>
```
### Recover keys from seed
```
archwayd keys add <key_name> --recover
```
### Show all keys
```
archwayd keys list
```
### Delete key
```
archwayd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
ARCHWAY_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ARCHWAY_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ARCHWAY_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ARCHWAY_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ARCHWAY_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ARCHWAY_PORT}660\"%" /$HOME/.archway/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ARCHWAY_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${ARCHWAY_PORT}317\"%; s%^address = \":8080\"%address = \":${ARCHWAY_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ARCHWAY_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${ARCHWAY_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ARCHWAY_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${ARCHWAY_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ARCHWAY_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ARCHWAY_PORT}546\"%" /$HOME/.archway/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.archway/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.archway/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.archway/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"1000000000000aarch\"/" $HOME/.archway/config/app.toml
```

## Validator configuration

### Create validator
```
archwayd tx staking create-validator \
--amount 1000000aarch \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(archwayd tendermint show-validator) \
--moniker <ARCHWAY_NODENAME> \
--chain-id  \
--from <ARCHWAY_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 1000000000000aarch \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
archwayd tx staking edit-validator \
--new-moniker <ARCHWAY_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id  \
--commission-rate 0.05 \
--from <ARCHWAY_WALLET> \
--gas-prices 1000000000000aarch \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
archwayd q staking validator $(archwayd keys show <ARCHWAY_WALLET> --bech val -a)
```
### Unjail validator
```
archwayd tx slashing unjail --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
archwayd query slashing signing-info $(archwayd tendermint show-validator)
```

## Token operations

### Send tokens
```
archwayd tx bank send wallet <DEST_WALLET_ADDRESS> 100aarch --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
archwayd tx staking delegate $(archwayd keys show <ARCHWAY_WALLET> --bech val -a) 100aarch --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
archwayd tx staking delegate <VALOPER_ADDRESS> 100aarch --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
archwayd tx staking redelegate $(archwayd keys show <ARCHWAY_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100aarch --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
archwayd tx staking unbond $(archwayd keys show <ARCHWAY_WALLET> --bech val -a) 100aarch --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
archwayd tx distribution withdraw-all-rewards --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
archwayd tx distribution withdraw-rewards $(archwayd keys show <ARCHWAY_WALLET> --bech val -a) --commission --from wallet --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 1000000000000aarch -y

```

## Governance
### Vote "YES"
```
archwayd tx gov vote <proposal_id> yes --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
archwayd tx gov vote <proposal_id> no --from <ARCHWAY_WALLET> --chain-id  --gas-prices 1000000000000aarch --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
archwayd tx gov vote <proposal_id> abstain --from <ARCHWAY_WALLET> --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 1000000000000aarch -y
```


## General commands
### Check node status
```
archwayd status | jq
```
### Check service status
```
sudo systemctl status archwayd
```
### Check logs
```
sudo journalctl -u archwayd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart archwayd
```
### Stop service
```
sudo systemctl stop archwayd
```
### Start service
```
sudo systemctl start archwayd
```
### Disable service
```
sudo systemctl disable archwayd
```
### Enable service
```
sudo systemctl enable archwayd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```