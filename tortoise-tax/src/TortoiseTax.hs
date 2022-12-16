{-# LANGUAGE DeriveFoldable        #-}
{-# LANGUAGE DeriveFunctor         #-}
{-# LANGUAGE DeriveTraversable     #-}
{-# LANGUAGE DerivingStrategies    #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE LambdaCase            #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE UndecidableInstances  #-}

module TortoiseTax where

import           Data.Functor.Compose
import           Data.Functor.Identity
import           Data.Functor.Sum
import           Data.List.NonEmpty    (NonEmpty)
import           Data.Text             (Text)
import           Data.Text.Read        (double, signed)

data Expr f a
    = Leaf (Maybe Info) (f a)
    | Unary UnaryOp (Maybe Info) (Expr f a)
    | Binary BinaryOp (Maybe Info) (Expr f a) (Expr f a)
    deriving stock (Show, Functor, Foldable, Traversable)

data UnaryOp = Negate | Abs | Signum | Recip
    deriving (Show)

getUnaryOp :: ( Fractional a ) => UnaryOp -> a -> a
getUnaryOp = \case
    Negate -> negate
    Abs    -> abs
    Signum -> signum
    Recip  -> recip

data BinaryOp = Add | Subtr | Mult | Div
    deriving (Show)

getBinaryOp :: ( Fractional a ) => BinaryOp -> a -> a -> a
getBinaryOp = \case
    Add   -> (+)
    Subtr -> (-)
    Mult  -> (*)
    Div   -> (/)

type (.) = Compose

type Interview     = Expr (Sum Question Identity)
type TaxSituation  = Expr Identity
type TaxSituations = Expr NonEmpty

data Question a = Q
    { qText       :: Text
    , qFromAnswer :: Text -> Either String a
    }
    deriving stock (Functor)

data Info = Info
    { name              :: Text
    , simpleExplanation :: Maybe Text
    -- TODO , mdDetailedExplanation :: Maybe Text
    -- TODO , mdInstruction :: Maybe InstructionRef
    -- TODO , mdFormField :: Maybe FormFieldRef
    }
    deriving (Show)

dbl :: Info -> Text -> Interview Double
dbl info questionText = Leaf (Just info) $
    InL $ Q questionText $ fmap fst . signed double

add :: Info -> Expr f a -> Expr f a -> Expr f a
add = Binary Add . Just

subtr :: Info -> Interview a -> Interview a -> Interview a
subtr = Binary Subtr . Just

mult :: Info -> Interview a -> Interview a -> Interview a
mult = Binary Mult . Just

div :: Info -> Interview a -> Interview a -> Interview a
div = Binary Div . Just

instance ( Num a ) => Num (Interview a) where
    (+) = Binary Add Nothing
    (-) = Binary Subtr Nothing
    (*) = Binary Mult Nothing
    negate = Unary Negate Nothing
    abs = Unary Abs Nothing
    signum = Unary Signum Nothing
    fromInteger = Leaf Nothing . InR . Identity . fromInteger

instance Fractional a => Fractional (Interview a) where
    (/) = Binary Div Nothing
    recip = Unary Recip Nothing
    fromRational = Leaf Nothing . InR . Identity . fromRational

run :: ( Applicative m ) => (f a -> m (g a)) -> Expr f a -> m (Expr g a)
run f = \case
    Leaf mInfo fa       -> Leaf mInfo <$> f fa
    Unary op mInfo a    -> Unary op mInfo <$> run f a
    Binary op mInfo a b -> Binary op mInfo <$> run f a <*> run f b

eval :: ( Applicative f, Fractional a ) => Expr f a -> f a
eval = \case
    Leaf _ fa       -> fa
    Unary op _ a    -> getUnaryOp op <$> eval a
    Binary op _ a b -> getBinaryOp op <$> eval a <*> eval b


-- instance Show (f a) => Show (Expr f a) where
--     show (Leaf
