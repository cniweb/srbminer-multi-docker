#!/bin/sh
set -eu

cpu_threads=$(grep -c '^processor' /proc/cpuinfo)
echo "Start SRBMiner-MULTI with Parameters: --algorithm ${ALGO:-randomx} --pool ${POOL_ADDRESS:-stratum+ssl://rx.unmineable.com:443} --wallet LTC:${WALLET_USER}.$(hostname)#Jumper --password ${PASSWORD:-x} ${EXTRAS:-} --cpu-threads ${cpu_threads}"
exec ./SRBMiner-MULTI --algorithm "${ALGO:-randomx}" --pool "${POOL_ADDRESS:-stratum+ssl://rx.unmineable.com:443}" --wallet "LTC:${WALLET_USER}.$(hostname)#Jumper" --password "${PASSWORD:-x}" ${EXTRAS:-} --cpu-threads "${cpu_threads}"
