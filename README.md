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

### Dependencies

It is assumed that you have `cardano-node` installed in your system.  Follow [these instructions](https://github.com/input-output-hk/cardano-node-wiki/wiki/install) if you need to install `cardano-node`.

The example in this repo was tested with `cardano-node` v. 9.1.0 and `cardano-cli` v. 9.0.0.0 .

### History

The motivation for creating this repo was to highlight an apparent bug in PlutusV3 that prevented minting.  It turned out that the error was in my original code, where I had `mkWrappedFreePolicy :: BuiltinData -> BuiltinData -> BuiltinUnit`.  As kindly pointed out by 'effectfully', all Plutus V3 scripts should have the following type in Plutus Tx:

```
BuiltinData -> BuiltinUnit
```

The main point being that, in PlutusV3, the redeemer is now part of `ScriptContext`.  After this correction, the script works as expected.