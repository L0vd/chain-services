## Info
#### Public RPC endpoint: [https://cosmoshub.rpc.kjnodes.com](https://cosmoshub.rpc.kjnodes.com)
#### Public API: [https://cosmoshub.api.kjnodes.com](https://cosmoshub.api.kjnodes.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop d
SNAP_RPC="https://cosmoshub.rpc.kjnodes.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.gaia/config/config.toml

peers="d9bfa29e0cf9c4ce0cc9c26d98e5d97228f93b0b@cosmoshub-mainnet.peers.l0vd.com:13456" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.gaia/config/config.toml 

d tendermint unsafe-reset-all --home ~/.gaia && sudo systemctl restart d && journalctl -u d -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.gaia/config/config.toml
```
