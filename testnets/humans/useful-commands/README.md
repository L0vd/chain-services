{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
humansd keys add <key_name>
```
### Recover keys from seed
```
humansd keys add <key_name> --recover
```
### Show all keys
```
humansd keys list
```
### Delete key
```
humansd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
HUMANS_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${HUMANS_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${HUMANS_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${HUMANS_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${HUMANS_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${HUMANS_PORT}660\"%" $HOME/.humans/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${HUMANS_PORT}317\"%; s%^address = \":8080\"%address = \":${HUMANS_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${HUMANS_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${HUMANS_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${HUMANS_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${HUMANS_PORT}546\"%" $HOME/.humans/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.humans/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.humans/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.humans/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uheart\"/" $HOME/.humans/config/app.toml
```

## Validator configuration

### Create validator
```
humansd tx staking create-validator \
--amount 1000000uheart \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(humansd tendermint show-validator) \
--moniker <HUMANS_NODENAME> \
--chain-id testnet-1 \
--from <HUMANS_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1uheart \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
humansd tx staking edit-validator \
--new-moniker <HUMANS_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id testnet-1 \
--commission-rate 0.05 \
--from <HUMANS_WALLET> \
--gas-prices 0.1uheart \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
humansd q staking validator $(humansd keys show <HUMANS_WALLET> --bech val -a)
```
### Unjail validator
```
humansd tx slashing unjail --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
humansd query slashing signing-info $(humansd tendermint show-validator)
```

## Token operations

### Send tokens
```
humansd tx bank send wallet <DEST_WALLET_ADDRESS> 100uheart --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
humansd tx staking delegate $(humansd keys show <HUMANS_WALLET> --bech val -a) 100uheart --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
humansd tx staking delegate <VALOPER_ADDRESS> 100uheart --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
humansd tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100uheart --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
humansd tx staking unbond <VALOPER_ADDRESS> 100uheart --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
humansd tx distribution withdraw-all-rewards --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
humansd tx gov vote <proposal_id> yes --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
humansd tx gov vote <proposal_id> no --from <HUMANS_WALLET> --chain-id testnet-1 --gas-prices 0.1uheart --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
humansd tx gov vote <proposal_id> abstain --from <HUMANS_WALLET> --chain-id testnet-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.1uheart -y
```

## General commands
### Check node status
```
humansd status | jq
```
### Check service status
```
sudo systemctl status humansd
```
### Check logs
```
sudo journalctl -u humansd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart humansd
```
### Stop service
```
sudo systemctl stop humansd
```
### Start service
```
sudo systemctl start humansd
```
### Disable service
```
sudo systemctl disable humansd
```
### Enable service
```
sudo systemctl enable humansd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
