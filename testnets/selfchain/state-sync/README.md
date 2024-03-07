## Info
#### Public RPC endpoint: [https://rpc-t.selfchain.nodestake.org](https://rpc-t.selfchain.nodestake.org)
#### Public API: [https://api-t.selfchain.nodestake.org](https://api-t.selfchain.nodestake.org)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop nulld
SNAP_RPC="https://rpc-t.selfchain.nodestake.org:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.selfchain/config/config.toml

peers="1057484686750ad233ce225502eec3b3ea00f76d@selfchain-testnet.peers.l0vd.com:26656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.selfchain/config/config.toml 

nulld tendermint unsafe-reset-all --home ~/.selfchain && sudo systemctl restart nulld && journalctl -u nulld -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.selfchain/config/config.toml
```
