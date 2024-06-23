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
| 0  | 5.25GB  | custom/100/0/10 | null | 2024-06-23T10:30:45 |

```
sudo systemctl stop artelad

cp $HOME/.artela/data/priv_validator_state.json $HOME/.artela/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.artela --keep-addr-book

rm -rf $HOME/.artela/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/testnets/artela/artela_11822-1/ | egrep -o ">artela_11822-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/testnets/artela/artela_11822-1/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.artela

mv $HOME/.artela/priv_validator_state.json.backup $HOME/.artela/data/priv_validator_state.json

sudo systemctl restart artelad
sudo journalctl -u artelad -f --no-hostname -o cat
```