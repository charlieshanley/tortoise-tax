{-# LANGUAGE TypeOperators #-}

module TortoiseTax where

import Data.Functor.Identity
import Data.Text             (Text)
import Data.Text.Read        (signed, decimal)
import Data.List.NonEmpty    (NonEmpty)
import Control.Applicative.Free
import Data.Functor.Compose
import Data.Functor.Sum

type TaxField f = (,) (Maybe Info) `Compose` f

type Interview = Ap (TaxField (Sum Question Identity))

type TaxSituation = Ap (TaxField Identity)

type TaxSituations = Ap (TaxField NonEmpty)

data Question a = Q
    { qText :: Text
    , qFromAnswer :: Text -> Either String a
    }

data Info = Info
    { name :: Text
    , simpleExplanation :: Maybe Text
    -- TODO , mdDetailedExplanation :: Maybe Text
    -- TODO , mdInstruction :: Maybe InstructionRef
    -- TODO , mdFormField :: Maybe FormFieldRef
    }

int :: (Num a, Integral a) => Info -> Text -> Interview a
int info questionText = liftAp $
    Compose (Just info, InL $ Q questionText $ fmap fst . signed decimal)

f2 :: (a -> b -> c) -> Maybe Info -> Interview a -> Interview b -> Interview c
f2 f mInfo a b = liftAp (Compose (mInfo, InR $ Identity f)) <*> a <*> b

add :: ( Num a ) => Maybe Info -> Interview a -> Interview a -> Interview a
add = f2 (+)

subtr :: ( Num a ) => Maybe Info -> Interview a -> Interview a -> Interview a
subtr = f2 (-)


eval :: (Applicative f) => Ap (TaxField f) x -> f x
eval = runAp $ snd . getCompose
