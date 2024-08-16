{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Cardano.Api   (File (..), IsPlutusScriptLanguage, PlutusScript, TextEnvelopeDescr
                     , writeFileTextEnvelope)
import Control.Monad (void)
import Minting       (plutusFreePolicy)


freePolicyDescr :: Maybe TextEnvelopeDescr
freePolicyDescr = Just "A free minting policy."

writePlutusScriptToFile :: IsPlutusScriptLanguage lang => FilePath -> PlutusScript lang -> IO ()
writePlutusScriptToFile filePath script = void $
  writeFileTextEnvelope (File filePath) freePolicyDescr script

main :: IO ()
main = writePlutusScriptToFile "../assets/freePolicy.plutus" plutusFreePolicy
