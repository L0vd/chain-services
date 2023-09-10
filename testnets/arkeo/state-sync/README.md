## Info
#### Public RPC endpoint: [https://arkeo-testnet.rpc.l0vd.com](https://arkeo-testnet.rpc.l0vd.com)
#### Public API: [https://api-t.arkeo.nodestake.top](https://api-t.arkeo.nodestake.top)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop arkeod
SNAP_RPC="https://arkeo-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.arkeo/config/config.toml

peers="cb9401d70e1bd59e3ed279942ce026dae82aca1f@arkeo-testnet.peers.l0vd.com:27656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.arkeo/config/config.toml 

arkeod tendermint unsafe-reset-all --home ~/.arkeo && sudo systemctl restart arkeod && journalctl -u arkeod -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.arkeo/config/config.toml
```