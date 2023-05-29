{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
banksyd keys add <key_name>
```
### Recover keys from seed
```
banksyd keys add <key_name> --recover
```
### Show all keys
```
banksyd keys list
```
### Delete key
```
banksyd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
BANKSY_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${BANKSY_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${BANKSY_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${BANKSY_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${BANKSY_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${BANKSY_PORT}660\"%" $HOME/.banksy/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${BANKSY_PORT}317\"%; s%^address = \":8080\"%address = \":${BANKSY_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${BANKSY_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${BANKSY_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${BANKSY_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${BANKSY_PORT}546\"%" $HOME/.banksy/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.banksy/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.banksy/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.banksy/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.1ppica\"/" $HOME/.banksy/config/app.toml
```

## Validator configuration

### Create validator
```
banksyd tx staking create-validator \
--amount 1000000ppica \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(banksyd tendermint show-validator) \
--moniker <BANKSY_NODENAME> \
--chain-id banksy-testnet-3 \
--from <BANKSY_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1ppica \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
banksyd tx staking edit-validator \
--new-moniker <BANKSY_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id banksy-testnet-3 \
--commission-rate 0.05 \
--from <BANKSY_WALLET> \
--gas-prices 0.1ppica \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
banksyd q staking validator $(banksyd keys show <BANKSY_WALLET> --bech val -a)
```
### Unjail validator
```
banksyd tx slashing unjail --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
banksyd query slashing signing-info $(banksyd tendermint show-validator)
```

## Token operations

### Send tokens
```
banksyd tx bank send wallet <DEST_WALLET_ADDRESS> 100ppica --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
banksyd tx staking delegate $(banksyd keys show <BANKSY_WALLET> --bech val -a) 100ppica --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
banksyd tx staking delegate <VALOPER_ADDRESS> 100ppica --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
banksyd tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100ppica --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
banksyd tx staking unbond <VALOPER_ADDRESS> 100ppica --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
banksyd tx distribution withdraw-all-rewards --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
banksyd tx gov vote <proposal_id> yes --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
banksyd tx gov vote <proposal_id> no --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-prices 0.1ppica --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
banksyd tx gov vote <proposal_id> abstain --from <BANKSY_WALLET> --chain-id banksy-testnet-3 --gas-adjustment 1.5 --gas auto --gas-prices 0.1ppica -y
```


## General commands
### Check node status
```
banksyd status | jq
```
### Check service status
```
sudo systemctl status banksyd
```
### Check logs
```
sudo journalctl -u banksyd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart banksyd
```
### Stop service
```
sudo systemctl stop banksyd
```
### Start service
```
sudo systemctl start banksyd
```
### Disable service
```
sudo systemctl disable banksyd
```
### Enable service
```
sudo systemctl enable banksyd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
