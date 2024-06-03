## Info
#### Public RPC endpoint: [https://bitcanna-testnet.rpc.l0vd.com](https://bitcanna-testnet.rpc.l0vd.com)
#### Public API: [https://bitcanna-testnet.api.l0vd.com](https://bitcanna-testnet.api.l0vd.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop d
SNAP_RPC="https://bitcanna-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.bcna/config/config.toml

peers="@bitcanna-testnet.peers.l0vd.com:" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bcna/config/config.toml 

d tendermint unsafe-reset-all --home ~/.bcna && sudo systemctl restart d && journalctl -u d -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.bcna/config/config.toml
```
