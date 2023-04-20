{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
andromedad keys add <key_name>
```
### Recover keys from seed
```
andromedad keys add <key_name> --recover
```
### Show all keys
```
andromedad keys list
```
### Delete key
```
andromedad keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
ANDROMEDA_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${ANDROMEDA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${ANDROMEDA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${ANDROMEDA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${ANDROMEDA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${ANDROMEDA_PORT}660\"%" $HOME/.andromedad/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${ANDROMEDA_PORT}317\"%; s%^address = \":8080\"%address = \":${ANDROMEDA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${ANDROMEDA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${ANDROMEDA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${ANDROMEDA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${ANDROMEDA_PORT}546\"%" $HOME/.andromedad/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.andromedad/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.andromedad/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.andromedad/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uandr\"/" $HOME/.andromedad/config/app.toml
```

## Validator configuration

### Create validator
```
andromedad tx staking create-validator \
--amount 1000000uandr \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(andromedad tendermint show-validator) \
--moniker <ANDROMEDA_NODENAME> \
--chain-id galileo-3 \
--from <ANDROMEDA_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1uandr \
--gas-adjustment 1.5
--gas auto
--yes
```
### Edit validator
```
andromedad tx staking edit-validator \
--new-moniker <ANDROMEDA_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id galileo-3 \
--commission-rate 0.05 \
--from <ANDROMEDA_WALLET> \
--gas-prices 0.1uandr \
--gas-adjustment 1.5
--gas auto
--yes
```
### View validator info
```
andromedad q staking validator $(andromedad keys show <ANDROMEDA_WALLET> --bech val -a)
```
### Unjail validator
```
andromedad tx slashing unjail --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
andromedad query slashing signing-info $(andromedad tendermint show-validator)
```

## Token operations

### Send tokens
```
andromedad tx bank send wallet <DEST_WALLET_ADDRESS> 100uandr --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
andromedad tx staking delegate $(andromedad keys show <ANDROMEDA_WALLET> --bech val -a) 100uandr --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
andromedad tx staking delegate <VALOPER_ADDRESS> 100uandr --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
andromedad tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100uandr --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
andromedad tx staking unbond <VALOPER_ADDRESS> 100uandr --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
andromedad tx distribution withdraw-all-rewards --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
andromedad tx gov vote <proposal_id> yes --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
andromedad tx gov vote <proposal_id> no --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-prices 0.1uandr --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
andromedad tx gov vote <proposal_id> abstain --from <ANDROMEDA_WALLET> --chain-id galileo-3 --gas-adjustment 1.5 --gas auto --gas-prices 0.1uandr -y
```

## General commands
### Check node status
```
andromedad status | jq
```
### Check service status
```
sudo systemctl status andromedad
```
### Check logs
```
sudo journalctl -u andromedad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart andromedad
```
### Stop service
```
sudo systemctl stop andromedad
```
### Start service
```
sudo systemctl start andromedad
```
### Disable service
```
sudo systemctl disable andromedad
```
### Enable service
```
sudo systemctl enable andromedad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
