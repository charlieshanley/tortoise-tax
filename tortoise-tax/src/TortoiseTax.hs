{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE GADTs #-}

module TortoiseTax where

import Data.Functor.Identity (Identity)
import Data.Text             (Text)
import Data.Text.Read        (signed, decimal)

type TaxCode = Expr Question

type TaxSituation = Expr Identity

data Expr f a where
    Lit :: Info -> f a -> Expr f a
    F   :: Maybe Info -> (a -> b) -> Expr f a -> Expr f b
    Ap  :: Maybe Info -> Expr f (a -> b) -> Expr f a -> Expr f b

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
int info questionText = Lit info $ Q questionText $ fmap fst . signed decimal

f2 :: (a -> b -> c) -> Maybe Info -> Expr f a -> Expr f b -> Expr f c
f2 f mInfo a b = Ap mInfo (F Nothing f a) b

add :: ( Num a ) => Maybe Info -> Expr f a -> Expr f a -> Expr f a
add = f2 (+)

subtr :: ( Num a ) => Maybe Info -> Expr f a -> Expr f a -> Expr f a
subtr = f2 (-)


eval :: ( Applicative f ) => Expr f a -> f a
eval (Lit _ fa) = fa
eval (F _ f a)    = f <$> eval a
eval (Ap _ f a)   = eval f <*> eval a
