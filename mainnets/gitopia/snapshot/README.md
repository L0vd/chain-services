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
| 4933737  | 1.4 GB  | custom/100/0/10 | null | 2023-08-24_09:14:04 |

```
sudo systemctl stop gitopiad

cp $HOME/.gitopia/data/priv_validator_state.json $HOME/.gitopia/priv_validator_state.json.backup
gitopiad tendermint unsafe-reset-all --home $HOME/.gitopia --keep-addr-book

rm -rf $HOME/.gitopia/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/gitopia-mainnet/ | egrep -o ">gitopia.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/gitopia-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.gitopia

mv $HOME/.gitopia/priv_validator_state.json.backup $HOME/.gitopia/data/priv_validator_state.json

sudo systemctl restart gitopiad
sudo journalctl -u gitopiad -f --no-hostname -o cat