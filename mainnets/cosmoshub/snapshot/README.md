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
| 17955581  | 6.6 GB  | custom/100/0/10 | null | 2023-11-22_03:26:24 |

```
sudo systemctl stop gaiad

cp $HOME/.gaia/data/priv_validator_state.json $HOME/.gaia/priv_validator_state.json.backup
gaiad tendermint unsafe-reset-all --home $HOME/.gaia --keep-addr-book

rm -rf $HOME/.gaia/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/cosmoshub-mainnet/ | egrep -o ">cosmoshub-4.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/cosmoshub-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.gaia

mv $HOME/.gaia/priv_validator_state.json.backup $HOME/.gaia/data/priv_validator_state.json

sudo systemctl restart gaiad
sudo journalctl -u gaiad -f --no-hostname -o cat