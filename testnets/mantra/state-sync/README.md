## Info
#### Public RPC endpoint: [https://mantra-testnet.rpc.l0vd.com](https://mantra-testnet.rpc.l0vd.com)
#### Public API: [https://mantra-testnet.api.l0vd.com](https://mantra-testnet.api.l0vd.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop mantrachaind
SNAP_RPC="https://mantra-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.mantrachain/config/config.toml

peers="8df752df7047a8dabf89f8a01e2c1235f86283b8@mantra-testnet.peers.l0vd.com:24656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.mantrachain/config/config.toml 

mantrachaind tendermint unsafe-reset-all --home ~/.mantrachain && sudo systemctl restart mantrachaind && journalctl -u mantrachaind -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.mantrachain/config/config.toml
```
