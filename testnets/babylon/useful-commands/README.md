{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
babylond keys add <key_name>
```
### Recover keys from seed
```
babylond keys add <key_name> --recover
```
### Show all keys
```
babylond keys list
```
### Delete key
```
babylond keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
BABYLON_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BABYLON_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BABYLON_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BABYLON_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BABYLON_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BABYLON_PORT}660\"%" $HOME/.babylond/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BABYLON_PORT}317\"%; s%^address = \":8080\"%address = \":${BABYLON_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BABYLON_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BABYLON_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BABYLON_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BABYLON_PORT}546\"%" $HOME/.babylond/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.babylond/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.babylond/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.babylond/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ubbn\"/" $HOME/.babylond/config/app.toml
```

## Validator configuration

### Create validator
```
babylond tx checkpointing create-validator \
--amount 1ubbn \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(babylond tendermint show-validator) \
--moniker <BABYLON_NODENAME> \
--chain-id bbn-test1 \
--from <BABYLON_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1ubbn \
--gas-adjustment 1.5
--gas auto
--yes
```
### Edit validator
```
babylond tx staking edit-validator \
--new-moniker <BABYLON_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id bbn-test1 \
--commission-rate 0.05 \
--from <BABYLON_WALLET> \
--gas-prices 0.1ubbn \
--gas-adjustment 1.5
--gas auto
--yes
```
### View validator info
```
babylond q staking validator $(babylond keys show <BABYLON_WALLET> --bech val -a)
```
### Unjail validator
```
babylond tx slashing unjail --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
babylond query slashing signing-info $(babylond tendermint show-validator)
```

## Token operations

### Send tokens
```
babylond tx bank send wallet <DEST_WALLET_ADDRESS> 100ubbn --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
babylond tx staking delegate $(babylond keys show <BABYLON_WALLET> --bech val -a) 100ubbn --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
babylond tx staking delegate <VALOPER_ADDRESS> 100ubbn --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
babylond tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100ubbn --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
babylond tx staking unbond <VALOPER_ADDRESS> 100ubbn --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
babylond tx distribution withdraw-all-rewards --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
babylond tx gov vote <proposal_id> yes --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
babylond tx gov vote <proposal_id> no --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-prices 0.1ubbn --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
babylond tx gov vote <proposal_id> abstain --from <BABYLON_WALLET> --chain-id bbn-test1 --gas-adjustment 1.5 --gas auto --gas-prices 0.1ubbn -y
```

## General commands
### Check node status
```
babylond status | jq
```
### Check service status
```
sudo systemctl status babylond
```
### Check logs
```
sudo journalctl -u babylond -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart babylond
```
### Stop service
```
sudo systemctl stop babylond
```
### Start service
```
sudo systemctl start babylond
```
### Disable service
```
sudo systemctl disable babylond
```
### Enable service
```
sudo systemctl enable babylond
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
