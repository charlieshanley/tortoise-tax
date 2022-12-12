# TortoiseTax

### What is this?

This is a work-in-progress project intended to provide a foundation for tax return
preparation software.

### Goals

- implement a domain-specific language for specifying tax codes
- implement functions that take such specifications and generate interview
programs
- having a structure representing a tax code populated with values, perform analyses, fill forms, etc.

Presently the DSL is implemented as a free applicative functor.

### Related work

- [UsTaxes](https://github.com/ustaxes/UsTaxes#readme)
- [OpenTaxSolver](http://opentaxsolver.sourceforge.net)
