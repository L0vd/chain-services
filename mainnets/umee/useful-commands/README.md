{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
umeed keys add <key_name>
```
### Recover keys from seed
```
umeed keys add <key_name> --recover
```
### Show all keys
```
umeed keys list
```
### Delete key
```
umeed keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
UMEE_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${UMEE_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${UMEE_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${UMEE_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${UMEE_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${UMEE_PORT}660\"%" $HOME/.umee/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${UMEE_PORT}317\"%; s%^address = \":8080\"%address = \":${UMEE_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${UMEE_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${UMEE_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${UMEE_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${UMEE_PORT}546\"%" $HOME/.umee/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.umee/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.umee/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.umee/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.1uumee\"/" $HOME/.umee/config/app.toml
```

## Validator configuration

### Create validator
```
umeed tx staking create-validator \
--amount 1000000uumee \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(umeed tendermint show-validator) \
--moniker <UMEE_NODENAME> \
--chain-id umee-1 \
--from <UMEE_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1uumee \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
umeed tx staking edit-validator \
--new-moniker <UMEE_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id umee-1 \
--commission-rate 0.05 \
--from <UMEE_WALLET> \
--gas-prices 0.1uumee \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
umeed q staking validator $(umeed keys show <UMEE_WALLET> --bech val -a)
```
### Unjail validator
```
umeed tx slashing unjail --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
umeed query slashing signing-info $(umeed tendermint show-validator)
```

## Token operations

### Send tokens
```
umeed tx bank send wallet <DEST_WALLET_ADDRESS> 100uumee --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
umeed tx staking delegate $(umeed keys show <UMEE_WALLET> --bech val -a) 100uumee --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
umeed tx staking delegate <VALOPER_ADDRESS> 100uumee --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
umeed tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100uumee --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
umeed tx staking unbond <VALOPER_ADDRESS> 100uumee --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
umeed tx distribution withdraw-all-rewards --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
umeed tx gov vote <proposal_id> yes --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
umeed tx gov vote <proposal_id> no --from <UMEE_WALLET> --chain-id umee-1 --gas-prices 0.1uumee --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
umeed tx gov vote <proposal_id> abstain --from <UMEE_WALLET> --chain-id umee-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.1uumee -y
```

## Price-feeder commands
### Check logs
```
sudo journalctl -u umee-price-feeder -f --no-hostname -o cat
```

### Restart price-feeder
```
sudo systemctl restart umee-price-feeder
```

### Delegate pfd rights to different wallet than the one used to create a validator
```
umeed tx oracle delegate-feed-consent <MAIN_WALLET_ADDRESS> <PFD_WALLET_ADDRESS> --from <UMEE_WALLET> --gas-adjustment 1.5 --gas auto --gas-prices 0.1uumee --yes
```

### Check price-feeder delegated address
```
umeed q oracle feeder-delegation <VALOPER_ADDRESS>
```

### Check missed price-feeder votes
```
umeed q oracle miss-counter <VALOPER_ADDRESS>
```

## General commands
### Check node status
```
umeed status | jq
```
### Check service status
```
sudo systemctl status umeed
```
### Check logs
```
sudo journalctl -u umeed -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart umeed
```
### Stop service
```
sudo systemctl stop umeed
```
### Start service
```
sudo systemctl start umeed
```
### Disable service
```
sudo systemctl disable umeed
```
### Enable service
```
sudo systemctl enable umeed
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
