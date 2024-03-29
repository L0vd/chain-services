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
| 3430321  | 0.3 GB  | custom/100/0/10 | null | 2024-03-29_22:28:07 |

```
sudo systemctl stop arkeod

cp $HOME/.arkeo/data/priv_validator_state.json $HOME/.arkeo/priv_validator_state.json.backup
arkeod tendermint unsafe-reset-all --home $HOME/.arkeo --keep-addr-book

rm -rf $HOME/.arkeo/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/arkeo-testnet/ | egrep -o ">arkeo.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/arkeo-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.arkeo

mv $HOME/.arkeo/priv_validator_state.json.backup $HOME/.arkeo/data/priv_validator_state.json

sudo systemctl restart arkeod
sudo journalctl -u arkeod -f --no-hostname -o cat