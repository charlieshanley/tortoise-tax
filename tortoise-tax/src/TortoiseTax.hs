{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeOperators         #-}

module TortoiseTax where

import           Control.Applicative
import           Control.Applicative.Free
import           Data.Functor.Compose
import           Data.Functor.Identity
import           Data.Functor.Sum
import           Data.List.NonEmpty       (NonEmpty)
import           Data.Text                (Text)
import           Data.Text.Read           (double, signed)

type (.) = Compose

type TaxField = (,) (Maybe Info)

type Interview = Ap (TaxField . Sum Question Identity)

type TaxSituation = Ap (TaxField . Identity)

type TaxSituations = Ap (TaxField . NonEmpty)

data Question a = Q
    { qText       :: Text
    , qFromAnswer :: Text -> Either String a
    }

data Info = Info
    { name              :: Text
    , simpleExplanation :: Maybe Text
    -- TODO , mdDetailedExplanation :: Maybe Text
    -- TODO , mdInstruction :: Maybe InstructionRef
    -- TODO , mdFormField :: Maybe FormFieldRef
    }

dbl :: Info -> Text -> Interview Double
dbl info questionText = liftAp $
    Compose (Just info, InL $ Q questionText $ fmap fst . signed double)

f2 :: (a -> b -> c) -> Info -> Interview a -> Interview b -> Interview c
f2 f info a b = liftAp (Compose (Just info, InR $ Identity f)) <*> a <*> b

add :: ( Num a ) => Info -> Interview a -> Interview a -> Interview a
add = f2 (+)

subtr :: ( Num a ) => Info -> Interview a -> Interview a -> Interview a
subtr = f2 (-)

mult :: ( Num a ) => Info -> Interview a -> Interview a -> Interview a
mult = f2 (*)

eval :: (Applicative f) => Ap (TaxField . f) x -> f x
eval = runAp $ snd . getCompose

instance Num a => Num (Interview a) where
    (+) = liftA2 (+)
    (-) = liftA2 (-)
    (*) = liftA2 (*)
    negate = fmap negate
    abs = fmap abs
    signum = fmap signum
    fromInteger = pure . fromInteger

instance Fractional a => Fractional (Interview a) where
    (/) = liftA2 (/)
    recip = fmap recip
    fromRational = pure . fromRational
