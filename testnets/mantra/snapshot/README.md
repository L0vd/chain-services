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
| 583982  | 0.2 GB  | custom/100/0/10 | null | 2023-10-25_05:05:37 |

```
sudo systemctl stop mantrachaind

cp $HOME/.mantrachain/data/priv_validator_state.json $HOME/.mantrachain/priv_validator_state.json.backup
mantrachaind tendermint unsafe-reset-all --home $HOME/.mantrachain --keep-addr-book

rm -rf $HOME/.mantrachain/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/mantra-testnet/ | egrep -o ">mantrachain-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/mantra-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.mantrachain

mv $HOME/.mantrachain/priv_validator_state.json.backup $HOME/.mantrachain/data/priv_validator_state.json

sudo systemctl restart mantrachaind
sudo journalctl -u mantrachaind -f --no-hostname -o cat