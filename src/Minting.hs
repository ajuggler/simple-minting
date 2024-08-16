{-# LANGUAGE DataKinds #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE Strict #-}
{-# LANGUAGE TemplateHaskell #-}
{-# OPTIONS_GHC -fno-full-laziness #-}
{-# OPTIONS_GHC -fno-ignore-interface-pragmas #-}
{-# OPTIONS_GHC -fno-omit-interface-pragmas #-}
{-# OPTIONS_GHC -fplugin-opt PlutusTx.Plugin:target-version=1.0.0 #-}

module Minting where

import Cardano.Api        (PlutusScriptV3)
import Cardano.Api.Script (PlutusScript (..))
import PlutusLedgerApi.V3 (ScriptContext, SerialisedScript, serialiseCompiledCode)
import PlutusTx           (BuiltinData, CompiledCode, UnsafeFromData, compile, unsafeFromBuiltinData)
import PlutusTx.Prelude   (BuiltinUnit, check)


{-# INLINABLE mkFreePolicy #-}
mkFreePolicy :: () -> ScriptContext -> Bool
mkFreePolicy () _ = True

{-# INLINABLE mkWrappedFreePolicy #-}
mkWrappedFreePolicy :: BuiltinData -> BuiltinData -> BuiltinUnit
mkWrappedFreePolicy = wrapPolicy mkFreePolicy

compiledFreePolicy :: CompiledCode (BuiltinData -> BuiltinData -> BuiltinUnit)
compiledFreePolicy = $$(compile [|| mkWrappedFreePolicy ||])

serializedFreePolicy :: SerialisedScript
serializedFreePolicy = serialiseCompiledCode compiledFreePolicy

plutusFreePolicy :: PlutusScript PlutusScriptV3
plutusFreePolicy = PlutusScriptSerialised serializedFreePolicy


-----------  Helper Functions  -----------

{-# INLINABLE wrapPolicy #-}
wrapPolicy :: UnsafeFromData a
           => (a -> ScriptContext -> Bool)
           -> (BuiltinData -> BuiltinData -> BuiltinUnit)
wrapPolicy f a ctx =
  check $ f
      (unsafeFromBuiltinData a)
      (unsafeFromBuiltinData ctx)

