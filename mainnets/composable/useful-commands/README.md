{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
 keys add <key_name>
```
### Recover keys from seed
```
 keys add <key_name> --recover
```
### Show all keys
```
 keys list
```
### Delete key
```
 keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
COMPOSABLE_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COMPOSABLE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COMPOSABLE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COMPOSABLE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COMPOSABLE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COMPOSABLE_PORT}660\"%" /$HOME/.banksy/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COMPOSABLE_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${COMPOSABLE_PORT}317\"%; s%^address = \":8080\"%address = \":${COMPOSABLE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COMPOSABLE_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${COMPOSABLE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COMPOSABLE_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${COMPOSABLE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COMPOSABLE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COMPOSABLE_PORT}546\"%" /$HOME/.banksy/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.banksy/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.banksy/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0\"/" $HOME/.banksy/config/app.toml
```

## Validator configuration

### Create validator
```
 tx staking create-validator \
--amount 1000000 \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $( tendermint show-validator) \
--moniker <COMPOSABLE_NODENAME> \
--chain-id  \
--from <COMPOSABLE_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0 \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
 tx staking edit-validator \
--new-moniker <COMPOSABLE_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id  \
--commission-rate 0.05 \
--from <COMPOSABLE_WALLET> \
--gas-prices 0 \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
 q staking validator $( keys show <COMPOSABLE_WALLET> --bech val -a)
```
### Unjail validator
```
 tx slashing unjail --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
 query slashing signing-info $( tendermint show-validator)
```

## Token operations

### Send tokens
```
 tx bank send wallet <DEST_WALLET_ADDRESS> 100 --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
 tx staking delegate $( keys show <COMPOSABLE_WALLET> --bech val -a) 100 --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
 tx staking delegate <VALOPER_ADDRESS> 100 --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
 tx staking redelegate $( keys show <COMPOSABLE_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100 --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
 tx staking unbond $( keys show <COMPOSABLE_WALLET> --bech val -a) 100 --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
 tx distribution withdraw-all-rewards --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
 tx distribution withdraw-rewards $( keys show <COMPOSABLE_WALLET> --bech val -a) --commission --from wallet --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0 -y

```

## Governance
### Vote "YES"
```
 tx gov vote <proposal_id> yes --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
 tx gov vote <proposal_id> no --from <COMPOSABLE_WALLET> --chain-id  --gas-prices 0 --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
 tx gov vote <proposal_id> abstain --from <COMPOSABLE_WALLET> --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0 -y
```


## General commands
### Check node status
```
 status | jq
```
### Check service status
```
sudo systemctl status 
```
### Check logs
```
sudo journalctl -u  -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart 
```
### Stop service
```
sudo systemctl stop 
```
### Start service
```
sudo systemctl start 
```
### Disable service
```
sudo systemctl disable 
```
### Enable service
```
sudo systemctl enable 
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
