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

type TaxCode = TaxExpr Proxy

type TaxSituation = TaxExpr Identity

data TaxExpr f a where
    Lit      :: Metadata -> Question -> f a -> TaxExpr f a
    Add      :: Metadata -> TaxExpr f a -> TaxExpr f a -> TaxExpr f a
    Subtract :: Metadata -> TaxExpr f a -> TaxExpr f a -> TaxExpr f a
    -- Fun      :: Metadata -> (a -> b) -> f a -> TaxExpr f b
    deriving (Show)

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

lit :: Metadata -> Question -> TaxCode a
lit m q = Lit m q Proxy

eval :: ( Applicative f, Num a ) => TaxExpr f a -> f a
eval (Lit      _ _ fa) = fa
eval (Add      _ a b)  = (+) <$> eval a <*> eval b
eval (Subtract _ a b)  = (-) <$> eval a <*> eval b
-- eval (Fun      _ f fb) = f   <$> fb
