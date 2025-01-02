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
| 5062194  | 0.92GB  | custom/100/0/10 | null | 2025-01-02T10:08:21 |

```
sudo systemctl stop uniond

cp $HOME/.union/data/priv_validator_state.json $HOME/.union/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.union --keep-addr-book

rm -rf $HOME/.union/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/testnets/union/union-testnet-8/ | egrep -o ">union-testnet-8.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/testnets/union/union-testnet-8/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.union/data

mv $HOME/.union/priv_validator_state.json.backup $HOME/.union/data/priv_validator_state.json

sudo systemctl restart uniond
sudo journalctl -u uniond -f --no-hostname -o cat
```
