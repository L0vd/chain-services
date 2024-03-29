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
| 8618419  | 10.6 GB  | custom/100/0/10 | null | 2023-11-23_16:52:27 |

```
sudo systemctl stop haqqd

cp $HOME/.haqqd/data/priv_validator_state.json $HOME/.haqqd/priv_validator_state.json.backup
haqqd tendermint unsafe-reset-all --home $HOME/.haqqd --keep-addr-book

rm -rf $HOME/.haqqd/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/haqq-mainnet/ | egrep -o ">haqq_11235-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/haqq-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.haqqd

mv $HOME/.haqqd/priv_validator_state.json.backup $HOME/.haqqd/data/priv_validator_state.json

sudo systemctl restart haqqd
sudo journalctl -u haqqd -f --no-hostname -o cat