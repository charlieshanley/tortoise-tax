{-# LANGUAGE LambdaCase    #-}
{-# LANGUAGE TypeOperators #-}

module Main where

import           Prelude          hiding (Ap, Sum)

import           Data.Functor.Sum
import qualified Data.Text.IO     as Text
import qualified Numeric.AD       as AD
import qualified TaxCode.Example
import           TortoiseTax

main :: IO ()
main = do
    putStrLn "Hello, TortoiseTax!"
    taxSituation <- interview TaxCode.Example.totalTax
    putStrLn "Your stuff:"
    print taxSituation
    putStrLn "Your marginal rates:"
    print $ AD.grad (runIdentity . eval) taxSituation
    putStrLn "Your total tax:"
    print $ eval taxSituation

interview :: Interview a -> IO (TaxSituation a)
interview = run askQuestion

askQuestion :: (Sum Question Identity) a -> IO (Identity a)
askQuestion = \case
    InR (Identity x) -> pure $ pure x
    InL (Q questionText fromAnswer) -> do
        putStrLn "-----"
        Text.putStrLn questionText
        Right input <- fromAnswer <$> getLine
        pure $ pure input

askQuestionNonEmpty :: (Sum Question Identity) a -> IO (NonEmpty a)
askQuestionNonEmpty = \case
    InR (Identity x) -> pure $ pure x
    InL (Q questionText fromAnswer) -> do
        putStrLn "-----"
        Text.putStrLn questionText
        Right firstInput <- fromAnswer <$> getLine
        let next = do
              input <- getLine
              case fromAnswer input of
                Left _  -> pure []
                Right x -> (:) x <$> next
        moreInputs <- next
        pure $ firstInput :| moreInputs
