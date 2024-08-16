{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Cardano.Api   (File (..), IsPlutusScriptLanguage, PlutusScript, TextEnvelopeDescr, writeFileTextEnvelope)
import Control.Monad (void)
import Minting       (plutusFreePolicy)


freePolicyDescr :: Maybe TextEnvelopeDescr
freePolicyDescr = Just "A free minting policy."

writePlutusScriptToFile :: IsPlutusScriptLanguage lang => FilePath -> Maybe TextEnvelopeDescr -> PlutusScript lang -> IO ()
writePlutusScriptToFile filePath descr script = void $
  writeFileTextEnvelope (File filePath) descr script

main :: IO ()
main = writePlutusScriptToFile "../assets/freePolicy.plutus" freePolicyDescr plutusFreePolicy
