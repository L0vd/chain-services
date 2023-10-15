{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Keys

### Add new key
```
mantrachaind keys add <key_name>
```
### Recover keys from seed
```
mantrachaind keys add <key_name> --recover
```
### Show all keys
```
mantrachaind keys list
```
### Delete key
```
mantrachaind keys delete <key_name>
```

## Node configuration

### Set custom port

*port 56 was taken as an example, you can use numbers from 1 to 64 to set custom node port*

```
MANTRA_PORT=56
```
```
sed -i.bak -e "s%^proxy_app = \"tcp://127.0.0.1:26658\"%proxy_app = \"tcp://127.0.0.1:${MANTRA_PORT}658\"%; s%^laddr = \"tcp://127.0.0.1:26657\"%laddr = \"tcp://127.0.0.1:${MANTRA_PORT}657\"%; s%^pprof_laddr = \"localhost:6060\"%pprof_laddr = \"localhost:${MANTRA_PORT}060\"%; s%^laddr = \"tcp://0.0.0.0:26656\"%laddr = \"tcp://0.0.0.0:${MANTRA_PORT}656\"%; s%^prometheus_listen_addr = \":26660\"%prometheus_listen_addr = \":${MANTRA_PORT}660\"%" /$HOME/.mantrachain/config/config.toml
sed -i.bak -e "s%^address = \"tcp://0.0.0.0:1317\"%address = \"tcp://0.0.0.0:${MANTRA_PORT}317\"%; s%^address = \"tcp://localhost:1317\"%address = \"tcp://0.0.0.0:${MANTRA_PORT}317\"%; s%^address = \":8080\"%address = \":${MANTRA_PORT}080\"%; s%^address = \"0.0.0.0:9090\"%address = \"0.0.0.0:${MANTRA_PORT}090\"%; s%^address = \"localhost:9090\"%address = \"localhost:${MANTRA_PORT}090\"%; s%^address = \"0.0.0.0:9091\"%address = \"0.0.0.0:${MANTRA_PORT}091\"%; s%^address = \"localhost:9091\"%address = \"localhost:${MANTRA_PORT}091\"%; s%^address = \"0.0.0.0:8545\"%address = \"0.0.0.0:${MANTRA_PORT}545\"%; s%^ws-address = \"0.0.0.0:8546\"%ws-address = \"0.0.0.0:${MANTRA_PORT}546\"%" /$HOME/.mantrachain/config/app.toml
```
### Config pruning
```
pruning="custom"
pruning_keep_recent="100"
pruning_keep_every="0"
pruning_interval="10"
sed -i -e "s/^pruning *=.*/pruning = \"$pruning\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"$pruning_keep_recent\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-keep-every *=.*/pruning-keep-every = \"$pruning_keep_every\"/" $HOME/.mantrachain/config/app.toml
sed -i -e "s/^pruning-interval *=.*/pruning-interval = \"$pruning_interval\"/" $HOME/.mantrachain/config/app.toml
```
### Disable indexing
```
sed -i -e "s/^indexer *=.*/indexer = \"null\"/" $HOME/.mantrachain/config/config.toml
```
### Set minimum gas prices
```
sed -i -e "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0uaum\"/" $HOME/.mantrachain/config/app.toml
```

## Validator configuration

### Create validator
```
mantrachaind tx staking create-validator \
--amount 1000000uaum \
--commission-max-change-rate "0.01" \
--commission-max-rate "0.20" \
--commission-rate "0.1" \
--min-self-delegation "1" \
--pubkey $(mantrachaind tendermint show-validator) \
--moniker <MANTRA_NODENAME> \
--chain-id mantrachain-1 \
--from <MANTRA_WALLET> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--gas-prices 0uaum \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### Edit validator
```
mantrachaind tx staking edit-validator \
--new-moniker <MANTRA_NODENAME> \
--identity <KEYBASE_ID> \
--details <YOUR_TEXT> \
--website <YOUR_WEBSITE> \
--chain-id mantrachain-1 \
--commission-rate 0.05 \
--from <MANTRA_WALLET> \
--gas-prices 0uaum \
--gas-adjustment 1.5 \
--gas auto \
--yes
```
### View validator info
```
mantrachaind q staking validator $(mantrachaind keys show <MANTRA_WALLET> --bech val -a)
```
### Unjail validator
```
mantrachaind tx slashing unjail --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes 
```
### Signing info
```
mantrachaind query slashing signing-info $(mantrachaind tendermint show-validator)
```

## Token operations

### Send tokens
```
mantrachaind tx bank send wallet <DEST_WALLET_ADDRESS> 100uaum --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to your validator
```
mantrachaind tx staking delegate $(mantrachaind keys show <MANTRA_WALLET> --bech val -a) 100uaum --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Delegate token to another validator
```
mantrachaind tx staking delegate <VALOPER_ADDRESS> 100uaum --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Redelegate tokens to another validator
```
mantrachaind tx staking redelegate $(mantrachaind keys show <MANTRA_WALLET> --bech val -a) <TO_VALOPER_ADDRESS> 100uaum --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Unbond tokens from staking
```
mantrachaind tx staking unbond $(mantrachaind keys show <MANTRA_WALLET> --bech val -a) 100uaum --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Withdraw all rewards from staking
```
mantrachaind tx distribution withdraw-all-rewards --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```

### Withdraw validator rewards and comission
```
mantrachaind tx distribution withdraw-rewards $(mantrachaind keys show <MANTRA_WALLET> --bech val -a) --commission --from wallet --chain-id mantrachain-1 --gas-adjustment 1.5 --gas auto --gas-prices 0uaum -y

```

## Governance
### Vote "YES"
```
mantrachaind tx gov vote <proposal_id> yes --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Vote "NO"
```
mantrachaind tx gov vote <proposal_id> no --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-prices 0uaum --gas-adjustment 1.5 --gas auto --yes
```
### Abstain from voting
```
mantrachaind tx gov vote <proposal_id> abstain --from <MANTRA_WALLET> --chain-id mantrachain-1 --gas-adjustment 1.5 --gas auto --gas-prices 0uaum -y
```


## General commands
### Check node status
```
mantrachaind status | jq
```
### Check service status
```
sudo systemctl status mantrachaind
```
### Check logs
```
sudo journalctl -u mantrachaind -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart mantrachaind
```
### Stop service
```
sudo systemctl stop mantrachaind
```
### Start service
```
sudo systemctl start mantrachaind
```
### Disable service
```
sudo systemctl disable mantrachaind
```
### Enable service
```
sudo systemctl enable mantrachaind
```
### Reload service after changes
```
sudo systemctl daemon-reload
```