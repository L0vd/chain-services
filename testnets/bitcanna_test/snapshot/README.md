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
| 8327868  | 34.31B  | custom/100/0/10 | null | 2024-06-16T18:06:02 |

```
sudo systemctl stop bcnad

cp $HOME//root/.bcna/data/priv_validator_state.json $HOME//root/.bcna/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME//root/.bcna --keep-addr-book

rm -rf $HOME//root/.bcna/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/bitcanna_test-testnet/ | egrep -o ">bitcanna-dev-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/bitcanna_test-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME//root/.bcna

mv $HOME//root/.bcna/priv_validator_state.json.backup $HOME//root/.bcna/data/priv_validator_state.json

sudo systemctl restart bcnad
sudo journalctl -u bcnad -f --no-hostname -o cat