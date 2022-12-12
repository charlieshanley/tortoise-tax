{-# LANGUAGE LambdaCase #-}

module Main where

import Prelude hiding (Ap, Sum)

import qualified Data.Text.IO as Text
import qualified TaxCode.Example
import           TortoiseTax
import Data.Functor.Sum
import Control.Applicative.Free

main :: IO ()
main = do
    putStrLn "Hello, TortoiseTax!"
    taxSituation <- getCompose $ runAp interview TaxCode.Example.income
    putStrLn "Your income:"
    putStrLn . show $ eval taxSituation

interview :: TaxField (Sum Question Identity) x -> Compose IO TaxSituations x
interview (Compose (mInfo, value)) =
    case value of
      InR (Identity x) -> pure x
      InL (Q questionText fromAnswer) -> Compose $ do
          putStrLn "-----"
          traverse_ (Text.putStrLn . name) mInfo
          traverse_ Text.putStrLn $ simpleExplanation =<< mInfo
          Text.putStrLn questionText
          Right firstInput <- fromAnswer <$> getLine
          let next = do
                input <- getLine
                case fromAnswer input of
                  Left _ -> pure []
                  Right x -> (:) x <$> next
          moreInputs <- next
          pure $ liftAp $ Compose (mInfo, firstInput :| moreInputs)
