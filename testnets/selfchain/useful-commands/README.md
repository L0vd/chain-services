{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
selfchaind keys add <key_name>
```
### Recover keys from seed
```
selfchaind keys add <key_name> --recover
```
### Show all keys
```
selfchaind keys list
```
### Delete key
```
selfchaind keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
SELFCHAIN_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${SELFCHAIN_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${SELFCHAIN_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${SELFCHAIN_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${SELFCHAIN_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${SELFCHAIN_PORT}660\"%" /$HOME/.selfchain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${SELFCHAIN_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${SELFCHAIN_PORT}317\"%; s%^address = \":8080\"%address = \":${SELFCHAIN_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${SELFCHAIN_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${SELFCHAIN_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${SELFCHAIN_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${SELFCHAIN_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${SELFCHAIN_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${SELFCHAIN_PORT}546\"%" /$HOME/.selfchain/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.selfchain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.selfchain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.selfchain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.selfchain/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.selfchain/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uself\"/" $HOME/.selfchain/config/app.toml
```

## Validator configuration

### Create validator
```
selfchaind tx staking create-validator \
--amount 1000000uself \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(selfchaind tendermint show-validator) \
--moniker <SELFCHAIN_NODENAME> \
--chain-id self-dev-1 \
--from <SELFCHAIN_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0uself \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
selfchaind tx staking edit-validator \
--new-moniker <SELFCHAIN_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id self-dev-1 \
--commission-rate 0.05 \
--from <SELFCHAIN_WALLET> \
--gas-prices 0uself \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
selfchaind q staking validator $(selfchaind keys show <SELFCHAIN_WALLET> --bech val -a)
```
### Unjail validator
```
selfchaind tx slashing unjail --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
selfchaind query slashing signing-info $(selfchaind tendermint show-validator)
```

## Token operations

### Send tokens
```
selfchaind tx bank send wallet <DEST_WALLET_ADDRESS> 100uself --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
selfchaind tx staking delegate $(selfchaind keys show <SELFCHAIN_WALLET> --bech val -a) 100uself --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
selfchaind tx staking delegate <VALOPER_ADDRESS> 100uself --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
selfchaind tx staking redelegate $(selfchaind keys show <SELFCHAIN_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uself --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
selfchaind tx staking unbond $(selfchaind keys show <SELFCHAIN_WALLET> --bech val -a) 100uself --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
selfchaind tx distribution withdraw-all-rewards --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
selfchaind tx distribution withdraw-rewards $(selfchaind keys show <SELFCHAIN_WALLET> --bech val -a) --commission --from wallet --chain-id self-dev-1 --gas-adjustment 1.5 --gas auto --gas-prices 0uself -y

```

## Governance
### Vote "YES"
```
selfchaind tx gov vote <proposal_id> yes --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
selfchaind tx gov vote <proposal_id> no --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-prices 0uself --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
selfchaind tx gov vote <proposal_id> abstain --from <SELFCHAIN_WALLET> --chain-id self-dev-1 --gas-adjustment 1.5 --gas auto --gas-prices 0uself -y
```


## General commands
### Check node status
```
selfchaind status | jq
```
### Check service status
```
sudo systemctl status selfchaind
```
### Check logs
```
sudo journalctl -u selfchaind -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart selfchaind
```
### Stop service
```
sudo systemctl stop selfchaind
```
### Start service
```
sudo systemctl start selfchaind
```
### Disable service
```
sudo systemctl disable selfchaind
```
### Enable service
```
sudo systemctl enable selfchaind
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
