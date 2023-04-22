{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
ollod keys add <key_name>
```
### Recover keys from seed
```
ollod keys add <key_name> --recover
```
### Show all keys
```
ollod keys list
```
### Delete key
```
ollod keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
OLLO_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${OLLO_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${OLLO_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${OLLO_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${OLLO_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${OLLO_PORT}660\"%" $HOME/.ollo/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${OLLO_PORT}317\"%; s%^address = \":8080\"%address = \":${OLLO_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${OLLO_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${OLLO_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${OLLO_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${OLLO_PORT}546\"%" $HOME/.ollo/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.ollo/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.ollo/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.ollo/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0utollo\"/" $HOME/.ollo/config/app.toml
```

## Validator configuration

### Create validator
```
ollod tx staking create-validator \
--amount 90000utollo \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(ollod tendermint show-validator) \
--moniker <OLLO_NODENAME> \
--chain-id ollo-testnet-1 \
--from <OLLO_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1utollo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
ollod tx staking edit-validator \
--new-moniker <OLLO_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id ollo-testnet-1 \
--commission-rate 0.05 \
--from <OLLO_WALLET> \
--gas-prices 0.1utollo \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
ollod q staking validator $(ollod keys show <OLLO_WALLET> --bech val -a)
```
### Unjail validator
```
ollod tx slashing unjail --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
ollod query slashing signing-info $(ollod tendermint show-validator)
```

## Token operations

### Send tokens
```
ollod tx bank send wallet <DEST_WALLET_ADDRESS> 100utollo --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
ollod tx staking delegate $(ollod keys show <OLLO_WALLET> --bech val -a) 100utollo --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
ollod tx staking delegate <VALOPER_ADDRESS> 100utollo --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
ollod tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100utollo --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
ollod tx staking unbond <VALOPER_ADDRESS> 100utollo --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
ollod tx distribution withdraw-all-rewards --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
ollod tx gov vote <proposal_id> yes --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
ollod tx gov vote <proposal_id> no --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-prices 0.1utollo --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
ollod tx gov vote <proposal_id> abstain --from <OLLO_WALLET> --chain-id ollo-testnet-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.1utollo -y
```

## General commands
### Check node status
```
ollod status | jq
```
### Check service status
```
sudo systemctl status ollod
```
### Check logs
```
sudo journalctl -u ollod -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart ollod
```
### Stop service
```
sudo systemctl stop ollod
```
### Start service
```
sudo systemctl start ollod
```
### Disable service
```
sudo systemctl disable ollod
```
### Enable service
```
sudo systemctl enable ollod
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
