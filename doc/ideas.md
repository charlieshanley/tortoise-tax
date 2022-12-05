#### A language to express tax codes

A key challenge for developing tax return preparation software is that tax codes
are complicated, there are many of them (just in the US there is one for the
federal government and are 50 for the state governments), and they change
frequently. As a result, for a project like this to succeed it is crucial that
writing, reading, and revising tax code specifications be as easy as possible,
and as broadly accessible as possible to people with tax expertise.

This project aims to satisfy that requirement by separating the specification of
tax codes entirely from other concerns (namely the implementation of the interview
program interface, the filling of tax forms, and other functionality). We will
define a domain-specific language that is as simple and transparent as possible,
so that users and tax experts with no experience of general-purpose programming
can contribute by specifying new tax codes and by revising or updating existing ones.

-----

- Use automatic differentiation to get marginal tax rates. Or more generally:
  sensitivity to any continuous input variable (charitable donations is an example
  that is not a marginal tax rate).
- Use functors other than `Proxy` and `Identity` to do what-if scenarios, or
  "probabalistic programming". IE perhaps `List`, or some kind of probability
  distribution, or just generally something that contains more than one precise
  value.

