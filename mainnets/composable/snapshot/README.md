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
| 1190135  | 0.4 GB  | custom/100/0/10 | null | 2023-08-24_09:01:35 |

```
sudo systemctl stop centaurid_main

cp $HOME/.banksy/data/priv_validator_state.json $HOME/.banksy/priv_validator_state.json.backup
centaurid_main tendermint unsafe-reset-all --home $HOME/.banksy --keep-addr-book

rm -rf $HOME/.banksy/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/composable-mainnet/ | egrep -o ">banksy-testnet-3.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/composable-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.banksy

mv $HOME/.banksy/priv_validator_state.json.backup $HOME/.banksy/data/priv_validator_state.json

sudo systemctl restart centaurid_main
sudo journalctl -u centaurid_main -f --no-hostname -o cat