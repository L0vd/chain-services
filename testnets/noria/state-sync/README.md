## Info
#### Public RPC endpoint: [https://noria-testnet.rpc.l0vd.com](https://noria-testnet.rpc.l0vd.com)
#### Public API: [https://noria-testnet.api.l0vd.com](https://noria-testnet.api.l0vd.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop noriad
SNAP_RPC="https://noria-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.noria/config/config.toml

peers="4e119369ec024964daa81057f69577a90c63a7d5@noria-testnet.peers.l0vd.com:12656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.noria/config/config.toml 

noriad tendermint unsafe-reset-all --home ~/.noria && sudo systemctl restart noriad && journalctl -u noriad -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.noria/config/config.toml
```
