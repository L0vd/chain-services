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
| 21948358  | 1.2 GB  | custom/100/0/10 | null | 2023-10-11_02:08:36 |

```
sudo systemctl stop iris

cp $HOME/.iris/data/priv_validator_state.json $HOME/.iris/priv_validator_state.json.backup
iris tendermint unsafe-reset-all --home $HOME/.iris --keep-addr-book

rm -rf $HOME/.iris/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/iris-mainnet/ | egrep -o ">irishub-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/iris-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.iris

mv $HOME/.iris/priv_validator_state.json.backup $HOME/.iris/data/priv_validator_state.json

sudo systemctl restart iris
sudo journalctl -u iris -f --no-hostname -o cat