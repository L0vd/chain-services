# Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot ⚠️ (Pebbledb)
| Height  | Size | Pruning | Indexer | Creation Time (UTC+3) |
| --------- | --------- | --------- | --------- | --------- |
| 1278066  | 64.81GB  | nothing | kv | 2024-07-08T20:03:21 |

```
sudo systemctl stop beacond

cp $HOME/.beacond/data/priv_validator_state.json $HOME/.beacond/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.beacond --keep-addr-book

rm -rf $HOME/.beacond/data 

SNAP_NAME=$(curl -s https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/bartio-beacon-80084/ | egrep -o ">bartio-beacon-80084.*\.tar.lz4" | tr -d ">")
curl https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/bartio-beacon-80084/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.beacond

mv $HOME/.beacond/priv_validator_state.json.backup $HOME/.beacond/data/priv_validator_state.json

sudo systemctl restart beacond
sudo journalctl -u beacond -f --no-hostname -o cat
```
