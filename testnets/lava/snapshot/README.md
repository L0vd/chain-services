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
| 466511  | 0.3 GB  | custom/100/0/10 | null | 2023-10-01_10:01:52 |

```
sudo systemctl stop lavad

cp $HOME/.lava/data/priv_validator_state.json $HOME/.lava/priv_validator_state.json.backup
lavad tendermint unsafe-reset-all --home $HOME/.lava --keep-addr-book

rm -rf $HOME/.lava/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/lava-testnet/ | egrep -o ">lava-testnet-2.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/lava-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.lava

mv $HOME/.lava/priv_validator_state.json.backup $HOME/.lava/data/priv_validator_state.json

sudo systemctl restart lavad
sudo journalctl -u lavad -f --no-hostname -o cat