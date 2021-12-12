module TortoiseTax
    ( TaxExpr(..)
    , TaxCode
    , TaxSituation
    ) where

import Data.Functor.Identity (Identity)
import Data.Proxy            (Proxy)

data TaxExpr f a = Leaf (f a)

type TaxCode = TaxExpr Proxy

type TaxSituation = TaxExpr Identity
