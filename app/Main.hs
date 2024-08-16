{-# LANGUAGE ImportQualifiedPost #-}
{-# LANGUAGE OverloadedStrings #-}

module Main where

import Cardano.Api        (File (..), IsPlutusScriptLanguage, PlutusScript, TextEnvelopeDescr, writeFileTextEnvelope)
import Control.Monad      (void)
import Minting            (plutusFreePolicy)


writePlutusScriptToFile :: IsPlutusScriptLanguage lang => FilePath -> Maybe TextEnvelopeDescr -> PlutusScript lang -> IO ()
writePlutusScriptToFile filePath descr script = void $ writeFileTextEnvelope (File filePath) descr script

freePolicyDescr :: Maybe TextEnvelopeDescr
freePolicyDescr = Just "A free minting policy."

main :: IO ()
main = writePlutusScriptToFile "../assets/freePolicy.plutus" freePolicyDescr plutusFreePolicy
