## Info
#### Public RPC endpoint: [https://nois-mainnet.rpc.l0vd.com](https://nois-mainnet.rpc.l0vd.com)
#### Public API: [https://nois-mainnet.api.l0vd.com](https://nois-mainnet.api.l0vd.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop noisd
SNAP_RPC="https://nois-mainnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.noisd/config/config.toml

peers="0ede37f273933f5f9d6644f68e51128c6332c431@nois-mainnet.seed.l0vd.com:443" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noisd/config/config.toml 

noisd tendermint unsafe-reset-all --home ~/.noisd --keep-addr-book && sudo systemctl restart noisd && \
journalctl -u noisd -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.noisd/config/config.toml
```
