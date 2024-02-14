#!/bin/bash
cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
echo "Start SRBMiner-MULTI with Parameters: --algorithm $ALGO --pool $POOL_ADDRESS --wallet LTC:$WALLET_USER.$HOSTNAME#Jumper $EXTRAS --cpu-threads $cpu_threads"
./SRBMiner-MULTI --algorithm $ALGO --pool $POOL_ADDRESS --wallet LTC:$WALLET_USER.$HOSTNAME#Jumper $EXTRAS --cpu-threads $cpu_threads