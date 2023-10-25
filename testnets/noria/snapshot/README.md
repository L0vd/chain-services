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
| 3321161  | 0.1 GB  | custom/100/0/10 | null | 2023-10-26_01:03:35 |

```
sudo systemctl stop noriad

cp $HOME/.noria/data/priv_validator_state.json $HOME/.noria/priv_validator_state.json.backup
noriad tendermint unsafe-reset-all --home $HOME/.noria --keep-addr-book

rm -rf $HOME/.noria/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/noria-testnet/ | egrep -o ">oasis-3.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/noria-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.noria

mv $HOME/.noria/priv_validator_state.json.backup $HOME/.noria/data/priv_validator_state.json

sudo systemctl restart noriad
sudo journalctl -u noriad -f --no-hostname -o cat