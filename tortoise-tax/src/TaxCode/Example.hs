{-# LANGUAGE OverloadedStrings #-}

module TaxCode.Example where

import TortoiseTax

income, wages, taxableInterest, interest, nontaxableInterest :: TaxCode Int

income = Add (Metadata (Just "Total income") Nothing) wages taxableInterest

wages = q (Metadata (Just "Wages") (Just "Wages, salaries, and tips")) $
    Q "How much did you earn as wage income?"

taxableInterest = Subtract m interest nontaxableInterest 
    where m = Metadata (Just "Taxable interest") $ Just "This is the interest you received that is subject to tax"

interest = q (Metadata (Just "Interest") (Just "Interest you received from all sources")) $
    Q "How much interest did you receive from all sources?"

nontaxableInterest = q (Metadata (Just "Nontaxable interest") Nothing) $
    Q "How much interest did you receive from nontaxable sources, such as municipal bonds?"
