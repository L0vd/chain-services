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
| 150156  | 44.5 GB  | custom/100/0/10 | null | 2023-07-13_21:31:56 |

```
sudo systemctl stop archwayd

cp $HOME/.archway/data/priv_validator_state.json $HOME/.archway/priv_validator_state.json.backup
archwayd tendermint unsafe-reset-all --home $HOME/.archway --keep-addr-book

rm -rf $HOME/.archway/data 

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/archway/ | egrep -o ">archway-1.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/archway/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.archway

mv $HOME/.archway/priv_validator_state.json.backup $HOME/.archway/data/priv_validator_state.json

sudo systemctl restart archwayd
sudo journalctl -u archwayd -f --no-hostname -o cat
```
