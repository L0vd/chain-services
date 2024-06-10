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
| 12284016  | 2.0 GB  | custom/100/0/10 | null | 2024-06-10_04:13:44 |

```
sudo systemctl stop umeed

cp $HOME/.umee/data/priv_validator_state.json $HOME/.umee/priv_validator_state.json.backup
umeed tendermint unsafe-reset-all --home $HOME/.umee --keep-addr-book

rm -rf $HOME/.umee/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/umee-mainnet/ | egrep -o ">umee-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/umee-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.umee

mv $HOME/.umee/priv_validator_state.json.backup $HOME/.umee/data/priv_validator_state.json

sudo systemctl restart umeed
sudo journalctl -u umeed -f --no-hostname -o cat