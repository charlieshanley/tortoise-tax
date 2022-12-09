{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

module TortoiseTax where

import Data.Functor.Identity (Identity)
import Data.Text             (Text)
import Data.Text.Read        (signed, decimal)
import Data.List.NonEmpty    (NonEmpty)

type TaxCode = Expr Question

type TaxSituation = Expr Identity

type TaxSituations = Expr NonEmpty

data Expr f a where
    Pure :: Info -> f a -> Expr f a
    Fmap :: Maybe Info -> (a -> b) -> Expr f a -> Expr f b
    Ap   :: Maybe Info -> Expr f (a -> b) -> Expr f a -> Expr f b

data Question a = Q
    { question :: Text
    , fromAnswer :: Text -> Either String a
    }

data Info = Info
    { mdName :: Text
    , mdSimpleExplanation :: Maybe Text
    -- TODO , mdDetailedExplanation :: Maybe Text
    -- TODO , mdInstruction :: Maybe InstructionRef
    -- TODO , mdFormField :: Maybe FormFieldRef
    }

int :: (Num a, Integral a) => Info -> Text -> TaxCode a
int info questionText = Pure info $ Q questionText $ fmap fst . signed decimal

f2 :: (a -> b -> c) -> Maybe Info -> Expr f a -> Expr f b -> Expr f c
f2 f mInfo a b = Ap mInfo (Fmap Nothing f a) b

add :: ( Num a ) => Maybe Info -> Expr f a -> Expr f a -> Expr f a
add = f2 (+)

subtr :: ( Num a ) => Maybe Info -> Expr f a -> Expr f a -> Expr f a
subtr = f2 (-)


eval :: ( Applicative f ) => Expr f a -> f a
eval (Pure _ fa) = fa
eval (Fmap _ f a)    = f <$> eval a
eval (Ap _ f a)   = eval f <*> eval a
