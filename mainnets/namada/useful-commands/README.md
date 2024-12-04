{% hint style="info" %}
Please note that the values in <> must be changed to your own values
{% endhint %}

## Validator configuration

### Create validator
```
namadac init-validator \
 --alias "<NAMADA_NODENAME>" \
 --account-keys "<NAMADA_WALLET>" \
 --signing-keys "<NAMADA_WALLET>" \
 --commission-rate 0.5 \
 --max-commission-rate-change 0.05 \
 --email "<EMAIL>"
```

### View validator state
```
namadac validator-state --validator <NAMADA_NODENAME>
```
### Unjail validator
```
namadac unjail-validator --validator <NAMADA_NODENAME>
```

## Token operations

### Check balance
```
namadac balance --token NAM --owner <NAMADA_NODENAME>
```

### Delegate token
```
namadac bond --source <NAMADA_WALLET> --validator <NAMADA_NODENAME> --amount 100
```

### Undelegate tokens from staking
```
namadac unbond --source <NAMADA_WALLET>  --validator <NAMADA_NODENAME> --amount 100
```
### Withdraw tokens
```
namadac withdraw --source <NAMADA_WALLET> --validator <NAMADA_NODENAME>
```
### Claim rewards
```
namadac claim-rewards --validator <NAMADA_NODENAME>
```

## Governance
### Vote "YES"
```
namadac vote-proposal --proposal-id 0 --vote yay --signing-keys <NAMADA_WALLET> 
```
### Vote "NO"
```
namadac vote-proposal --proposal-id 0 --vote nay --signing-keys <NAMADA_WALLET> 
```


## General commands
### Check node status
```
namadad status | jq
```
### Check service status
```
sudo systemctl status namadad
```
### Check logs
```
sudo journalctl -u namadad -f --no-hostname -o cat
```
### Restart service
```
sudo systemctl restart namadad
```
### Stop service
```
sudo systemctl stop namadad
```
### Start service
```
sudo systemctl start namadad
```
### Disable service
```
sudo systemctl disable namadad
```
### Enable service
```
sudo systemctl enable namadad
```
### Reload service after changes
```
sudo systemctl daemon-reload
```
