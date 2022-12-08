{-# LANGUAGE LambdaCase #-}

module Main where

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

interview :: TaxCode Int -> IO (TaxSituation Int)
interview = \case
  Add metadata a b -> Add metadata <$> interview a <*> interview b
  Subtract metadata a b -> Subtract metadata <$> interview a <*> interview b
  Lit (Metadata name simpleExplanation) (Q question) Proxy -> do
      putStrLn ""
      traverse_ Text.putStrLn name
      traverse_ Text.putStrLn simpleExplanation
      Text.putStrLn question
      Right (input, _) <- signed decimal <$> getLine
      pure $ Lit (Metadata name simpleExplanation) (Q question) (Identity input)
