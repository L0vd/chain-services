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
| 9644018  | 0.6 GB  | custom/100/0/10 | null | 2023-07-29_05:06:54 |

```
sudo systemctl stop bcnad

cp $HOME/.bcna/data/priv_validator_state.json $HOME/.bcna/priv_validator_state.json.backup
bcnad tendermint unsafe-reset-all --home $HOME/.bcna --keep-addr-book

rm -rf $HOME/.bcna/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/bitcanna-mainnet/ | egrep -o ">bitcanna-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/bitcanna-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.bcna

mv $HOME/.bcna/priv_validator_state.json.backup $HOME/.bcna/data/priv_validator_state.json

sudo systemctl restart bcnad
sudo journalctl -u bcnad -f --no-hostname -o cat