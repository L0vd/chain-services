# Snapshot

## Updates every 4 hours

## Install dependencies, if needed
```
sudo apt update
sudo apt install lz4 -y
```

## Sync from Snapshot  
| Height  | Size | Creation Time (UTC+3) |
| --------- | --------- | --------- | --------- | --------- |
| ${Height}  | ${Size}B  | ${Time} |

```
sudo systemctl stop ${BINARY_NAME}

cp $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/cometbft/data/priv_validator_state.json $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/priv_validator_state.json.backup

rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/db
rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/tx_wasm_cache 
rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/vp_wasm_cache
rm -rf $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/cometbft/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/${ALL_LOW_NAME}-${NETWORK_CATEGORY}/ | egrep -o ">${CHAIN_ID}.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/${ALL_LOW_NAME}-${NETWORK_CATEGORY}/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.local/share/namada/public-testnet-15.0dacadb8d663

mv $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/priv_validator_state.json.backup $HOME/.local/share/namada/public-testnet-15.0dacadb8d663/cometbft/data/priv_validator_state.json

sudo systemctl restart ${BINARY_NAME}
sudo journalctl -u ${BINARY_NAME} -f --no-hostname -o cat
