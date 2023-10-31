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
| 8281927  | 0.0 GB  | custom/100/0/10 | null | 2023-10-31_16:41:51 |

```
sudo systemctl stop haqqd

cp $HOME//data/priv_validator_state.json $HOME//priv_validator_state.json.backup
haqqd tendermint unsafe-reset-all --home $HOME/ --keep-addr-book

rm -rf $HOME//data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/haqq-mainnet/ | egrep -o ">haqq_11235-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/haqq-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/

mv $HOME//priv_validator_state.json.backup $HOME//data/priv_validator_state.json

sudo systemctl restart haqqd
sudo journalctl -u haqqd -f --no-hostname -o cat