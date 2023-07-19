{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
haqqd keys add <key_name>
```
### Recover keys from seed
```
haqqd keys add <key_name> --recover
```
### Show all keys
```
haqqd keys list
```
### Delete key
```
haqqd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
HAQQ_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${HAQQ_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${HAQQ_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${HAQQ_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${HAQQ_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${HAQQ_PORT}660\"%" /$HOME/.haqqd/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${HAQQ_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${HAQQ_PORT}317\"%; s%^address = \":8080\"%address = \":${HAQQ_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${HAQQ_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${HAQQ_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${HAQQ_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${HAQQ_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${HAQQ_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${HAQQ_PORT}546\"%" /$HOME/.haqqd/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.haqqd/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.haqqd/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.haqqd/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.haqqd/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.haqqd/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.25aISLM\"/" $HOME/.haqqd/config/app.toml
```

## Validator configuration

### Create validator
```
haqqd tx staking create-validator \
--amount 1000000aISLM \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(haqqd tendermint show-validator) \
--moniker <HAQQ_NODENAME> \
--chain-id haqq_11235-1 \
--from <HAQQ_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.25aISLM \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
haqqd tx staking edit-validator \
--new-moniker <HAQQ_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id haqq_11235-1 \
--commission-rate 0.05 \
--from <HAQQ_WALLET> \
--gas-prices 0.25aISLM \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
haqqd q staking validator $(haqqd keys show <HAQQ_WALLET> --bech val -a)
```
### Unjail validator
```
haqqd tx slashing unjail --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
haqqd query slashing signing-info $(haqqd tendermint show-validator)
```

## Token operations

### Send tokens
```
haqqd tx bank send wallet <DEST_WALLET_ADDRESS> 100aISLM --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
haqqd tx staking delegate $(haqqd keys show <HAQQ_WALLET> --bech val -a) 100aISLM --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
haqqd tx staking delegate <VALOPER_ADDRESS> 100aISLM --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
haqqd tx staking redelegate $(haqqd keys show <HAQQ_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100aISLM --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
haqqd tx staking unbond $(haqqd keys show <HAQQ_WALLET> --bech val -a) 100aISLM --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
haqqd tx distribution withdraw-all-rewards --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
haqqd tx distribution withdraw-rewards $(haqqd keys show <HAQQ_WALLET> --bech val -a) --commission --from wallet --chain-id haqq_11235-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.25aISLM -y

```

## Governance
### Vote "YES"
```
haqqd tx gov vote <proposal_id> yes --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
haqqd tx gov vote <proposal_id> no --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-prices 0.25aISLM --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
haqqd tx gov vote <proposal_id> abstain --from <HAQQ_WALLET> --chain-id haqq_11235-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.25aISLM -y
```


## General commands
### Check node status
```
haqqd status | jq
```
### Check service status
```
sudo systemctl status haqqd
```
### Check logs
```
sudo journalctl -u haqqd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart haqqd
```
### Stop service
```
sudo systemctl stop haqqd
```
### Start service
```
sudo systemctl start haqqd
```
### Disable service
```
sudo systemctl disable haqqd
```
### Enable service
```
sudo systemctl enable haqqd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
