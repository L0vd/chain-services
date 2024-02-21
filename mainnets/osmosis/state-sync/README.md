## Info
#### Public RPC endpoint: [https://osmosis.rpc.kjnodes.com](https://osmosis.rpc.kjnodes.com)
#### Public API: [https://osmosis.api.kjnodes.com](https://osmosis.api.kjnodes.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop osmosisd
SNAP_RPC="https://osmosis.rpc.kjnodes.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.osmosisd/config/config.toml

peers="d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@osmosis-mainnet.peers.l0vd.com:12956" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.osmosisd/config/config.toml 

osmosisd tendermint unsafe-reset-all --home ~/.osmosisd && sudo systemctl restart osmosisd && journalctl -u osmosisd -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.osmosisd/config/config.toml
```
