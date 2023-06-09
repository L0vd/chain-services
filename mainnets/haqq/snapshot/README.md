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
| 6680036  | 0.00 GB  | custom/100/0/10 | null | 2023-07-13_21:26:22 |

```
sudo systemctl stop haqqd

cp $HOME/.haqqd/data/priv_validator_state.json $HOME/.haqqd/priv_validator_state.json.backup
haqqd tendermint unsafe-reset-all --home $HOME/.haqqd --keep-addr-book

rm -rf $HOME/.haqqd/data 

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/haqq/ | egrep -o ">haqq_11235-1.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/haqq/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.haqqd

mv $HOME/.haqqd/priv_validator_state.json.backup $HOME/.haqqd/data/priv_validator_state.json

sudo systemctl restart haqqd
sudo journalctl -u haqqd -f --no-hostname -o cat
```
