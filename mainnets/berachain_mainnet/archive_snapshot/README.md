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
| 1053790  | 0.0GB  | all | all | 2025-02-12T18:34:42 |

```
mkdir $HOME/geth_snapshot
SNAP_NAME=$(curl -s https://berachain-snapshots.l0vd.com/mainnets/berachain_mainnet/80094/ | egrep -o ">80094.*\.tar.lz4" | tr -d ">")
curl https://berachain-snapshots.l0vd.com/mainnets/berachain_mainnet/80094/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/reth_snapshot
```
