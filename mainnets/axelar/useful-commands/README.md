{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
d keys add <key_name>
```
### Recover keys from seed
```
d keys add <key_name> --recover
```
### Show all keys
```
d keys list
```
### Delete key
```
d keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
AXELAR_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${AXELAR_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${AXELAR_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${AXELAR_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${AXELAR_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${AXELAR_PORT}660\"%" /$HOME/.axelar/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${AXELAR_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${AXELAR_PORT}317\"%; s%^address = \":8080\"%address = \":${AXELAR_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${AXELAR_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${AXELAR_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${AXELAR_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${AXELAR_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${AXELAR_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${AXELAR_PORT}546\"%" /$HOME/.axelar/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.axelar/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.axelar/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.axelar/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.007uaxl\"/" $HOME/.axelar/config/app.toml
```

## Validator configuration

### Create validator
```
d tx staking create-validator \
--amount 1000000uaxl \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(d tendermint show-validator) \
--moniker <AXELAR_NODENAME> \
--chain-id axelar-dojo-1 \
--from <AXELAR_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.007uaxl \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
d tx staking edit-validator \
--new-moniker <AXELAR_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id axelar-dojo-1 \
--commission-rate 0.05 \
--from <AXELAR_WALLET> \
--gas-prices 0.007uaxl \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
d q staking validator $(d keys show <AXELAR_WALLET> --bech val -a)
```
### Unjail validator
```
d tx slashing unjail --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
d query slashing signing-info $(d tendermint show-validator)
```

## Token operations

### Send tokens
```
d tx bank send wallet <DEST_WALLET_ADDRESS> 100uaxl --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
d tx staking delegate $(d keys show <AXELAR_WALLET> --bech val -a) 100uaxl --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
d tx staking delegate <VALOPER_ADDRESS> 100uaxl --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
d tx staking redelegate $(d keys show <AXELAR_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uaxl --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
d tx staking unbond $(d keys show <AXELAR_WALLET> --bech val -a) 100uaxl --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
d tx distribution withdraw-all-rewards --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
d tx distribution withdraw-rewards $(d keys show <AXELAR_WALLET> --bech val -a) --commission --from wallet --chain-id axelar-dojo-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.007uaxl -y

```

## Governance
### Vote "YES"
```
d tx gov vote <proposal_id> yes --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
d tx gov vote <proposal_id> no --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-prices 0.007uaxl --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
d tx gov vote <proposal_id> abstain --from <AXELAR_WALLET> --chain-id axelar-dojo-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.007uaxl -y
```


## General commands
### Check node status
```
d status | jq
```
### Check service status
```
sudo systemctl status d
```
### Check logs
```
sudo journalctl -u d -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart d
```
### Stop service
```
sudo systemctl stop d
```
### Start service
```
sudo systemctl start d
```
### Disable service
```
sudo systemctl disable d
```
### Enable service
```
sudo systemctl enable d
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
