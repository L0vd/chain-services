{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
empowerd keys add <key_name>
```
### Recover keys from seed
```
empowerd keys add <key_name> --recover
```
### Show all keys
```
empowerd keys list
```
### Delete key
```
empowerd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
EMPOWER_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${EMPOWER_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${EMPOWER_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${EMPOWER_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${EMPOWER_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${EMPOWER_PORT}660\"%" $HOME/.empowerchain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${EMPOWER_PORT}317\"%; s%^address = \":8080\"%address = \":${EMPOWER_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${EMPOWER_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${EMPOWER_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${EMPOWER_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${EMPOWER_PORT}546\"%" $HOME/.empowerchain/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.empowerchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.empowerchain/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.empowerchain/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.1umpwr\"/" $HOME/.empowerchain/config/app.toml
```

## Validator configuration

### Create validator
```
empowerd tx staking create-validator \
--amount 1000000umpwr \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(empowerd tendermint show-validator) \
--moniker <EMPOWER_NODENAME> \
--chain-id circulus-1 \
--from <EMPOWER_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1umpwr \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
empowerd tx staking edit-validator \
--new-moniker <EMPOWER_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id circulus-1 \
--commission-rate 0.05 \
--from <EMPOWER_WALLET> \
--gas-prices 0.1umpwr \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
empowerd q staking validator $(empowerd keys show <EMPOWER_WALLET> --bech val -a)
```
### Unjail validator
```
empowerd tx slashing unjail --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
empowerd query slashing signing-info $(empowerd tendermint show-validator)
```

## Token operations

### Send tokens
```
empowerd tx bank send wallet <DEST_WALLET_ADDRESS> 100umpwr --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
empowerd tx staking delegate $(empowerd keys show <EMPOWER_WALLET> --bech val -a) 100umpwr --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
empowerd tx staking delegate <VALOPER_ADDRESS> 100umpwr --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
empowerd tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100umpwr --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
empowerd tx staking unbond <VALOPER_ADDRESS> 100umpwr --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
empowerd tx distribution withdraw-all-rewards --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
empowerd tx gov vote <proposal_id> yes --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
empowerd tx gov vote <proposal_id> no --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-prices 0.1umpwr --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
empowerd tx gov vote <proposal_id> abstain --from <EMPOWER_WALLET> --chain-id circulus-1 --gas-adjustment 1.5 --gas auto --gas-prices 0.1umpwr -y
```


## General commands
### Check node status
```
empowerd status | jq
```
### Check service status
```
sudo systemctl status empowerd
```
### Check logs
```
sudo journalctl -u empowerd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart empowerd
```
### Stop service
```
sudo systemctl stop empowerd
```
### Start service
```
sudo systemctl start empowerd
```
### Disable service
```
sudo systemctl disable empowerd
```
### Enable service
```
sudo systemctl enable empowerd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```