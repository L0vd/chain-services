# Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot  
| Height  | Size | Creation Time (UTC+3) |
| --------- | --------- | --------- |
| 2476  | GB  | 2024-12-03_23:15:50 |

```
sudo systemctl stop namadad

cp $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/cometbft/data/priv_validator_state.json $HOME/.local/share/namada/public-testnet-15.0dacadb8d>

rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/db
rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/tx_wasm_cache
rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/vp_wasm_cache
rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/cometbft/data

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/namada-mainnet/ | egrep -o ">namada.5f5de2dd1b88cba30586420.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/namada-mainnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.local/share/namada/public-testnet-15.0>

mv $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/priv_validator_state.json.backup $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/com>

sudo systemctl restart namadad
sudo journalctl -u namadad -f --no-hostname -o cat
