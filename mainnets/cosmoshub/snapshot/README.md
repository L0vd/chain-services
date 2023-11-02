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
| 17680312  | 0.0 GB  | custom/100/0/10 | null | 2023-11-02_11:48:35 |

```
sudo systemctl stop gaiad

cp $HOME//data/priv_validator_state.json $HOME//priv_validator_state.json.backup
gaiad tendermint unsafe-reset-all --home $HOME/ --keep-addr-book

rm -rf $HOME//data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/cosmoshub-mainnet/ | egrep -o ">cosmoshub-4.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/cosmoshub-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/

mv $HOME//priv_validator_state.json.backup $HOME//data/priv_validator_state.json

sudo systemctl restart gaiad
sudo journalctl -u gaiad -f --no-hostname -o cat