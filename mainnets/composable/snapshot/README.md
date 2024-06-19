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
| 5717033  | 0.0GB  | custom/100/0/10 | null | 2024-06-19T17:25:20 |

```
sudo systemctl stop picad

cp $HOME/.picad/data/priv_validator_state.json $HOME/.picad/priv_validator_state.json.backup
${BINARY_NAME} tendermint unsafe-reset-all --home $HOME/.picad --keep-addr-book

rm -rf $HOME/.picad/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/mainnets/composable/centauri-1/ | egrep -o ">centauri-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/mainnets/composable/centauri-1/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.picad

mv $HOME/.picad/priv_validator_state.json.backup $HOME/.picad/data/priv_validator_state.json

sudo systemctl restart picad
sudo journalctl -u picad -f --no-hostname -o cat
```

## Wasm
```
curl https://snapshots.l0vd.com/mainnets/composable/centauri-1/wasm_client_data.tar.lz4 | lz4 -dc - | tar -xf - -C $HOME/.picad/wasm_client_data
```