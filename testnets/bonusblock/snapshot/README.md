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
| 413896  | 1.4GB  | custom/100/0/10 | null | 2023-06-01_01:00:14 |

```
sudo systemctl stop bonus-blockd

cp $HOME/.bonusblock/data/priv_validator_state.json $HOME/.bonusblock/priv_validator_state.json.backup
bonus-blockd tendermint unsafe-reset-all --home $HOME/.bonusblock --keep-addr-book

rm -rf $HOME/.bonusblock/data

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/bonusblock/ | egrep -o ">blocktopia-01.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/bonusblock/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.bonusblock

mv $HOME/.bonusblock/priv_validator_state.json.backup $HOME/.bonusblock/data/priv_validator_state.json

sudo systemctl restart bonus-blockd
sudo journalctl -u bonus-blockd -f --no-hostname -o cat
```
