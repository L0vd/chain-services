{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
entangled keys add <key_name>
```
### Recover keys from seed
```
entangled keys add <key_name> --recover
```
### Show all keys
```
entangled keys list
```
### Delete key
```
entangled keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
ENTANGLE_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ENTANGLE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ENTANGLE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ENTANGLE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ENTANGLE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ENTANGLE_PORT}660\"%" /$HOME/.entangled/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ENTANGLE_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${ENTANGLE_PORT}317\"%; s%^address = \":8080\"%address = \":${ENTANGLE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ENTANGLE_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${ENTANGLE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ENTANGLE_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${ENTANGLE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ENTANGLE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ENTANGLE_PORT}546\"%" /$HOME/.entangled/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.entangled/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.entangled/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.entangled/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"10aNGL\"/" $HOME/.entangled/config/app.toml
```

## Validator configuration

### Create validator
```
entangled tx staking create-validator \
--amount 1000000aNGL \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(entangled tendermint show-validator) \
--moniker <ENTANGLE_NODENAME> \
--chain-id entangle_33133-1 \
--from <ENTANGLE_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 10aNGL \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
entangled tx staking edit-validator \
--new-moniker <ENTANGLE_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id entangle_33133-1 \
--commission-rate 0.05 \
--from <ENTANGLE_WALLET> \
--gas-prices 10aNGL \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
entangled q staking validator $(entangled keys show <ENTANGLE_WALLET> --bech val -a)
```
### Unjail validator
```
entangled tx slashing unjail --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
entangled query slashing signing-info $(entangled tendermint show-validator)
```

## Token operations

### Send tokens
```
entangled tx bank send wallet <DEST_WALLET_ADDRESS> 100aNGL --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
entangled tx staking delegate $(entangled keys show <ENTANGLE_WALLET> --bech val -a) 100aNGL --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
entangled tx staking delegate <VALOPER_ADDRESS> 100aNGL --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
entangled tx staking redelegate $(entangled keys show <ENTANGLE_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100aNGL --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
entangled tx staking unbond $(entangled keys show <ENTANGLE_WALLET> --bech val -a) 100aNGL --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
entangled tx distribution withdraw-all-rewards --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
entangled tx distribution withdraw-rewards $(entangled keys show <ENTANGLE_WALLET> --bech val -a) --commission --from wallet --chain-id entangle_33133-1 --gas-adjustment 1.5 --gas auto --gas-prices 10aNGL -y

```

## Governance
### Vote "YES"
```
entangled tx gov vote <proposal_id> yes --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
entangled tx gov vote <proposal_id> no --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-prices 10aNGL --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
entangled tx gov vote <proposal_id> abstain --from <ENTANGLE_WALLET> --chain-id entangle_33133-1 --gas-adjustment 1.5 --gas auto --gas-prices 10aNGL -y
```


## General commands
### Check node status
```
entangled status | jq
```
### Check service status
```
sudo systemctl status entangled
```
### Check logs
```
sudo journalctl -u entangled -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart entangled
```
### Stop service
```
sudo systemctl stop entangled
```
### Start service
```
sudo systemctl start entangled
```
### Disable service
```
sudo systemctl disable entangled
```
### Enable service
```
sudo systemctl enable entangled
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
