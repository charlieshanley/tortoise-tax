# TortoiseTax

> Tax return preparation software by the people and for the people

### What is this?

This is a work-in-progress open source project intended to provide a foundation for
free (both libre and gratis) tax return preparation. This foundation will be be
agnostic to the specific tax code or jurisdiction; particular tax codes (IE US
Federal, US states, or those of taxing authorities in other nations) will be specified
separately, sharing the common foundation. From each tax code specification
user-facing surfaces will be derived, such as an interview program and the
capability to fill tax forms, among others.

### Design

The project will consist of the following elements:

#### Abstract representation of tax codes

The core of the project is a representation of tax codes as algebraic expressions
composed of values that might be supplied by user input (IE wages) or computed
from other values (IE total income as the sum of wages, interest and dividends,
etc.). Various pieces of metadata will be associated with values in
the expressions, such as natural language names and explanations, and references
to corresponding fields in tax forms.

The intention is that this representation contains all the information necessary
to automatically derive an interview program prompting user input and yielding
the user's tax situation, to fill tax forms once the user's tax situation is known,
and perhaps to perform other analyses.

#### A language to express tax codes

A key challenge for developing tax return preparation software is that tax codes
are complicated, there are many of them (1 for the federal govt and 50 for states
just in the US), and they change frequently. As a result, for a project like this
to succeed it is crucial that writing, reading, and revising tax code specifications
be as easy as possible, and as broadly accessible as possible to people with tax
expertise.

This project aims to satisfy that requirement by separating the specification of
tax codes entirely from other concerns (namely the implementation of the interview
program interface, the filling of tax forms, and other functionality). We will
define a domain-specific language that is as simple and transparent as possible,
so that users and tax experts with no programming experience or knowledge of
general-purpose programming languages can contribute by specifying new tax codes
and by revising or updating existing ones.

This domain-specific language will be parsed to the representation described above,
with user-friendly error messages in the case of syntax errors, or logical errors
like multiple values referencing the same tax form field.

#### Generation of interview programs

Having defined a representation of tax codes, we will implement a function
from tax codes to interview programs that prompt user input and yield the user's
tax situation under the tax code. The implementation will make use of the
hierarchical structure of the expression, natural language names and explanations
associated with values, etc., to generate the interview program.

If we consider the language described above as coding for an interview program,
the function described here is its compiler.

A key advantage is that this function can be implemented once and reused for
as many tax codes as are specified. However, there could be more than one of these
functions implemented if different kinds of interview programs are desired: IE
web app vs. desktop GUI vs. CLI, or simply to implement different appearances.

#### Using the results of the interview program

After the user has completed the interview program, we have a representation of
the user's tax situation under the tax code. With this, we can report to the user
things like refund or tax owed, or marginal and effective tax rates. We can also
output the tax situation in various formats (perhaps encrypted) for storage or
import into other software.

Most importantly, we can fill tax forms to be reviewed and filed with the taxing
authority. These would likely be PDFs, but might also use other formats depending
on what taxing authorities accept.

Finally, the principled representation of both the tax code and the user's tax
situation may make some more complex analyses feasible. For instance, it may be
possible determine the sensitivity of tax owed to particular variables, compare
different hypothetical scenarios, etc.

### Motivation

TODO

### Future possibilities

It seems possible that a language standard for expressing tax codes could emerge.

In the ideal case, taxing authorities themselves (the US IRS, for example) could
publish specifications of their tax codes in that language for use in software
like this project. 

### Related work

- [UsTaxes](https://github.com/ustaxes/UsTaxes#readme)
- [OpenTaxSolver](http://opentaxsolver.sourceforge.net)
