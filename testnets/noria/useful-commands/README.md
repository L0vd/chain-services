{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
noriad keys add <key_name>
```
### Recover keys from seed
```
noriad keys add <key_name> --recover
```
### Show all keys
```
noriad keys list
```
### Delete key
```
noriad keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
NORIA_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${NORIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${NORIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${NORIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${NORIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${NORIA_PORT}660\"%" /$HOME/.noria/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${NORIA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${NORIA_PORT}317\"%; s%^address = \":8080\"%address = \":${NORIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${NORIA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${NORIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${NORIA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${NORIA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${NORIA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${NORIA_PORT}546\"%" /$HOME/.noria/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.noria/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.noria/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.noria/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.noria/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.noria/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0025unoria\"/" $HOME/.noria/config/app.toml
```

## Validator configuration

### Create validator
```
noriad tx staking create-validator \
--amount 1000000unoria \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(noriad tendermint show-validator) \
--moniker <NORIA_NODENAME> \
--chain-id oasis-3 \
--from <NORIA_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.0025unoria \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
noriad tx staking edit-validator \
--new-moniker <NORIA_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id oasis-3 \
--commission-rate 0.05 \
--from <NORIA_WALLET> \
--gas-prices 0.0025unoria \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
noriad q staking validator $(noriad keys show <NORIA_WALLET> --bech val -a)
```
### Unjail validator
```
noriad tx slashing unjail --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
noriad query slashing signing-info $(noriad tendermint show-validator)
```

## Token operations

### Send tokens
```
noriad tx bank send wallet <DEST_WALLET_ADDRESS> 100unoria --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
noriad tx staking delegate $(noriad keys show <NORIA_WALLET> --bech val -a) 100unoria --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
noriad tx staking delegate <VALOPER_ADDRESS> 100unoria --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
noriad tx staking redelegate $(noriad keys show <NORIA_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100unoria --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
noriad tx staking unbond $(noriad keys show <NORIA_WALLET> --bech val -a) 100unoria --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
noriad tx distribution withdraw-all-rewards --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
noriad tx distribution withdraw-rewards $(noriad keys show <NORIA_WALLET> --bech val -a) --commission --from wallet --chain-id oasis-3 --gas-adjustment 1.5 --gas auto --gas-prices 0.0025unoria -y

```

## Governance
### Vote "YES"
```
noriad tx gov vote <proposal_id> yes --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
noriad tx gov vote <proposal_id> no --from <NORIA_WALLET> --chain-id oasis-3 --gas-prices 0.0025unoria --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
noriad tx gov vote <proposal_id> abstain --from <NORIA_WALLET> --chain-id oasis-3 --gas-adjustment 1.5 --gas auto --gas-prices 0.0025unoria -y
```


## General commands
### Check node status
```
noriad status | jq
```
### Check service status
```
sudo systemctl status noriad
```
### Check logs
```
sudo journalctl -u noriad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart noriad
```
### Stop service
```
sudo systemctl stop noriad
```
### Start service
```
sudo systemctl start noriad
```
### Disable service
```
sudo systemctl disable noriad
```
### Enable service
```
sudo systemctl enable noriad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
