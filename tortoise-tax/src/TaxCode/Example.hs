{-# LANGUAGE OverloadedStrings #-}

module TaxCode.Example where

import TortoiseTax

income, wages, taxableInterest, interest, nontaxableInterest :: TaxCode Int

income = add (Just $ Info "Total income" Nothing) wages taxableInterest

wages = int (Info "Wages" (Just "Wages, salaries, and tips")) $
    "How much did you earn as wage income?"

taxableInterest = subtr m interest nontaxableInterest 
    where m = Just $ Info "Taxable interest" $ Just "This is the interest you received that is subject to tax"

interest = int (Info "Interest" (Just "Interest you received from all sources")) $
    "How much interest did you receive from all sources?"

nontaxableInterest = int (Info "Nontaxable interest" Nothing) $
    "How much interest did you receive from nontaxable sources, such as municipal bonds?"
