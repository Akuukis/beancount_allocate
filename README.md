Allocate
===============================================================================

[![PyPI - Version](https://img.shields.io/pypi/v/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![PyPI - Wheel](https://img.shields.io/pypi/wheel/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![License](https://img.shields.io/pypi/l/beancount_allocate)](https://choosealicense.com/licenses/agpl-3.0/)
[![Linting](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)


A beancount plugin to split between equities within one ledger.

Allocate plugin uses tag syntax to add info to the transaction:
    <!-- basic: share expense with another partner 50%-50% `#share-Bob`
    amount: share a specific sum of expense with another partner. `#share-Bob-7`
    percentage: share a specific percentage of expense with another partner `#share-Bob-40%`
    many: share expense with multiple partners `#share-Bob #share-Charlie`
    complex: share complex transactions using meta -->


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

Use case: budgeting
===============================================================================

Use case: multiple people in one ledger
===============================================================================

Use case: savings
===============================================================================

When to use Share and when to Allocate?
===============================================================================

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
