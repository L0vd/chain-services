{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
strided keys add <key_name>
```
### Recover keys from seed
```
strided keys add <key_name> --recover
```
### Show all keys
```
strided keys list
```
### Delete key
```
strided keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
STRIDE_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${STRIDE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${STRIDE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${STRIDE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${STRIDE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${STRIDE_PORT}660\"%" /$HOME/.stride/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${STRIDE_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${STRIDE_PORT}317\"%; s%^address = \":8080\"%address = \":${STRIDE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${STRIDE_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${STRIDE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${STRIDE_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${STRIDE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${STRIDE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${STRIDE_PORT}546\"%" /$HOME/.stride/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.stride/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.stride/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.stride/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.0005ustrd\"/" $HOME/.stride/config/app.toml
```

## Validator configuration

### Create validator
```
strided tx staking create-validator \
--amount 1000000ustrd \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(strided tendermint show-validator) \
--moniker <STRIDE_NODENAME> \
--chain-id stride-1 \
--from <STRIDE_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.0005ustrd \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
strided tx staking edit-validator \
--new-moniker <STRIDE_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id stride-1 \
--commission-rate 0.05 \
--from <STRIDE_WALLET> \
--gas-prices 0.0005ustrd \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
strided q staking validator $(strided keys show <STRIDE_WALLET> --bech val -a)
```
### Unjail validator
```
strided tx slashing unjail --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
strided query slashing signing-info $(strided tendermint show-validator)
```

## Token operations

### Send tokens
```
strided tx bank send wallet <DEST_WALLET_ADDRESS> 100ustrd --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
strided tx staking delegate $(strided keys show <STRIDE_WALLET> --bech val -a) 100ustrd --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
strided tx staking delegate <VALOPER_ADDRESS> 100ustrd --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
strided tx staking redelegate $(strided keys show <STRIDE_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100ustrd --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
strided tx staking unbond $(strided keys show <STRIDE_WALLET> --bech val -a) 100ustrd --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
strided tx distribution withdraw-all-rewards --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
strided tx distribution withdraw-rewards $(strided keys show <STRIDE_WALLET> --bech val -a) --commission --from wallet --chain-id stride-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.0005ustrd -y

```

## Governance
### Vote "YES"
```
strided tx gov vote <proposal_id> yes --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
strided tx gov vote <proposal_id> no --from <STRIDE_WALLET> --chain-id stride-1 --gas-prices 0.0005ustrd --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
strided tx gov vote <proposal_id> abstain --from <STRIDE_WALLET> --chain-id stride-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.0005ustrd -y
```


## General commands
### Check node status
```
strided status | jq
```
### Check service status
```
sudo systemctl status strided
```
### Check logs
```
sudo journalctl -u strided -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart strided
```
### Stop service
```
sudo systemctl stop strided
```
### Start service
```
sudo systemctl start strided
```
### Disable service
```
sudo systemctl disable strided
```
### Enable service
```
sudo systemctl enable strided
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
