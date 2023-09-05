# State sync

### Info

**Public RPC endpoint:** [**https://archway-testnet.rpc.l0vd.com**](https://archway-testnet.rpc.l0vd.com)

**Public API:** [**https://archway-testnet.api.l0vd.com**](https://archway-testnet.api.l0vd.com)

### Guide to sync your node using State Sync:

#### Copy the entire command

```
sudo systemctl stop archwayd
SNAP_RPC="https://archway-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 1000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.archway/config/config.toml

peers="8b96338b18c1e4a76a119fe0812c131a4e2cc96a@65.109.70.45:20656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.archway/config/config.toml 

archwayd tendermint unsafe-reset-all --home ~/.archway --keep-addr-book && sudo systemctl restart archwayd && \
journalctl -u archwayd -f --output cat
```

#### Turn off State Sync Mode after synchronization

```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.archway/config/config.toml
```
