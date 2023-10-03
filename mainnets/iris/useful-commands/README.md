{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
iris keys add <key_name>
```
### Recover keys from seed
```
iris keys add <key_name> --recover
```
### Show all keys
```
iris keys list
```
### Delete key
```
iris keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
IRIS_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${IRIS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${IRIS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${IRIS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${IRIS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${IRIS_PORT}660\"%" /$HOME/.iris/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${IRIS_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${IRIS_PORT}317\"%; s%^address = \":8080\"%address = \":${IRIS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${IRIS_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${IRIS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${IRIS_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${IRIS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${IRIS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${IRIS_PORT}546\"%" /$HOME/.iris/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.iris/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.iris/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.iris/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.025uiris\"/" $HOME/.iris/config/app.toml
```

## Validator configuration

### Create validator
```
iris tx staking create-validator \
--amount 1000000uiris \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(iris tendermint show-validator) \
--moniker <IRIS_NODENAME> \
--chain-id  \
--from <IRIS_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.025uiris \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
iris tx staking edit-validator \
--new-moniker <IRIS_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id  \
--commission-rate 0.05 \
--from <IRIS_WALLET> \
--gas-prices 0.025uiris \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
iris q staking validator $(iris keys show <IRIS_WALLET> --bech val -a)
```
### Unjail validator
```
iris tx slashing unjail --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
iris query slashing signing-info $(iris tendermint show-validator)
```

## Token operations

### Send tokens
```
iris tx bank send wallet <DEST_WALLET_ADDRESS> 100uiris --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
iris tx staking delegate $(iris keys show <IRIS_WALLET> --bech val -a) 100uiris --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
iris tx staking delegate <VALOPER_ADDRESS> 100uiris --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
iris tx staking redelegate $(iris keys show <IRIS_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uiris --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
iris tx staking unbond $(iris keys show <IRIS_WALLET> --bech val -a) 100uiris --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
iris tx distribution withdraw-all-rewards --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
iris tx distribution withdraw-rewards $(iris keys show <IRIS_WALLET> --bech val -a) --commission --from wallet --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0.025uiris -y

```

## Governance
### Vote "YES"
```
iris tx gov vote <proposal_id> yes --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
iris tx gov vote <proposal_id> no --from <IRIS_WALLET> --chain-id  --gas-prices 0.025uiris --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
iris tx gov vote <proposal_id> abstain --from <IRIS_WALLET> --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0.025uiris -y
```


## General commands
### Check node status
```
iris status | jq
```
### Check service status
```
sudo systemctl status iris
```
### Check logs
```
sudo journalctl -u iris -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart iris
```
### Stop service
```
sudo systemctl stop iris
```
### Start service
```
sudo systemctl start iris
```
### Disable service
```
sudo systemctl disable iris
```
### Enable service
```
sudo systemctl enable iris
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
