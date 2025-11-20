{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
uniond keys add <key_name> --home $HOME/.union
```
### Recover keys from seed
```
uniond keys add <key_name> --recover --home $HOME/.union
```
### Show all keys
```
uniond keys list --home $HOME/.union
```
### Delete key
```
uniond keys delete <key_name> --home $HOME/.union
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
UNION_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${UNION_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${UNION_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${UNION_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${UNION_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${UNION_PORT}660\"%" /$HOME/.union/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${UNION_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${UNION_PORT}317\"%; s%^address = \":8080\"%address = \":${UNION_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${UNION_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${UNION_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${UNION_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${UNION_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${UNION_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${UNION_PORT}546\"%" /$HOME/.union/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.union/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.union/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.union/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.union/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.union/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0muno\"/" $HOME/.union/config/app.toml
```

## Validator configuration

### Create validator
```
uniond tx staking create-validator \
--amount 1000000muno \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(uniond tendermint show-validator --home $HOME/.union) \
--moniker <UNION_NODENAME> \
--chain-id  \
--from <UNION_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0muno \
--gas-adjustment 1.5 \
--gas auto \
--home $HOME/.union \
--yes
```
### Edit validator
```
uniond tx staking edit-validator \
--new-moniker <UNION_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id  \
--commission-rate 0.05 \
--from <UNION_WALLET> \
--gas-prices 0muno \
--gas-adjustment 1.5 \
--gas auto \
--home $HOME/.union \
--yes
```
### View validator info
```
uniond q staking validator $(uniond keys show <UNION_WALLET> --bech val -a --home $HOME/.union) --home $HOME/.union
```
### Unjail validator
```
uniond tx slashing unjail --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes 
```
### Signing info
```
uniond query slashing signing-info $(uniond tendermint show-validator --home $HOME/.union) --home $HOME/.union
```

## Token operations

### Send tokens
```
uniond tx bank send wallet <DEST_WALLET_ADDRESS> 100muno --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Delegate token to your validator
```
uniond tx staking delegate $(uniond keys show <UNION_WALLET> --bech val -a) 100muno --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Delegate token to another validator
```
uniond tx staking delegate <VALOPER_ADDRESS> 100muno --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Redelegate tokens to another validator
```
uniond tx staking redelegate $(uniond keys show <UNION_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100muno --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Unbond tokens from staking
```
uniond tx staking unbond $(uniond keys show <UNION_WALLET> --bech val -a) 100muno --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Withdraw all rewards from staking
```
uniond tx distribution withdraw-all-rewards --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```

### Withdraw validator rewards and comission
```
uniond tx distribution withdraw-rewards $(uniond keys show <UNION_WALLET> --bech val -a) --commission --from wallet --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0muno --home $HOME/.union -y

```

## Governance
### Vote "YES"
```
uniond tx gov vote <proposal_id> yes --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Vote "NO"
```
uniond tx gov vote <proposal_id> no --from <UNION_WALLET> --chain-id  --gas-prices 0muno --gas-adjustment 1.5 --gas auto --home $HOME/.union --yes
```
### Abstain from voting
```
uniond tx gov vote <proposal_id> abstain --from <UNION_WALLET> --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0muno --home $HOME/.union -y
```


## General commands
### Check node status
```
uniond status --home $HOME/.union | jq 
```
### Check service status
```
sudo systemctl status uniond
```
### Check logs
```
sudo journalctl -u uniond -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart uniond
```
### Stop service
```
sudo systemctl stop uniond
```
### Start service
```
sudo systemctl start uniond
```
### Disable service
```
sudo systemctl disable uniond
```
### Enable service
```
sudo systemctl enable uniond
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
