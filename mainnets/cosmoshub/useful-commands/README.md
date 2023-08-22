{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
gaiad keys add <key_name>
```
### Recover keys from seed
```
gaiad keys add <key_name> --recover
```
### Show all keys
```
gaiad keys list
```
### Delete key
```
gaiad keys delete <key_name>
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
gaiad tx staking create-validator \
--amount 1000000uatom \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(gaiad tendermint show-validator) \
--moniker <COSMOSHUB_NODENAME> \
--chain-id cosmoshub-4 \
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
gaiad tx staking edit-validator \
--new-moniker <COSMOSHUB_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id cosmoshub-4 \
--commission-rate 0.05 \
--from <COSMOSHUB_WALLET> \
--gas-prices 0uatom \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
gaiad q staking validator $(gaiad keys show <COSMOSHUB_WALLET> --bech val -a)
```
### Unjail validator
```
gaiad tx slashing unjail --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
gaiad query slashing signing-info $(gaiad tendermint show-validator)
```

## Token operations

### Send tokens
```
gaiad tx bank send wallet <DEST_WALLET_ADDRESS> 100uatom --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
gaiad tx staking delegate $(gaiad keys show <COSMOSHUB_WALLET> --bech val -a) 100uatom --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
gaiad tx staking delegate <VALOPER_ADDRESS> 100uatom --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
gaiad tx staking redelegate $(gaiad keys show <COSMOSHUB_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uatom --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
gaiad tx staking unbond $(gaiad keys show <COSMOSHUB_WALLET> --bech val -a) 100uatom --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
gaiad tx distribution withdraw-all-rewards --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
gaiad tx distribution withdraw-rewards $(gaiad keys show <COSMOSHUB_WALLET> --bech val -a) --commission --from wallet --chain-id cosmoshub-4 --gas-adjustment 1.5 --gas auto --gas-prices 0uatom -y

```

## Governance
### Vote "YES"
```
gaiad tx gov vote <proposal_id> yes --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
gaiad tx gov vote <proposal_id> no --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-prices 0uatom --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
gaiad tx gov vote <proposal_id> abstain --from <COSMOSHUB_WALLET> --chain-id cosmoshub-4 --gas-adjustment 1.5 --gas auto --gas-prices 0uatom -y
```


## General commands
### Check node status
```
gaiad status | jq
```
### Check service status
```
sudo systemctl status gaiad
```
### Check logs
```
sudo journalctl -u gaiad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart gaiad
```
### Stop service
```
sudo systemctl stop gaiad
```
### Start service
```
sudo systemctl start gaiad
```
### Disable service
```
sudo systemctl disable gaiad
```
### Enable service
```
sudo systemctl enable gaiad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```