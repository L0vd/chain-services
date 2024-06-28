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
| 9128692  | 21.25GB  | custom/100/0/10 | null | 2024-06-28T10:02:21 |

```
sudo systemctl stop artelad

cp $HOME/.artelad/data/priv_validator_state.json $HOME/.artelad/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.artelad --keep-addr-book

rm -rf $HOME/.artelad/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/testnets/artela/artela_11822-1/ | egrep -o ">artela_11822-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/testnets/artela/artela_11822-1/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.artelad

mv $HOME/.artelad/priv_validator_state.json.backup $HOME/.artelad/data/priv_validator_state.json

sudo systemctl restart artelad
sudo journalctl -u artelad -f --no-hostname -o cat
```