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
| 1573616  | 85.47GB  | nothing | kv | 2024-07-15T00:05:51 |

```
sudo systemctl stop beacond_archive

cp $HOME/.beacond_archive/data/priv_validator_state.json $HOME/.beacond_archive/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.beacond_archive --keep-addr-book

rm -rf $HOME/.beacond_archive/data 

SNAP_NAME=$(curl -s https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/bartio-beacon-80084/ | egrep -o ">bartio-beacon-80084.*\.tar.lz4" | tr -d ">")
curl https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/bartio-beacon-80084/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.beacond_archive

mv $HOME/.beacond_archive/priv_validator_state.json.backup $HOME/.beacond_archive/data/priv_validator_state.json

sudo systemctl restart beacond_archive
sudo journalctl -u beacond_archive -f --no-hostname -o cat
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
| 1443567  | 543.6GB  | all | all | 2024-07-15T00:38:42 |

```
mkdir $HOME/geth_snapshot
SNAP_NAME=$(curl -s https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/80084/ | egrep -o ">80084.*\.tar.lz4" | tr -d ">")
curl https://berachain-archive-snapshots.l0vd.com/testnets/berachain_v2/80084/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/geth_snapshot
```