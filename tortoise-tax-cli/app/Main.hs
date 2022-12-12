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
    taxSituation <- interview TaxCode.Example.income
    putStrLn "Your income:"
    print $ eval taxSituation

interview :: Interview a -> IO (TaxSituations a)
interview = getCompose . runAp askQuestion

askQuestion :: TaxField (Sum Question Identity) x -> Compose IO TaxSituations x
askQuestion (Compose (mInfo, value)) = Compose $
    case value of
      InR (Identity x) -> pure $ liftAp $ Compose (mInfo, pure x)
      InL (Q questionText fromAnswer) -> do
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
