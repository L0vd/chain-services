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
| 1020083  | 49.2GB  | nothing | kv | 2024-07-02T16:02:39 |

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

# Geth Archive Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot  
| Height  | Size | State | Txs | Creation Time (UTC+3) |
| --------- | --------- | --------- | --------- | --------- |
| 929639  | 261.19GB  | all | all | 2024-07-02T16:16:45 |

```
SNAP_NAME=$(curl -s https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/80084/ | egrep -o ">80084.*\.tar.lz4" | tr -d ">")
curl https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/80084/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/geth_snapshot
```