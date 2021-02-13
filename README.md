Allocate
===============================================================================

[![PyPI - Version](https://img.shields.io/pypi/v/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![PyPI - Wheel](https://img.shields.io/pypi/wheel/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![License](https://img.shields.io/pypi/l/beancount_allocate)](https://choosealicense.com/licenses/agpl-3.0/)
[![Linting](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)


A beancount plugin to allocate expenses among multiple equity accounts (e.g. partners, budget positions) within one ledger.
<!-- A beancount plugin to share expenses among multiple partners within one ledger. -->

An equity account in Beancount can be used for many purposes. Most notably, for **multiple partners within one ledger** or **budgeting**. Allocate plugin can be useful for both multiple partners `#allocate-Bob` and budgeting `#allocate-Food`.

Allocate plugin uses tag syntax to add info to the transaction:
- basic: allocate expense 100% to a partner/budget position - simply use `#allocate-Bob`/`#allocate-Food`
- amount: allocate a specific sum of expense to a partner/budget position. `#allocate-Bob-7`/`#allocate-Food-10`
- percentage: allocate a specific percentage of expense to a partner/budget position. `#allocate-Bob-40%`/`#allocate-Food-75%`
- many: allocate expense to many accounts within ledger. `#allocate-Bob #allocate-Alice`/`#allocate-Food #allocate-Supplies`







Install
===============================================================================

```sh
pip3 install beancount_allocate --user
```

Or copy to path used for python. For example, `$HOME/.local/lib/python3.7/site-packages/beancount_allocate/*` would do on Debian. If in doubt, look where `beancount` folder is and copy next to it.







Setup
===============================================================================

Add a simple configuration:

```beancount
plugin "beancount_allocate" "{}"
```

<!-- - all new names you add in the tag after `#share-` will be automatically added to your debtors list **!** what about Caps?
- **!** creditors or debtors? -->






Use case: Multiple partners in one ledger
===============================================================================

Allocate an expense to one partner
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Bob` tag.

### How to use

### What happens

Allocate a specific sum of expense to one partner
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Bob-10` tag.

### How to use

### What happens

Allocate a specific percentage of expense to one partner
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Bob-40%` tag.

### How to use

### What happens


Allocate expense to many partners within ledger
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Bob #allocate-Alice` tags.

### How to use

### What happens








Use case: Budgeting
===============================================================================

Allocate an expense 100% to one budget position
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Food` tag.

### How to use

### What happens

Allocate a specific sum of expense to one budget position
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Food-7` tag.

### How to use

### What happens

Allocate a specific percentage of expense to one budget position
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Food-75%` tag.

### How to use

### What happens

Allocate expense to many budgeting positions of the ledger
-------------------------------------------------------------------------------
> TL;DR: use `#allocate-Food #allocate-Supplies` tags.

### How to use

### What happens








Use case: something complex
===============================================================================
> TL;DR: nope, read on.







Use case: Savings
===============================================================================
> same as budgeting, just different positions







When to use Share and when Allocate?
===============================================================================
> TL;DR: internal parties - Allocate, external - Share.

There is another quite similar plugin [beancoun_share](https://github.com/Akuukis/beancount_share). The key differences between allocate and share functionalities:

- allocate assigns transactions to equity accounts within the ledger, but share assigns transactions (and spams new creditor/debtor accounts) to external parties.








Configuration
===============================================================================

Note: Do NOT use double-quotes within the configuration! The configuration is a Python dict, not a JSON object.

This is the default configuration in full. Providing it equals to providing no configuration at all.

```
plugin "beancount_share.share" "{
    'mark_name': 'share',
    'meta_name': 'shared',
    'account_debtors': 'Assets:Debtors',
    'account_creditors': 'Liabilities:Creditors',
    'open_date': '1970-01-01',
    'quantize': '0.01'
}"
```

Note that meta_name and open_date may also be set to None - former to disable informative meta generation, and latter to disable open entry creation. Example:

```
plugin "beancount_share.share" "{
    'mark_name': 'share',
    'meta_name': None,
    'account_debtors': 'Assets:Debtors',
    'account_creditors': 'Liabilities:Creditors',
    'open_date': None,
    'quantize': '0.01'
}"
```





Tests
===============================================================================

If the examples above do not suffice your needs, check out the tests.
They consist of human-readable examples for more specific cases.






Development
===============================================================================

Please see Makefile and inline comments.
