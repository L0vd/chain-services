# Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot  
| Height  | Size | Pruning | Indexer | Creation Time (UTC+3) |
| --------- | --------- | --------- | --------- | --------- |
| 241182  | 0.2 GB  | custom/100/0/10 | null | 2023-12-23_17:39:50 |

```
sudo systemctl stop pryzmd

cp $HOME/.pryzm/data/priv_validator_state.json $HOME/.pryzm/priv_validator_state.json.backup
pryzmd tendermint unsafe-reset-all --home $HOME/.pryzm --keep-addr-book

rm -rf $HOME/.pryzm/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/pryzm-testnet/ | egrep -o ">indigo-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/pryzm-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.pryzm

mv $HOME/.pryzm/priv_validator_state.json.backup $HOME/.pryzm/data/priv_validator_state.json

sudo systemctl restart pryzmd
sudo journalctl -u pryzmd -f --no-hostname -o cat