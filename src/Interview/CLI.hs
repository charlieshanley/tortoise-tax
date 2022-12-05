{-# LANGUAGE LambdaCase #-}

module Interview.CLI where

import           Data.Foldable         (traverse_)
import           Data.Functor.Identity (Identity(..))
import           Data.Proxy            (Proxy(..))
import qualified Data.Text.IO as Text
import qualified TaxCode.Example
import           TortoiseTax

main :: IO ()
main = do
    putStrLn "Hello, TortoiseTax!"
    taxSituation <- interview TaxCode.Example.income
    putStrLn "Your income:"
    putStrLn $ show $ eval taxSituation

interview :: TaxCode Int -> IO (TaxSituation Int)
interview = \case
  Add metadata a b -> Add metadata <$> interview a <*> interview b
  Subtract metadata a b -> Subtract metadata <$> interview a <*> interview b
  Lit (Metadata name simpleExplanation) (Q question) Proxy -> do
      putStrLn ""
      traverse_ Text.putStrLn name
      traverse_ Text.putStrLn simpleExplanation
      Text.putStrLn question
      input <- read <$> getLine
      pure $ Lit (Metadata name simpleExplanation) (Q question) (Identity input)
