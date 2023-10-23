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
| 1223624  | 1.4 GB  | custom/100/0/10 | null | 2023-10-23_17:07:45 |

```
sudo systemctl stop babylond

cp $HOME/.babylond/data/priv_validator_state.json $HOME/.babylond/priv_validator_state.json.backup
babylond tendermint unsafe-reset-all --home $HOME/.babylond --keep-addr-book

rm -rf $HOME/.babylond/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/babylon-testnet/ | egrep -o ">bbn-test-2.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/babylon-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.babylond

mv $HOME/.babylond/priv_validator_state.json.backup $HOME/.babylond/data/priv_validator_state.json

sudo systemctl restart babylond
sudo journalctl -u babylond -f --no-hostname -o cat