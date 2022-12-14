{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications  #-}

module TaxCode.Example where

import           TortoiseTax

totalTax :: Interview Int
totalTax = add (Just $ Info "Total tax" Nothing) incomeTax capitalGainsTax
  where
    incomeTax = round . (*) (0.25 :: Float) . fromIntegral <$> income
    income = add (Just $ Info "Total income" Nothing) wages taxableInterest
    wages = int @Int (Info "Wages" (Just "Wages, salaries, and tips"))
        "How much did you earn as wage income?"
    taxableInterest = subtr
        (Just $ Info "Taxable interest" $ Just "This is the interest you received that is subject to tax")
        interest
        nontaxableInterest
    interest = int (Info "Interest" (Just "Interest you received from all sources"))
        "How much interest did you receive from all sources?"
    nontaxableInterest = int (Info "Nontaxable interest" Nothing)
        "How much interest did you receive from nontaxable sources, such as municipal bonds?"
    capitalGainsTax = round . (*) (0.15 :: Float) . fromIntegral <$> netCapitalGains
    netCapitalGains = max 0 <$> subtr Nothing capitalGains capitalLosses
    capitalLosses = int (Info "Capital losses" Nothing) "What were your gross capital losses?"
    capitalGains = int @Int (Info "Capital gains" Nothing) "What were your gross capital gains?"
