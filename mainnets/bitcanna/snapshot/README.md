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
| 9322265  | 8.4GB  | custom/100/0/10 | null | 2023-07-07_09:12:51 |

```
sudo systemctl stop bcnad

cp $HOME/.bcna/data/priv_validator_state.json $HOME/.bcna/priv_validator_state.json.backup
bcnad tendermint unsafe-reset-all --home $HOME/.bcna --keep-addr-book

rm -rf $HOME/.bcna/data 

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/bitcanna/ | egrep -o ">bitcanna-1.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/bitcanna/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.bcna

mv $HOME/.bcna/priv_validator_state.json.backup $HOME/.bcna/data/priv_validator_state.json

sudo systemctl restart bcnad
sudo journalctl -u bcnad -f --no-hostname -o cat
```
