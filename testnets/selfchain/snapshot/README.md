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
| 1230125  | 0.1 GB  | custom/100/0/10 | null | 2023-11-14_08:00:57 |

```
sudo systemctl stop selfchaind

cp $HOME/.selfchain/data/priv_validator_state.json $HOME/.selfchain/priv_validator_state.json.backup
selfchaind tendermint unsafe-reset-all --home $HOME/.selfchain --keep-addr-book

rm -rf $HOME/.selfchain/data 

SNAP_NAME=$(curl -s https://snapshots.l0vd.com/selfchain-testnet/ | egrep -o ">self-dev-1.*\.tar.lz4" | tr -d ">")
curl https://snapshots.l0vd.com/selfchain-testnet/${SNAP_NAME} | lz4 -dc - | tar -xf - -C $HOME/.selfchain

mv $HOME/.selfchain/priv_validator_state.json.backup $HOME/.selfchain/data/priv_validator_state.json

sudo systemctl restart selfchaind
sudo journalctl -u selfchaind -f --no-hostname -o cat