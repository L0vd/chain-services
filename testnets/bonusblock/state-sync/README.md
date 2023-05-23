{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Info
#### Public RPC endpoint: [https://bonusblock-testnet.rpc.l0vd.com](https://bonusblock-testnet.rpc.l0vd.com)
#### Public API: [https://bonusblock-testnet.api.l0vd.com](https://bonusblock-testnet.api.l0vd.com)

## Guide to sync your node using State Sync:

### Copy the entire command
```
sudo systemctl stop bonus-blockd
SNAP_RPC="https://bonusblock-testnet.rpc.l0vd.com:443"; \
LATEST_HEIGHT=$(curl -s $SNAP_RPC/block | jq -r .result.block.header.height); \
BLOCK_HEIGHT=$((LATEST_HEIGHT - 2000)); \
TRUST_HASH=$(curl -s "$SNAP_RPC/block?height=$BLOCK_HEIGHT" | jq -r .result.block_id.hash); \
echo $LATEST_HEIGHT $BLOCK_HEIGHT $TRUST_HASH

sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1true| ; \
s|^(rpc_servers[[:space:]]+=[[:space:]]+).*$|\1\"$SNAP_RPC,$SNAP_RPC\"| ; \
s|^(trust_height[[:space:]]+=[[:space:]]+).*$|\1$BLOCK_HEIGHT| ; \
s|^(trust_hash[[:space:]]+=[[:space:]]+).*$|\1\"$TRUST_HASH\"|" $HOME/.bonusblock/config/config.toml

peers="54ccb1644281d0d99748e20f61d323f59c408368@bonusblock-testnet.peers.l0vd.com:19656" \
&& sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" $HOME/.bonusblock/config/config.toml 

bonus-blockd tendermint unsafe-reset-all --home ~/.bonusblock && sudo systemctl restart bonus-blockd && journalctl -u bonus-blockd -f --output cat
```

### Turn off State Sync Mode after synchronization
```
sed -i.bak -E "s|^(enable[[:space:]]+=[[:space:]]+).*$|\1false|" $HOME/.bonusblock/config/config.toml
```
