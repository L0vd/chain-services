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
| 743093  | 5.3 GB  | custom/100/0/10 | null | 2023-07-25_13:22:21 |

```
sudo systemctl stop banksyd

cp $HOME/.banksy/data/priv_validator_state.json $HOME/.banksy/priv_validator_state.json.backup
banksyd tendermint unsafe-reset-all --home $HOME/.banksy --keep-addr-book

rm -rf $HOME/.banksy/data 

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/composable-mainnet/ | egrep -o ">centauri-1.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/composable-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.banksy

mv $HOME/.banksy/priv_validator_state.json.backup $HOME/.banksy/data/priv_validator_state.json

sudo systemctl restart banksyd
sudo journalctl -u banksyd -f --no-hostname -o cat
```
