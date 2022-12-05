# TortoiseTax

### What is this?

This is a work-in-progress project intended to provide a foundation for tax return
preparation software.

### Design ideas

#### Representation of tax codes

The core of the project is a representation of tax codes as algebraic expressions
composed of values that might be supplied by user input (IE wages) or computed
from other values (IE total income as the sum of wages, interest and dividends,
etc.). Metadata will be associated with values in the expressions, such as natural
language names and explanations, and references to corresponding fields in tax forms.

#### Generation of interview programs

Having defined a representation of tax codes, we will implement a function
from tax codes to interview programs that prompt user input and yield the user's
situation under the tax code.

The generation of interview programs being orthogonal to the specification of tax
codes, one interview-program generating function can be reused for many tax codes,
and conversely multiple interview programs (IE web app vs. desktop GUI vs. CLI)
can be implemented and used for a particular tax code.

#### Using the results of the interview program

We intend to use the results of interview programs to do things like:
- report refund or tax owed
- report marginal and effective tax rates
- fill tax forms
- file taxes
- perform sensitivity analyses, what-if scenarios, and other analyses

### Related work

- [UsTaxes](https://github.com/ustaxes/UsTaxes#readme)
- [OpenTaxSolver](http://opentaxsolver.sourceforge.net)
