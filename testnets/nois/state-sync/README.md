# State sync
## Info
#### Public RPC endpoint: https://nois-testnet.rpc.l0vd.com
#### Public API: https://nois-testnet.api.l0vd.com

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop noisd
SNAP_RPC="https://nois-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.noisd/config/config.toml

peers="cecbb8a5dd8bff1ce519cba9c3494919cd14f3dc@65.109.70.45:14656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noisd/config/config.toml 

noisd tendermint unsafe-reset-all --home ~/.noisd --keep-addr-book && sudo systemctl restart noisd && \
journalctl -u noisd -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.noisd/config/config.toml
```
