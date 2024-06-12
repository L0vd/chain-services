{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
nulld keys add <key_name>
```
### Recover keys from seed
```
nulld keys add <key_name> --recover
```
### Show all keys
```
nulld keys list
```
### Delete key
```
nulld keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
COSMOSHUB_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${COSMOSHUB_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${COSMOSHUB_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${COSMOSHUB_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${COSMOSHUB_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${COSMOSHUB_PORT}660\"%" /$HOME/.gaia/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${COSMOSHUB_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${COSMOSHUB_PORT}317\"%; s%^address = \":8080\"%address = \":${COSMOSHUB_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${COSMOSHUB_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${COSMOSHUB_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${COSMOSHUB_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${COSMOSHUB_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${COSMOSHUB_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${COSMOSHUB_PORT}546\"%" /$HOME/.gaia/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.gaia/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.gaia/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.gaia/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uatom\"/" $HOME/.gaia/config/app.toml
```

## Validator configuration

### Create validator
```
nulld tx staking create-validator \
--amount 1000000uatom \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(nulld tendermint show-validator) \
--moniker <COSMOSHUB_NODENAME> \
--chain-id  \
--from <COSMOSHUB_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0uatom \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
nulld tx staking edit-validator \
--new-moniker <COSMOSHUB_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id  \
--commission-rate 0.05 \
--from <COSMOSHUB_WALLET> \
--gas-prices 0uatom \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
nulld q staking validator $(nulld keys show <COSMOSHUB_WALLET> --bech val -a)
```
### Unjail validator
```
nulld tx slashing unjail --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
nulld query slashing signing-info $(nulld tendermint show-validator)
```

## Token operations

### Send tokens
```
nulld tx bank send wallet <DEST_WALLET_ADDRESS> 100uatom --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
nulld tx staking delegate $(nulld keys show <COSMOSHUB_WALLET> --bech val -a) 100uatom --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
nulld tx staking delegate <VALOPER_ADDRESS> 100uatom --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
nulld tx staking redelegate $(nulld keys show <COSMOSHUB_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uatom --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
nulld tx staking unbond $(nulld keys show <COSMOSHUB_WALLET> --bech val -a) 100uatom --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
nulld tx distribution withdraw-all-rewards --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
nulld tx distribution withdraw-rewards $(nulld keys show <COSMOSHUB_WALLET> --bech val -a) --commission --from wallet --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0uatom -y

```

## Governance
### Vote "YES"
```
nulld tx gov vote <proposal_id> yes --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
nulld tx gov vote <proposal_id> no --from <COSMOSHUB_WALLET> --chain-id  --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
nulld tx gov vote <proposal_id> abstain --from <COSMOSHUB_WALLET> --chain-id  --gas-adjustment 1.5 --gas auto --gas-prices 0uatom -y
```


## General commands
### Check node status
```
nulld status | jq
```
### Check service status
```
sudo systemctl status nulld
```
### Check logs
```
sudo journalctl -u nulld -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart nulld
```
### Stop service
```
sudo systemctl stop nulld
```
### Start service
```
sudo systemctl start nulld
```
### Disable service
```
sudo systemctl disable nulld
```
### Enable service
```
sudo systemctl enable nulld
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
