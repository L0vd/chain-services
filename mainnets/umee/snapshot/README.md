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
| 13540670  | 1.71GB  | custom/100/0/10 | null | 2024-08-31T12:10:23 |

```
sudo systemctl stop umeed

cp $HOME/.umee/data/priv_validator_state.json $HOME/.umee/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.umee --keep-addr-book

rm -rf $HOME/.umee/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/mainnets/umee/umee-1/ | egrep -o ">umee-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/mainnets/umee/umee-1/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.umee/data

mv $HOME/.umee/priv_validator_state.json.backup $HOME/.umee/data/priv_validator_state.json

sudo systemctl restart umeed
sudo journalctl -u umeed -f --no-hostname -o cat
```
