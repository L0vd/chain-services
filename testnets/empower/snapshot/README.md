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
| 428672  | 14GB  | custom/100/0/10 | null | 2023-06-28_05:27:59 |

```
sudo systemctl stop empowerd

cp $HOME/.empowerchain/data/priv_validator_state.json $HOME/.empowerchain/priv_validator_state.json.backup
empowerd tendermint unsafe-reset-all --home $HOME/.empowerchain --keep-addr-book

rm -rf $HOME/.empowerchain/data 

SNAP_NAME=$(curl -s http://snapshots.l0vd.com/empower/ | egrep -o ">circulus-1.*\.tar.lz4" | tr -d ">")
curl http://snapshots.l0vd.com/empower/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.empowerchain

mv $HOME/.empowerchain/priv_validator_state.json.backup $HOME/.empowerchain/data/priv_validator_state.json

sudo systemctl restart empowerd
sudo journalctl -u empowerd -f --no-hostname -o cat
```
