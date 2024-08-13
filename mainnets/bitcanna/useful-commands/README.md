{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
bcnad keys add <key_name>
```
### Recover keys from seed
```
bcnad keys add <key_name> --recover
```
### Show all keys
```
bcnad keys list
```
### Delete key
```
bcnad keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
BITCANNA_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BITCANNA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BITCANNA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BITCANNA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BITCANNA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BITCANNA_PORT}660\"%" /$HOME/.bcna/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BITCANNA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${BITCANNA_PORT}317\"%; s%^address = \":8080\"%address = \":${BITCANNA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BITCANNA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${BITCANNA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BITCANNA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${BITCANNA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BITCANNA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BITCANNA_PORT}546\"%" /$HOME/.bcna/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.bcna/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.bcna/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.bcna/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubcna\"/" $HOME/.bcna/config/app.toml
```

## Validator configuration

### Create validator
```
bcnad tx staking create-validator \
--amount 1000000ubcna \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(bcnad tendermint show-validator) \
--moniker <BITCANNA_NODENAME> \
--chain-id bitcanna-1 \
--from <BITCANNA_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0ubcna \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
bcnad tx staking edit-validator \
--new-moniker <BITCANNA_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id bitcanna-1 \
--commission-rate 0.05 \
--from <BITCANNA_WALLET> \
--gas-prices 0ubcna \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
bcnad q staking validator $(bcnad keys show <BITCANNA_WALLET> --bech val -a)
```
### Unjail validator
```
bcnad tx slashing unjail --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
bcnad query slashing signing-info $(bcnad tendermint show-validator)
```

## Token operations

### Send tokens
```
bcnad tx bank send wallet <DEST_WALLET_ADDRESS> 100ubcna --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
bcnad tx staking delegate $(bcnad keys show <BITCANNA_WALLET> --bech val -a) 100ubcna --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
bcnad tx staking delegate <VALOPER_ADDRESS> 100ubcna --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
bcnad tx staking redelegate $(bcnad keys show <BITCANNA_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100ubcna --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
bcnad tx staking unbond $(bcnad keys show <BITCANNA_WALLET> --bech val -a) 100ubcna --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
bcnad tx distribution withdraw-all-rewards --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
bcnad tx distribution withdraw-rewards $(bcnad keys show <BITCANNA_WALLET> --bech val -a) --commission --from wallet --chain-id bitcanna-1 --gas-adjustment 1.5 --gas auto --gas-prices 0ubcna -y

```

## Governance
### Vote "YES"
```
bcnad tx gov vote <proposal_id> yes --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
bcnad tx gov vote <proposal_id> no --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-prices 0ubcna --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
bcnad tx gov vote <proposal_id> abstain --from <BITCANNA_WALLET> --chain-id bitcanna-1 --gas-adjustment 1.5 --gas auto --gas-prices 0ubcna -y
```


## General commands
### Check node status
```
bcnad status | jq
```
### Check service status
```
sudo systemctl status bcnad
```
### Check logs
```
sudo journalctl -u bcnad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart bcnad
```
### Stop service
```
sudo systemctl stop bcnad
```
### Start service
```
sudo systemctl start bcnad
```
### Disable service
```
sudo systemctl disable bcnad
```
### Enable service
```
sudo systemctl enable bcnad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
