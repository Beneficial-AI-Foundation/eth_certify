
## Team Certification with Gnosis Safe

For teams that want **all certifications to come from a single address** while allowing multiple team members to certify, use a [Gnosis Safe](https://safe.global/) with a 1-of-N threshold.

### Benefits

| Feature | Individual Wallets | Gnosis Safe (1-of-N) |
|---------|-------------------|----------------------|
| Single team address | ❌ | ✅ |
| Individual keys | ✅ | ✅ |
| Revoke one member | ❌ | ✅ |
| Instant execution | ✅ | ✅ |
| Audit trail | ❌ | ✅ |



### Certifying via Safe UI

1. Go to your Safe at [app.safe.global](https://app.safe.global/)

2. Click **"New Transaction"** → **"Transaction Builder"**

3. Enter the Certify contract address:
   ```
   0x125721f8a45bbABC60aDbaaF102a94d9cae59238
   ```

4. Paste the contract ABI (or use "Custom data"):
   - Function: `certifyWebsite(string,bytes32,string)`
   - URL: `https://beneficial-ai-foundation.github.io/dalek-lite/`
   - Content Hash: (compute with `curl -s "<url>" | cast keccak`)
   - Description: `Dalek-Lite Verification Progress`

5. **Sign and Execute**
   - Any team member with threshold=1 can execute immediately

### Certifying via Command Line

Team members can also propose transactions via the [Safe CLI](https://github.com/safe-global/safe-cli) or [Safe Transaction Service API](https://docs.safe.global/core-api/transaction-service-overview).

```bash
# Install safe-cli
pip install safe-cli

# Propose a transaction (mainnet)
safe-cli send-custom <SAFE_ADDRESS> <CERTIFY_CONTRACT> \
  "certifyWebsite(string,bytes32,string)" \
  "<url>" "<content_hash>" "<description>" \
  --network mainnet

# Or for Sepolia testnet
safe-cli send-custom <SAFE_ADDRESS> <CERTIFY_CONTRACT> \
  "certifyWebsite(string,bytes32,string)" \
  "<url>" "<content_hash>" "<description>" \
  --network sepolia
```

### Viewing Team Certifications

All certifications will show the Safe address as the sender:

```bash
# Query events on mainnet - all will have your Safe address as sender
cast logs \
  --rpc-url https://ethereum-rpc.publicnode.com \
  --from-block $(($(cast block-number --rpc-url https://ethereum-rpc.publicnode.com) - 10000)) \
  --address <CERTIFY_CONTRACT_ADDRESS>

# Or query on Sepolia testnet
cast logs \
  --rpc-url https://ethereum-sepolia-rpc.publicnode.com \
  --from-block $(($(cast block-number --rpc-url https://ethereum-sepolia-rpc.publicnode.com) - 10000)) \
  --address 0x125721f8a45bbABC60aDbaaF102a94d9cae59238
```

Inside the Safe UI, you can see which team member initiated each transaction.
