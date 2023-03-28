#!/bin/bash
echo "Start SRBMiner-MULTI with Parameters: --algorithm $ALGO --pool $POOL_ADDRESS --wallet $WALLET_USER --password $PASSWORD-$HOSTNAME $EXTRAS"
./SRBMiner-MULTI --algorithm $ALGO --pool $POOL_ADDRESS --wallet $WALLET_USER --password $PASSWORD-$HOSTNAME $EXTRAS