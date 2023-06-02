{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
gitopiad keys add <key_name>
```
### Recover keys from seed
```
gitopiad keys add <key_name> --recover
```
### Show all keys
```
gitopiad keys list
```
### Delete key
```
gitopiad keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
GITOPIA_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${GITOPIA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${GITOPIA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${GITOPIA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${GITOPIA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${GITOPIA_PORT}660\"%" $HOME/.gitopia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${GITOPIA_PORT}317\"%; s%^address = \":8080\"%address = \":${GITOPIA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${GITOPIA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${GITOPIA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${GITOPIA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${GITOPIA_PORT}546\"%" $HOME/.gitopia/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.gitopia/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gitopia/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.gitopia/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.1ulore\"/" $HOME/.gitopia/config/app.toml
```

## Validator configuration

### Create validator
```
gitopiad tx staking create-validator \
--amount 1000000ulore \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(gitopiad tendermint show-validator) \
--moniker <GITOPIA_NODENAME> \
--chain-id gitopia \
--from <GITOPIA_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1ulore \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
gitopiad tx staking edit-validator \
--new-moniker <GITOPIA_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id gitopia \
--commission-rate 0.05 \
--from <GITOPIA_WALLET> \
--gas-prices 0.1ulore \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
gitopiad q staking validator $(gitopiad keys show <GITOPIA_WALLET> --bech val -a)
```
### Unjail validator
```
gitopiad tx slashing unjail --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
gitopiad query slashing signing-info $(gitopiad tendermint show-validator)
```

## Token operations

### Send tokens
```
gitopiad tx bank send wallet <DEST_WALLET_ADDRESS> 100ulore --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
gitopiad tx staking delegate $(gitopiad keys show <GITOPIA_WALLET> --bech val -a) 100ulore --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
gitopiad tx staking delegate <VALOPER_ADDRESS> 100ulore --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
gitopiad tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100ulore --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
gitopiad tx staking unbond <VALOPER_ADDRESS> 100ulore --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
gitopiad tx distribution withdraw-all-rewards --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
gitopiad tx gov vote <proposal_id> yes --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
gitopiad tx gov vote <proposal_id> no --from <GITOPIA_WALLET> --chain-id gitopia --gas-prices 0.1ulore --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
gitopiad tx gov vote <proposal_id> abstain --from <GITOPIA_WALLET> --chain-id gitopia --gas-adjustment 1.5 --gas auto --gas-prices 0.1ulore -y
```


## General commands
### Check node status
```
gitopiad status | jq
```
### Check service status
```
sudo systemctl status gitopiad
```
### Check logs
```
sudo journalctl -u gitopiad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart gitopiad
```
### Stop service
```
sudo systemctl stop gitopiad
```
### Start service
```
sudo systemctl start gitopiad
```
### Disable service
```
sudo systemctl disable gitopiad
```
### Enable service
```
sudo systemctl enable gitopiad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
