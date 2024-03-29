{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
arkeod keys add <key_name>
```
### Recover keys from seed
```
arkeod keys add <key_name> --recover
```
### Show all keys
```
arkeod keys list
```
### Delete key
```
arkeod keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
ARKEO_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ARKEO_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ARKEO_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ARKEO_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ARKEO_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ARKEO_PORT}660\"%" /$HOME/.arkeo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ARKEO_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${ARKEO_PORT}317\"%; s%^address = \":8080\"%address = \":${ARKEO_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ARKEO_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${ARKEO_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ARKEO_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${ARKEO_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ARKEO_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ARKEO_PORT}546\"%" /$HOME/.arkeo/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.arkeo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.arkeo/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.arkeo/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uarkeo\"/" $HOME/.arkeo/config/app.toml
```

## Validator configuration

### Create validator
```
arkeod tx staking create-validator \
--amount 1000000uarkeo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(arkeod tendermint show-validator) \
--moniker <ARKEO_NODENAME> \
--chain-id arkeo \
--from <ARKEO_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0uarkeo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
arkeod tx staking edit-validator \
--new-moniker <ARKEO_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id arkeo \
--commission-rate 0.05 \
--from <ARKEO_WALLET> \
--gas-prices 0uarkeo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
arkeod q staking validator $(arkeod keys show <ARKEO_WALLET> --bech val -a)
```
### Unjail validator
```
arkeod tx slashing unjail --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
arkeod query slashing signing-info $(arkeod tendermint show-validator)
```

## Token operations

### Send tokens
```
arkeod tx bank send wallet <DEST_WALLET_ADDRESS> 100uarkeo --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
arkeod tx staking delegate $(arkeod keys show <ARKEO_WALLET> --bech val -a) 100uarkeo --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
arkeod tx staking delegate <VALOPER_ADDRESS> 100uarkeo --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
arkeod tx staking redelegate $(arkeod keys show <ARKEO_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uarkeo --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
arkeod tx staking unbond $(arkeod keys show <ARKEO_WALLET> --bech val -a) 100uarkeo --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
arkeod tx distribution withdraw-all-rewards --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
arkeod tx distribution withdraw-rewards $(arkeod keys show <ARKEO_WALLET> --bech val -a) --commission --from wallet --chain-id arkeo --gas-adjustment 1.5 --gas auto --gas-prices 0uarkeo -y

```

## Governance
### Vote "YES"
```
arkeod tx gov vote <proposal_id> yes --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
arkeod tx gov vote <proposal_id> no --from <ARKEO_WALLET> --chain-id arkeo --gas-prices 0uarkeo --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
arkeod tx gov vote <proposal_id> abstain --from <ARKEO_WALLET> --chain-id arkeo --gas-adjustment 1.5 --gas auto --gas-prices 0uarkeo -y
```


## General commands
### Check node status
```
arkeod status | jq
```
### Check service status
```
sudo systemctl status arkeod
```
### Check logs
```
sudo journalctl -u arkeod -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart arkeod
```
### Stop service
```
sudo systemctl stop arkeod
```
### Start service
```
sudo systemctl start arkeod
```
### Disable service
```
sudo systemctl disable arkeod
```
### Enable service
```
sudo systemctl enable arkeod
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
