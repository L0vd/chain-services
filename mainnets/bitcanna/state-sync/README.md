## Info
#### Public RPC endpoint: [https://bitcanna-mainnet.rpc.l0vd.com](https://bitcanna-mainnet.rpc.l0vd.com)
#### Public API: [https://bitcanna-mainnet.api.l0vd.com](https://bitcanna-mainnet.api.l0vd.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop bcnad
SNAP_RPC="https://bitcanna-mainnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.bcna/config/config.toml

peers="6ae1dfa46884560e13962d73462e5bda0bb8c019@bitcanna-mainnet.peers.l0vd.com:17656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bcna/config/config.toml 

bcnad tendermint unsafe-reset-all --home ~/.bcna && sudo systemctl restart bcnad && journalctl -u bcnad -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.bcna/config/config.toml
```
