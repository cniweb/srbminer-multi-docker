#!/bin/bash
cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
echo "Start SRBMiner-MULTI with Parameters: --algorithm $ALGO --pool $POOL_ADDRESS --wallet $WALLET_USER --password $PASSWORD-$HOSTNAME $EXTRAS --cpu-threads $cpu_threads"
./SRBMiner-MULTI --algorithm $ALGO --pool $POOL_ADDRESS --wallet $WALLET_USER --password $PASSWORD-$HOSTNAME $EXTRAS --cpu-threads $cpu_threads
