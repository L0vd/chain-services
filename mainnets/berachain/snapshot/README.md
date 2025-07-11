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
| 7627513  | 89.22GB  | 1000 | kv | 2025-07-12T16:05:34 |

```
sudo systemctl stop beacond

cp $HOME/.beacond_mainnet_public/data/priv_validator_state.json $HOME/.beacond_mainnet_public/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.beacond_mainnet_public --keep-addr-book

rm -rf $HOME/.beacond_mainnet_public/data 

SNAP_NAME=$(curl -s https://berachain-snapshots.l0vd.com/mainnets/berachain/mainnet-beacon-80094/ | egrep -o ">mainnet-beacon-80094.*\.tar.lz4" | tr -d ">")
curl https://berachain-snapshots.l0vd.com/mainnets/berachain/mainnet-beacon-80094/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.beacond_mainnet_public

mv $HOME/.beacond_mainnet_public/priv_validator_state.json.backup $HOME/.beacond_mainnet_public/data/priv_validator_state.json

sudo systemctl restart beacond
sudo journalctl -u beacond -f --no-hostname -o cat
```

# Reth Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot  
| Height  | Size | State | Txs | Creation Time (UTC+3) |
| --------- | --------- | --------- | --------- | --------- |
| 7627510  | 70.16GB  | all | all | 2025-07-12T16:10:25 |

```
mkdir $HOME/geth_snapshot
SNAP_NAME=$(curl -s https://berachain-snapshots.l0vd.com/mainnets/berachain/80094/ | egrep -o ">80094.*\.tar.lz4" | tr -d ">")
curl https://berachain-snapshots.l0vd.com/mainnets/berachain/80094/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/reth_snapshot
```