#! /bin/bash

set -e
# Unofficial bash strict mode.
# See: http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -u
set -o pipefail

keypath=../keys
assets=../assets

echo ""
echo "Free Minting"
echo ""

cabal run simple-minting

in=$(cardano-cli query utxo --address $(cat $keypath/jack.addr) --testnet-magic 4 --out-file  /dev/stdout | jq -r 'keys[0]')

echo "Jack's address:"
echo "$(cardano-cli query utxo --address $(cat $keypath/jack.addr) --testnet-magic 4)"
echo ""

policyid=$(cardano-cli conway transaction policyid --script-file "$assets/freePolicy.plutus")
tokenname=$(head -n 1 "$assets/tokenname" | sed 's/^"//; s/"$//')

redeemer=$assets/unit.json

echo "Policy & TokenName:"
echo "$policyid.$tokenname"
echo ""

cardano-cli conway transaction build \
    --testnet-magic 4 \
    --tx-in $in \
    --tx-in-collateral $in \
    --tx-out "$(cat $keypath/jack.addr) + 43 $policyid.$tokenname" \
    --change-address "$(cat $keypath/jack.addr)" \
    --mint "43 $policyid.$tokenname" \
    --mint-script-file $assets/freePolicy.plutus \
    --mint-redeemer-file $redeemer \
    --out-file "$keypath/minting-transaction.txbody"

cardano-cli conway transaction sign \
    --testnet-magic 4 \
    --tx-body-file "$keypath/minting-transaction.txbody" \
    --signing-key-file "$keypath/jack.skey" \
    --out-file "$keypath/minting-transaction.tx"

cardano-cli conway transaction submit \
    --testnet-magic 4 \
    --tx-file "$keypath/minting-transaction.tx"

