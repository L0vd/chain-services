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
| 3321419  | 20GB  | custom/100/0/10 | null | 2023-07-23_13:22:49 |

```
sudo systemctl stop gitopiad

cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia --keep-addr-book

rm -rf $HOME/.gitopia/data 

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/gitopia/ | egrep -o ">gitopia.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/gitopia/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.gitopia

mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl restart gitopiad
sudo journalctl -u gitopiad -f --no-hostname -o cat
```
