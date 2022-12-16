{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications  #-}

module TaxCode.Example where

import           TortoiseTax

totalTax :: Interview Double
totalTax = add (Info "Total tax" Nothing) incomeTax capitalGainsTax
  where
    incomeTax = income * 0.25
    income = add (Info "Total income" Nothing) wages taxableInterest
    wages = dbl (Info "Wages" (Just "Wages, salaries, and tips"))
        "How much did you earn as wage income?"
    taxableInterest = subtr
        (Info "Taxable interest" $ Just "This is the interest you received that is subject to tax")
        interest
        nontaxableInterest
    interest = dbl (Info "Interest" (Just "Interest you received from all sources"))
        "How much interest did you receive from all sources?"
    nontaxableInterest = dbl (Info "Nontaxable interest" Nothing)
        "How much interest did you receive from nontaxable sources, such as municipal bonds?"
    capitalGainsTax = netCapitalGains * 0.15
    netCapitalGains = max 0 <$> capitalGains - capitalLosses
    capitalLosses = dbl (Info "Capital losses" Nothing) "What were your gross capital losses?"
    capitalGains = dbl (Info "Capital gains" Nothing) "What were your gross capital gains?"
