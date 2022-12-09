{-# LANGUAGE LambdaCase #-}

module Main where

import Prelude hiding (Ap)

import qualified Data.Text.IO as Text
import Data.Text.Read (decimal, signed)
import qualified TaxCode.Example
import           TortoiseTax

main :: IO ()
main = do
    putStrLn "Hello, TortoiseTax!"
    taxSituation <- interview TaxCode.Example.income
    putStrLn "Your income:"
    putStrLn . show . runIdentity $ eval taxSituation

interview :: TaxCode a -> IO (TaxSituation a)
interview = \case
  Lit (Info name simpleExplanation) (Q question fromAnswer) -> do
      putStrLn ""
      Text.putStrLn name
      traverse_ Text.putStrLn simpleExplanation
      Text.putStrLn question
      Right input <- fromAnswer <$> getLine
      pure $ Lit (Info name simpleExplanation) (Identity input)
  F mInfo f a -> F mInfo f <$> interview a
  Ap mInfo f a -> Ap mInfo <$> interview f <*> interview a
