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
| 384928  | 0.4 GB  | custom/100/0/10 | null | 2023-11-02_19:43:35 |

```
sudo systemctl stop entangled

cp $HOME/.entangled/data/priv_validator_state.json $HOME/.entangled/priv_validator_state.json.backup
entangled tendermint unsafe-reset-all --home $HOME/.entangled --keep-addr-book

rm -rf $HOME/.entangled/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/entangle-testnet/ | egrep -o ">entangle_33133-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/entangle-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.entangled

mv $HOME/.entangled/priv_validator_state.json.backup $HOME/.entangled/data/priv_validator_state.json

sudo systemctl restart entangled
sudo journalctl -u entangled -f --no-hostname -o cat