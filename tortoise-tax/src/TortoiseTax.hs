{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE GADTs #-}

module TortoiseTax
    where
    -- ( TaxCode
    -- , TaxSituation
    -- , TaxExpr(..)
    -- , eval
    -- ) where

import Data.Functor.Identity (Identity)
import Data.Proxy            (Proxy(..))
import Data.Text             (Text)

type TaxCode a = TaxExpr (Proxy a)

type TaxSituation a = TaxExpr (Identity a)

data TaxExpr a where
    Lit      :: Metadata -> Question -> a -> TaxExpr a
    Add      :: Metadata -> TaxExpr a -> TaxExpr a -> TaxExpr a
    Subtract :: Metadata -> TaxExpr a -> TaxExpr a -> TaxExpr a
    -- Fun      :: Metadata -> (a -> b) -> TaxExpr a -> TaxExpr b
    deriving (Functor)

newtype Question = Q { getQuestion :: Text }
    deriving (Show)

data Metadata = Metadata
    { mdName :: Maybe Text
    , mdSimpleExplanation :: Maybe Text
    -- TODO , mdDetailedExplanation :: Maybe Text
    -- TODO , mdInstruction :: Maybe InstructionRef
    -- TODO , mdFormField :: Maybe FormFieldRef
    }
    deriving (Show)

q :: Metadata -> Question -> TaxCode a
q metadata question = Lit metadata question Proxy

eval :: ( Applicative f, Num a ) => TaxExpr (f a) -> f a
eval (Lit      _ _ fa) = fa
eval (Add      _ x y)  = (+) <$> eval x <*> eval y
eval (Subtract _ x y)  = (-) <$> eval x <*> eval y
-- eval (Fun      _ f fb) = f   <$> fb
