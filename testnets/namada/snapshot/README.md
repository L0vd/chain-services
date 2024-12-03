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
| 1259  | 0.4 GB  | 2024-12-03_20:44:39 |

```
sudo systemctl stop namadad

cp $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/cometbft/data/priv_validator_state.json $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/priv_validator_state.json.backup

rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/db
rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/tx_wasm_cache 
rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/vp_wasm_cache
rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/cometbft/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/namada-testnet/ | egrep -o ">namada.5f5de2dd1b88cba30586420.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/namada-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.local/share/namada/public-testnet-15.0dacadb8d663

mv $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/priv_validator_state.json.backup $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/cometbft/data/priv_validator_state.json

sudo systemctl restart namadad
sudo journalctl -u namadad -f --no-hostname -o cat
