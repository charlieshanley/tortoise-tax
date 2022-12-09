{-# LANGUAGE GADTs #-}

module TortoiseTax
    where
    -- ( TaxCode
    -- , TaxSituation
    -- , Expr(..)
    -- , eval
    -- ) where

import Data.Functor.Identity (Identity)
import Data.Proxy            (Proxy(..))
import Data.Text             (Text)

type TaxCode = Expr Proxy

type TaxSituation = Expr Identity

data Expr f a where
    Lit :: (Read a) => Info -> Question -> f a -> Expr f a
    F   :: Maybe Info -> (a -> b) -> Expr f a -> Expr f b
    Ap  :: Maybe Info -> Expr f (a -> b) -> Expr f a -> Expr f b

newtype Question = Q { getQuestion :: Text }
    deriving (Show)

data Info = Info
    { mdName :: Text
    , mdSimpleExplanation :: Maybe Text
    -- TODO , mdDetailedExplanation :: Maybe Text
    -- TODO , mdInstruction :: Maybe InstructionRef
    -- TODO , mdFormField :: Maybe FormFieldRef
    }
    deriving (Show)

q :: (Read a) => Info -> Question -> TaxCode a
q info question = Lit info question Proxy

f2 :: (a -> b -> c) -> Maybe Info -> Expr f a -> Expr f b -> Expr f c
f2 f mInfo a b = Ap mInfo (F Nothing f a) b

add :: ( Num a ) => Maybe Info -> Expr f a -> Expr f a -> Expr f a
add = f2 (+)

subtr :: ( Num a ) => Maybe Info -> Expr f a -> Expr f a -> Expr f a
subtr = f2 (-)


eval :: ( Applicative f ) => Expr f a -> f a
eval (Lit _ _ fa) = fa
eval (F _ f a)    = f <$> eval a
eval (Ap _ f a)   = eval f <*> eval a
