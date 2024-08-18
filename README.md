# Free Minting

This project provides a simple "always succeeds" minting policy, as a PlutusV3 script.

### Instructions

```
cabal update
cabal build
```

Change to `scripts` directory.  Then execute:

```
./minting-transaction.sh
```

### Note

There seems to be a bug in PlutusV3 that makes minting impossible.  The aforementioned script fails to build the minting Tx with cardano-cli, with error:
```
Command failed: transaction build  Error: The following scripts have execution failures:
the script for policyId 0 (in ascending order of the PolicyIds) failed with: 
The Plutus script evaluation failed: The evaluation finished but the result value is not valid. Plutus V3 scripts must return BuiltinUnit. Returning any other value is considered a failure.
```
