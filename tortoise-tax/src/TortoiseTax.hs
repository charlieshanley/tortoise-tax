{-# LANGUAGE GADTs #-}

module TortoiseTax where

import Data.Functor.Identity (Identity)
import Data.Proxy            (Proxy(..))
import Data.Text             (Text)

type TaxCode a = Expr (Proxy a)

type TaxSituation a = Expr (Identity a)

data Expr a where
    Lit      :: Metadata -> Question -> a -> Expr a
    Add      :: Metadata -> Expr a -> Expr a -> Expr a
    Subtract :: Metadata -> Expr a -> Expr a -> Expr a
    -- Fun      :: Metadata -> (a -> b) -> Expr a -> Expr b

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

eval :: ( Applicative f, Num a ) => Expr (f a) -> f a
eval (Lit      _ _ fa) = fa
eval (Add      _ x y)  = (+) <$> eval x <*> eval y
eval (Subtract _ x y)  = (-) <$> eval x <*> eval y
-- eval (Fun      _ f fb) = f   <$> fb
