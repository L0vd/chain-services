{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
defundd keys add <key_name>
```
### Recover keys from seed
```
defundd keys add <key_name> --recover
```
### Show all keys
```
defundd keys list
```
### Delete key
```
defundd keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
DEFUND_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${DEFUND_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${DEFUND_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${DEFUND_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${DEFUND_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${DEFUND_PORT}660\"%" $HOME/.defund/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${DEFUND_PORT}317\"%; s%^address = \":8080\"%address = \":${DEFUND_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${DEFUND_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${DEFUND_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${DEFUND_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${DEFUND_PORT}546\"%" $HOME/.defund/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="50"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.defund/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.defund/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.defund/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ufetf\"/" $HOME/.defund/config/app.toml
```

## Validator configuration

### Create validator
```
defundd tx staking create-validator \
--amount 1000000ufetf \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey=$(defundd tendermint show-validator) \
--moniker <DEFUND_NODENAME> \
--chain-id galileo-3 \
--from <DEFUND_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0.1ufetf \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
defundd tx staking edit-validator \
--new-moniker <DEFUND_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id galileo-3 \
--commission-rate 0.05 \
--from <DEFUND_WALLET> \
--gas-prices 0.1ufetf \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
defundd q staking validator $(defundd keys show <DEFUND_WALLET> --bech val -a)
```
### Unjail validator
```
defundd tx slashing unjail --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
defundd query slashing signing-info $(defundd tendermint show-validator)
```

## Token operations

### Send tokens
```
defundd tx bank send wallet <DEST_WALLET_ADDRESS> 100ufetf --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
defundd tx staking delegate $(defundd keys show <DEFUND_WALLET> --bech val -a) 100ufetf --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
defundd tx staking delegate <VALOPER_ADDRESS> 100ufetf --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
defundd tx staking redelegate <FROM_VALOPER_ADDRESS> <TO_VALOPER_ADDRESS> 100ufetf --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
defundd tx staking unbond <VALOPER_ADDRESS> 100ufetf --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
defundd tx distribution withdraw-all-rewards --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```

## Governance
### Vote "YES"
```
defundd tx gov vote <proposal_id> yes --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
defundd tx gov vote <proposal_id> no --from <DEFUND_WALLET> --chain-id galileo-3 --gas-prices 0.1ufetf --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
defundd tx gov vote <proposal_id> abstain --from <DEFUND_WALLET> --chain-id galileo-3 --gas-adjustment 1.5 --gas auto --gas-prices 0.1ufetf -y
```

## General commands
### Check node status
```
defundd status | jq
```
### Check service status
```
sudo systemctl status defundd
```
### Check logs
```
sudo journalctl -u defundd -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart defundd
```
### Stop service
```
sudo systemctl stop defundd
```
### Start service
```
sudo systemctl start defundd
```
### Disable service
```
sudo systemctl disable defundd
```
### Enable service
```
sudo systemctl enable defundd
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
