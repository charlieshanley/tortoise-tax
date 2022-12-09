{-# LANGUAGE LambdaCase #-}

module Main where

import Prelude hiding (Ap)

import           Data.List.NonEmpty (NonEmpty(..))
import qualified Data.Text.IO as Text
import           Data.Text.Read (decimal, signed)
import qualified TaxCode.Example
import           TortoiseTax

main :: IO ()
main = do
    putStrLn "Hello, TortoiseTax!"
    taxSituation <- interview TaxCode.Example.income
    putStrLn "Your income:"
    putStrLn . show $ eval taxSituation

interview :: TaxCode a -> IO (TaxSituations a)
interview = \case
  Pure (Info name simpleExplanation) (Q question fromAnswer) -> do
      putStrLn "-----"
      Text.putStrLn name
      traverse_ Text.putStrLn simpleExplanation
      Text.putStrLn question
      Right head <- fromAnswer <$> getLine
      let next = do
            input <- getLine
            case fromAnswer input of
              Left err -> pure []
              Right x -> (:) x <$> next
      tail <- next
      pure $ Pure (Info name simpleExplanation) (head :| tail)
  Fmap mInfo f a -> Fmap mInfo f <$> interview a
  Ap mInfo f a -> Ap mInfo <$> interview f <*> interview a
