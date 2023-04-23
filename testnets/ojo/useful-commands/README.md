{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
ojod keys add <key_name>
```
### Recover keys from seed
```
ojod keys add <key_name> --recover
```
### Show all keys
```
ojod keys list
```
### Delete key
```
ojod keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
OJO_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OJO_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OJO_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OJO_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OJO_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OJO_PORT}660\"%" $HOME/.ojo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OJO_PORT}317\"%; s%^address = \":8080\"%address = \":${OJO_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OJO_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OJO_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OJO_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OJO_PORT}546\"%" $HOME/.ojo/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ojo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ojo/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.ojo/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uojo\"/" $HOME/.ojo/config/app.toml
```

## Validator configuration

### Create validator
```
ojod tx staking create-validator \
--amount 90000uojo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(ojod tendermint show-validator) \
--moniker <OJO_NODENAME> \
--chain-id ojo-devnet \
--from <OJO_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1uojo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
ojod tx staking edit-validator \
--new-moniker <OJO_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id ojo-devnet \
--commission-rate 0.05 \
--from <OJO_WALLET> \
--gas-prices 0.1uojo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
ojod q staking validator $(ojod keys show <OJO_WALLET> --bech val -a)
```
### Unjail validator
```
ojod tx slashing unjail --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
ojod query slashing signing-info $(ojod tendermint show-validator)
```

## Token operations

### Send tokens
```
ojod tx bank send wallet <DEST_WALLET_ADDRESS> 100uojo --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
ojod tx staking delegate $(ojod keys show <OJO_WALLET> --bech val -a) 100uojo --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
ojod tx staking delegate <VALOPER_ADDRESS> 100uojo --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
ojod tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100uojo --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
ojod tx staking unbond <VALOPER_ADDRESS> 100uojo --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
ojod tx distribution withdraw-all-rewards --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
ojod tx gov vote <proposal_id> yes --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
ojod tx gov vote <proposal_id> no --from <OJO_WALLET> --chain-id ojo-devnet --gas-prices 0.1uojo --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
ojod tx gov vote <proposal_id> abstain --from <OJO_WALLET> --chain-id ojo-devnet --gas-adjustment 1.5 --gas auto --gas-prices 0.1uojo -y
```

## Price-feeder commands
### Check logs
```
sudo journalctl -u ojo-price-feeder -f --no-hostname -o cat
```

### Delegate pfd rights to different wallet than the one used to create a validator
```
ojod tx oracle delegate-feed-consent <MAIN_WALLET_ADDRESS> <PFD_WALLET_ADDRESS> --from $OJO_WALLET --gas-adjustment 1.5 --gas auto --gas-prices 0.1uojo --yes
```

### Check price-feeder delegated address
```
ojod q oracle feeder-delegation <VALOPER_ADDRESS>
```

### Check missed price-feeder votes
```
ojod q oracle miss-counter <VALOPER_ADDRESS>
```

## General commands
### Check node status
```
ojod status | jq
```
### Check service status
```
sudo systemctl status ojod
```
### Check logs
```
sudo journalctl -u ojod -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart ojod
```
### Stop service
```
sudo systemctl stop ojod
```
### Start service
```
sudo systemctl start ojod
```
### Disable service
```
sudo systemctl disable ojod
```
### Enable service
```
sudo systemctl enable ojod
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
