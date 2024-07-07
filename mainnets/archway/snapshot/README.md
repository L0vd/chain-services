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
| 5381191  | 1.58GB  | custom/100/0/10 | null | 2024-07-07T16:08:22 |

```
sudo systemctl stop archwayd

cp $HOME/.archway/data/priv_validator_state.json $HOME/.archway/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.archway --keep-addr-book

rm -rf $HOME/.archway/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/mainnets/archway/archway-1/ | egrep -o ">archway-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/mainnets/archway/archway-1/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.archway

mv $HOME/.archway/priv_validator_state.json.backup $HOME/.archway/data/priv_validator_state.json

sudo systemctl restart archwayd
sudo journalctl -u archwayd -f --no-hostname -o cat
```