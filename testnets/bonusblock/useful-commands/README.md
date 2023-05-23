{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
bonus-blockd keys add <key_name>
```
### Recover keys from seed
```
bonus-blockd keys add <key_name> --recover
```
### Show all keys
```
bonus-blockd keys list
```
### Delete key
```
bonus-blockd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
BBLOCK_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BBLOCK_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BBLOCK_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BBLOCK_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BBLOCK_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BBLOCK_PORT}660\"%" $HOME/.bonusblock/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BBLOCK_PORT}317\"%; s%^address = \":8080\"%address = \":${BBLOCK_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BBLOCK_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BBLOCK_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BBLOCK_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BBLOCK_PORT}546\"%" $HOME/.bonusblock/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.bonusblock/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.bonusblock/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.bonusblock/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.1ubonus\"/" $HOME/.bonusblock/config/app.toml
```

## Validator configuration

### Create validator
```
bonus-blockd tx staking create-validator \
--amount 1000000ubonus \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(bonus-blockd tendermint show-validator) \
--moniker <BBLOCK_NODENAME> \
--chain-id blocktopia-01 \
--from <BBLOCK_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1ubonus \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
bonus-blockd tx staking edit-validator \
--new-moniker <BBLOCK_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id blocktopia-01 \
--commission-rate 0.05 \
--from <BBLOCK_WALLET> \
--gas-prices 0.1ubonus \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
bonus-blockd q staking validator $(bonus-blockd keys show <BBLOCK_WALLET> --bech val -a)
```
### Unjail validator
```
bonus-blockd tx slashing unjail --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
bonus-blockd query slashing signing-info $(bonus-blockd tendermint show-validator)
```

## Token operations

### Send tokens
```
bonus-blockd tx bank send wallet <DEST_WALLET_ADDRESS> 100ubonus --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
bonus-blockd tx staking delegate $(bonus-blockd keys show <BBLOCK_WALLET> --bech val -a) 100ubonus --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
bonus-blockd tx staking delegate <VALOPER_ADDRESS> 100ubonus --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
bonus-blockd tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100ubonus --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
bonus-blockd tx staking unbond <VALOPER_ADDRESS> 100ubonus --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
bonus-blockd tx distribution withdraw-all-rewards --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
bonus-blockd tx gov vote <proposal_id> yes --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
bonus-blockd tx gov vote <proposal_id> no --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-prices 0.1ubonus --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
bonus-blockd tx gov vote <proposal_id> abstain --from <BBLOCK_WALLET> --chain-id blocktopia-01 --gas-adjustment 1.5 --gas auto --gas-prices 0.1ubonus -y
```


## General commands
### Check node status
```
bonus-blockd status | jq
```
### Check service status
```
sudo systemctl status bonus-blockd
```
### Check logs
```
sudo journalctl -u bonus-blockd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart bonus-blockd
```
### Stop service
```
sudo systemctl stop bonus-blockd
```
### Start service
```
sudo systemctl start bonus-blockd
```
### Disable service
```
sudo systemctl disable bonus-blockd
```
### Enable service
```
sudo systemctl enable bonus-blockd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
