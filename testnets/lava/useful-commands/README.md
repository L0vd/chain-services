{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
lavad keys add <key_name>
```
### Recover keys from seed
```
lavad keys add <key_name> --recover
```
### Show all keys
```
lavad keys list
```
### Delete key
```
lavad keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
LAVA_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${LAVA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${LAVA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${LAVA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${LAVA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${LAVA_PORT}660\"%" /$HOME/.lava/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${LAVA_PORT}317\"%; s%^address = \":8080\"%address = \":${LAVA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${LAVA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${LAVA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${LAVA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${LAVA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${LAVA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${LAVA_PORT}546\"%" /$HOME/.lava/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.lava/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.lava/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.lava/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ulava\"/" $HOME/.lava/config/app.toml
```

## Validator configuration

### Create validator
```
lavad tx staking create-validator \
--amount 1000000ulava \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(lavad tendermint show-validator) \
--moniker <LAVA_NODENAME> \
--chain-id lava-testnet-2 \
--from <LAVA_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0ulava \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
lavad tx staking edit-validator \
--new-moniker <LAVA_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id lava-testnet-2 \
--commission-rate 0.05 \
--from <LAVA_WALLET> \
--gas-prices 0ulava \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
lavad q staking validator $(lavad keys show <LAVA_WALLET> --bech val -a)
```
### Unjail validator
```
lavad tx slashing unjail --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
lavad query slashing signing-info $(lavad tendermint show-validator)
```

## Token operations

### Send tokens
```
lavad tx bank send wallet <DEST_WALLET_ADDRESS> 100ulava --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
lavad tx staking delegate $(lavad keys show <LAVA_WALLET> --bech val -a) 100ulava --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
lavad tx staking delegate <VALOPER_ADDRESS> 100ulava --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
lavad tx staking redelegate $(lavad keys show <LAVA_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100ulava --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
lavad tx staking unbond $(lavad keys show <LAVA_WALLET> --bech val -a) 100ulava --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
lavad tx distribution withdraw-all-rewards --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
lavad tx distribution withdraw-rewards $(lavad keys show <LAVA_WALLET> --bech val -a) --commission --from wallet --chain-id lava-testnet-2 --gas-adjustment 1.5 --gas auto --gas-prices 0ulava -y

```

## Governance
### Vote "YES"
```
lavad tx gov vote <proposal_id> yes --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
lavad tx gov vote <proposal_id> no --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-prices 0ulava --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
lavad tx gov vote <proposal_id> abstain --from <LAVA_WALLET> --chain-id lava-testnet-2 --gas-adjustment 1.5 --gas auto --gas-prices 0ulava -y
```


## General commands
### Check node status
```
lavad status | jq
```
### Check service status
```
sudo systemctl status lavad
```
### Check logs
```
sudo journalctl -u lavad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart lavad
```
### Stop service
```
sudo systemctl stop lavad
```
### Start service
```
sudo systemctl start lavad
```
### Disable service
```
sudo systemctl disable lavad
```
### Enable service
```
sudo systemctl enable lavad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
