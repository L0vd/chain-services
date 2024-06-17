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
| 400722  | 4.17B  | custom/100/0/10 | null | 2024-06-17T16:53:20 |

```
sudo systemctl stop beacond

cp $HOME/.beacond/data/priv_validator_state.json $HOME/.beacond/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.beacond --keep-addr-book

rm -rf $HOME/.beacond/data 

SNAP_NAME=$(curl -s https://berachain-pruned-snapshots.l0vd.com/berachain_v2-testnet/ | egrep -o ">bartio-beacon-80084.*\.tar.lz4" | tr -d ">")
curl https://berachain-pruned-snapshots.l0vd.com/berachain_v2-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.beacond

mv $HOME/.beacond/priv_validator_state.json.backup $HOME/.beacond/data/priv_validator_state.json

sudo systemctl restart beacond
sudo journalctl -u beacond -f --no-hostname -o cat
```

# Geth Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot  
| Height  | Size | State | Txs | Creation Time (UTC+3) |
| --------- | --------- | --------- | --------- | --------- |
| 351016  | 4.01B  | 1000 | 1000 | 2024-06-17T16:53:39 |

```
SNAP_NAME=$(curl -s https://berachain-pruned-snapshots.l0vd.com/berachain_v2-testnet/ | egrep -o ">80084.*\.tar.lz4" | tr -d ">")
curl https://berachain-pruned-snapshots.l0vd.com/berachain_v2-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/geth_snapshot
```