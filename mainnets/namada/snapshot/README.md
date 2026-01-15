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
| 4514500  | 101.9 GB  | 2026-01-15_22:13:15 |

```
sudo systemctl stop namadad

cp $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/cometbft/data/priv_validator_state.json $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/priv_validator_state_backup.json

rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/db
rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/tx_wasm_cache
rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/vp_wasm_cache
rm -rf $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/cometbft/data

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/mainnets/namada/namada.5f5de2dd1b88cba30586420/ | egrep -o ">namada.5f5de2dd1b88cba30586420.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/mainnets/namada/namada.5f5de2dd1b88cba30586420/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420

mv $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/priv_validator_state_backup.json $HOME/.local/share/namada/namada.5f5de2dd1b88cba30586420/cometbft/priv_validator_state.json

sudo systemctl restart namadad
sudo journalctl -u namadad -f --no-hostname -o cat
