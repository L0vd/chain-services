# Lava State Sync

## Info
#### Public RPC endpoint: https://lava-testnet.rpc.l0vd.com
#### Public API: https://lava-testnet.api.l0vd.com

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop lavad
SNAP_RPC="https://lava-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.lava/config/config.toml

peers="fcbe43af6ef40fca686af83e13a8b03d1a6046e6@135.181.178.53:56656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.lava/config/config.toml 

lavad tendermint unsafe-reset-all --home ~/.lava --keep-addr-book && sudo systemctl restart lavad && \
journalctl -u lavad -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.lava/config/config.toml
```
