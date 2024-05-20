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
| 7324631  | 4.8 GB  | custom/100/0/10 | null | 2024-05-20_06:43:02 |

```
sudo systemctl stop artelad

cp $HOME//data/priv_validator_state.json $HOME//priv_validator_state.json.backup
artelad tendermint unsafe-reset-all --home $HOME/ --keep-addr-book

rm -rf $HOME//data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/artela-testnet/ | egrep -o ">artela_11822-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/artela-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/

mv $HOME//priv_validator_state.json.backup $HOME//data/priv_validator_state.json

sudo systemctl restart artelad
sudo journalctl -u artelad -f --no-hostname -o cat