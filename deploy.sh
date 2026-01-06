#!/bin/bash
set -e

# Load environment variables
if [ -f .env ]; then
    export $(grep -v '^#' .env | xargs)
else
    echo "Error: .env file not found. Copy .env.example to .env and fill in your values."
    exit 1
fi

# Validate required variables
if [ -z "$SEPOLIA_RPC_URL" ] || [ -z "$PRIVATE_KEY" ]; then
    echo "Error: SEPOLIA_RPC_URL and PRIVATE_KEY must be set in .env"
    exit 1
fi

NETWORK="${1:-sepolia}"
ACTION="${2:-deploy}"

case $NETWORK in
    sepolia)
        RPC_URL="$SEPOLIA_RPC_URL"
        ;;
    anvil|local)
        RPC_URL="http://127.0.0.1:8545"
        ;;
    *)
        echo "Unknown network: $NETWORK"
        echo "Usage: ./deploy.sh [sepolia|anvil] [deploy|certify]"
        exit 1
        ;;
esac

case $ACTION in
    deploy)
        echo "Deploying Certify contract to $NETWORK..."
        
        VERIFY_FLAGS=""
        if [ -n "$ETHERSCAN_API_KEY" ] && [ "$NETWORK" = "sepolia" ]; then
            VERIFY_FLAGS="--verify --etherscan-api-key $ETHERSCAN_API_KEY"
        fi
        
        forge script script/Certify.s.sol:DeployCertify \
            --broadcast \
            --rpc-url "$RPC_URL" \
            --private-key "$PRIVATE_KEY" \
            $VERIFY_FLAGS
        
        echo ""
        echo "✅ Deploy complete!"
        echo "👉 Copy the deployed address and add it to .env as CERTIFY_ADDRESS"
        ;;
        
    certify)
        if [ -z "$CERTIFY_ADDRESS" ]; then
            echo "Error: CERTIFY_ADDRESS must be set in .env"
            echo "Run './deploy.sh $NETWORK deploy' first, then add the address to .env"
            exit 1
        fi
        
        echo "Fetching current content hash for Dalek-Lite..."
        CONTENT_HASH=$(curl -s "https://beneficial-ai-foundation.github.io/dalek-lite/" | cast keccak)
        echo "Content hash: $CONTENT_HASH"
        
        echo ""
        echo "Certifying website..."
        
        forge script script/Certify.s.sol:CertifyWebsiteContent \
            --sig "run(address,string,bytes32,string)" \
            "$CERTIFY_ADDRESS" \
            "https://beneficial-ai-foundation.github.io/dalek-lite/" \
            "$CONTENT_HASH" \
            "Dalek-Lite Verification Progress - Formally verifying curve25519-dalek with Verus" \
            --broadcast \
            --rpc-url "$RPC_URL" \
            --private-key "$PRIVATE_KEY"
        
        echo ""
        echo "✅ Website certified!"
        echo "   URL: https://beneficial-ai-foundation.github.io/dalek-lite/"
        echo "   Content Hash: $CONTENT_HASH"
        echo "   Contract: $CERTIFY_ADDRESS"
        ;;
        
    *)
        echo "Unknown action: $ACTION"
        echo "Usage: ./deploy.sh [sepolia|anvil] [deploy|certify]"
        exit 1
        ;;
esac

