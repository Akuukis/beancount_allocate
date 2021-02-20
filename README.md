Allocate/Assign
===============================================================================

[![PyPI - Version](https://img.shields.io/pypi/v/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![PyPI - Downloads](https://img.shields.io/pypi/dm/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![PyPI - Wheel](https://img.shields.io/pypi/wheel/beancount_allocate)](https://pypi.org/project/beancount-allocate/)
[![License](https://img.shields.io/pypi/l/beancount_allocate)](https://chooseBobnse.com/licenses/agpl-3.0/)
[![Linting](https://img.shields.io/badge/code%20style-black-000000.svg)](https://github.com/psf/black)


A beancount plugin to allocate transactions among multiple equity accounts (e.g. budgeting positions) within one ledger.

An equity account in Beancount can be used for many purposes. Most notably, for **budgeting**, **managing savings** or **managing multiple partners within one ledger**.

Allocate plugin uses tag syntax to add info to the transaction.
- basic: allocate expense 100% to an budget category - simply use `#allocate-Food`
- amount: allocate a specific sum of expense to a budget category. `#allocate-Food-10`
- percentage: allocate a specific percentage % of expense to a budget category. `#allocate-Food-75p`
- many: allocate expense to many budget categories within a ledger. `#allocate-Food #allocate-Entertainment`

Equity accounts
===============================================================================

TODO Kalvis: what are equity accounts? when are they useful?

Budgeting
===============================================================================

Budgeting means assigning every money unit a job (budget category) before it is spent. In Beancount that happens by assigning money from your income account `Equity:Earnings:Current` to the budget categories where you plan to spend money.


Let's say you have a 1000 EUR income and at the beginning of the month you make your budget:

```beancount
2021-01-01 * "January budget"
  Equity:Food                       -250.00 EUR
  Equity:Supplies                    -50.00 EUR
  Equity:Utilities                   -50.00 EUR
  Equity:Housing                    -350.00 EUR
  Equity:Entertainment              -100.00 EUR
  Equity:Savings                    -200.00 EUR
  Equity:Earnings:Current           1000.00 EUR
```

From now on, the money is assigned from income account to each budget category. And when you register expenses, they should use the money from each budget category (because income account is already empty anyways). And this is where `#allocate-` tag comes handy: it automatically assigns the expense to the budget category specified in the tag (usecases below).

Repeat plugin
--------------------------------------------------------------------------------

If your budget or at least some budget categories do not change month by month, you can make use of another plugin from the utils package: [repeat](https://github.com/Akuukis/beancount_plugin_utils)

TODO Kalvis: how to do budgeting in Beancount and using our plugins (aka - repeating transactions)

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






Use case: Allocate an expense to "Food" budget category
===============================================================================

> TL;DR: use `#allocate-Food` tag.

At the start of the month, you make your budget and decide that this month you will spend 200 EUR on food. So, you budget the 200 EUR in the `Equity:Food` account:

```beancount
2021-01-01 * "January food budget"
  Equity:Food                       -200.00 EUR
  Equity:Earnings:Current            200.00 EUR
```

Two days, later, you go to shop and spend 50 EUR on groceries for the week.

How to use
-------------------------------------------------------------------------------

Tag your transaction simply with a tag + budget category/equity account name, like #allocate-Food:

```beancount
2021-01-03 * "Supermarket" "Groceries" #allocate-Food
  Assets:Cash           -50.00 EUR
  Expenses:Food:Groceries
```

What happens
-------------------------------------------------------------------------------

The transaction will get 2 new postings to represent the change in budget: Food budget position shrinks by 100% = 50 EUR of the transaction amount (you spent that much from Food budget category), but earnings gets the same amount of equity back.

```beancount
2020-01-03 * "Supermarket" "Groceries"
  Assets:Cash               -50.00 EUR
  Expenses:Food:Groceries    50.00 EUR
  Equity:Food                50.00 EUR
  Equity:Earnings:Current   -50.00 EUR
```


Use case: Allocate a specific sum of expense to one budget category
===============================================================================

> TL;DR: use `#allocate-Food-7` tag.

At the start of the month, you make your budget and decide that this month you will spend 200 EUR on food. So, you budget the 200 EUR in the `Equity:Food` account:

```beancount
2021-01-01 * "January food budget"
  Equity:Food                       -200.00 EUR
  Equity:Earnings:Current            200.00 EUR
```

Two days, later, you spend 50 EUR in a bar of what 7 EUR were food (*at least something from this you can budget...*).

How to use
-------------------------------------------------------------------------------

Tag your transaction simply with a tag + budget category + amount:

```beancount
2021-01-03 * "Bar" "Beer and snacks" #allocate-Food-7
  Assets:Cash             -50.00 EUR
  Expenses:Alcohol         50.00 EUR
```

What happens
-------------------------------------------------------------------------------

The transaction will get 2 new postings to represent the change in budget: Food budget shrinks by the 7 EUR that you specified of the 50 EUR transaction, but earnings get the same 7 EUR of equity back.

```beancount
2020-01-03 * "Bar" "Beer and snacks"
  Assets:Cash               -50.00 EUR
  Expenses:Alcohol           50.00 EUR
  Equity:Food                7.00 EUR
  Equity:Earnings:Current   -7.00 EUR
```

Use case: Allocate a specific percentage % of expense to one budget category
===============================================================================

> TL;DR: use `#allocate-Food-75p` tag.

At the start of the month, you make your budget and decide that this month you will spend 200 EUR on food. So, you budget the 200 EUR in the `Equity:Food` account:

```beancount
2021-01-01 * "January food budget"
  Equity:Food                       -200.00 EUR
  Equity:Earnings:Current            200.00 EUR
```

Two days, later, you spend 20 EUR in a supermarket. You are too lazy to count the specific sum, and with a quick scan of the receipt, you estimate that roughly 75% of it is groceries.

How to use
-------------------------------------------------------------------------------

Tag your transaction with a tag + budget category + percentage:

```beancount
2021-01-03 * "Supermarket" "Mostly groceries" #allocate-Food-75p
  Assets:Cash                    -20.00 EUR
  Expenses:Food:Groceries         20.00 EUR
```

What happens
-------------------------------------------------------------------------------

The transaction will get 2 new postings to represent the change in budget: Food budget shrinks by 15 EUR that is the 75% that you specified of the transaction, but earnings get the same 15 EUR of equity back.

```beancount
2020-01-03 * "Supermarket" "Groceries"
  Assets:Cash               -20.00 EUR
  Expenses:Food:Groceries    20.00 EUR
  Equity:Food                15.00 EUR
  Equity:Earnings:Current   -15.00 EUR
```

Use case: Allocate expense to many budgeting categores of the ledger
===============================================================================

> TL;DR: use `#allocate-Food #allocate-Entertainment` tags.

At the start of the month, you make your budget and decide that this month you will spend 200 EUR on food and 100 EUR on entertainment. So, you budget the 200 EUR in the `Equity:Food` account and 100 EUR in the `Equity:Entertainment` account:

```beancount
2021-01-01 * "January budget categories"
  Equity:Food                       -200.00 EUR
  Equity:Entertainment              -100.00 EUR
  Equity:Earnings:Current            300.00 EUR
```

Two days, later, you go to a fancy dinner and spend 40 EUR in a restaurant. This is not typical of you, so this is a pretty random expense. Because it was both food and entertainment, you allocate this expense to both categories evenly.

How to use
-------------------------------------------------------------------------------

Tag your transaction with a tag for each budget category you want to allocate the transaction to with: tag + budget category:

```beancount
2021-01-03 * "Restaurant" "Fancy dinner" #allocate-Food #allocate-Entertainment
  Assets:Cash                    -40.00 EUR
  Expenses:Random                 40.00 EUR
```

What happens
-------------------------------------------------------------------------------

The transaction will get 3 new postings to represent the change in budget: Food and Entertainment budget categories shrink each by 20 EUR that is 50% of the transaction each, but earnings get the sum of both back.

```beancount
2020-01-03 * "Restaurant" "Fancy dinner"
  Assets:Cash               -40.00 EUR
  Expenses:Random            40.00 EUR
  Equity:Food                20.00 EUR
  Equity:Entertainment       20.00 EUR
  Equity:Earnings:Current   -40.00 EUR
```





<!-- 
Use case: Savings
===============================================================================
> same as budgeting, just different positions -->





Use case: Multiple partners in one ledger
===============================================================================
> TL;DR: use tag with a partner name: `#allocate-Bob`.

Allocate plugin can be convenient if you share most of your income and expenses with a partner/friend and you both use one ledger. Allocation in this sense means making the transaction personal (default = shared).


For example, you are roommates with your friend Bob. You share a common ledger and have private equity accounts:

```beancount
  open Equity:Bob
  open Equity:You
```

You bought socks for Bob because he asked. At the end - you spent your joined money on his private socks.


How to use
-------------------------------------------------------------------------------

Tag your transaction to the partner you want to allocate the transaction to: tag + name:

```beancount
      2021-01-01 * "SocksShop" "Socks" #allocate-Bob
        Assets:Cash           -5.00 EUR
        Expenses:Clothes
```

What happens
-------------------------------------------------------------------------------

The transaction will get 2 new postings to represent the change in equity: Bob's private equity account shrinks (he can spend less), but earnings get equity back.

```beancount
      2021-01-01 * "SocksShop" "Socks"
        Assets:Cash               -5.00 EUR
        Expenses:Clothes           5.00 EUR
        Equity:Bob                 5.00 EUR
        Equity:Earnings:Current   -5.00 EUR
```

For more specific use cases check out budgeting examples above - the basic functionalty stays the same.






Use case: Something complex
===============================================================================
> TL;DR: turn on metadata

For more complex cases that might get confusing, use debug that shows all the metadata. Transactions with metadata will include information about each posting:
- the other account connected to the posting;
- percentage and amount of sum allocated to the account of posting.

Metadata setup
-------------------------------------------------------------------------------

To turn on metadata, edit settings:

```beancount
TODO Kalvis input
```

How to use
-------------------------------------------------------------------------------

At the start of the month, you make your budget and decide that this month you will spend 200 EUR on food. So, you budget the 200 EUR in the `Equity:Food` account:

```beancount
2021-01-01 * "January food budget"
  Equity:Food                       -200.00 EUR
  Equity:Earnings:Current            200.00 EUR
```

Two days, later, you go to shop and spend 50 EUR on groceries for the week.

```beancount
2021-01-03 * "Supermarket" "Groceries" #allocate-Food
  Assets:Cash                     -50.00 EUR
  Expenses:Food:Groceries          50.00 EUR
```

What happens
-------------------------------------------------------------------------------

Transaction has an extra line (or more lines, depending on the complexity of your transaction) of meta information for each posting: the other account involved; percentage and amount of sum allocated to the account.

```beancount
2020-01-03 * "Supermarket" "Groceries"
  Assets:Cash               -50.00 EUR
  Expenses:Food:Groceries    50.00 EUR
    allocated: "Equity:Food (100%, 7.00 EUR)"
  Equity:Food                7.00 EUR
    allocated: "Expenses:Food:Groceries (100%, 7.00 EUR)"
  Equity:Earnings:Current   -7.00 EUR
```


I got even more complex use cases
-------------------------------------------------------------------------------
> TL;DR: skip tags, write full transactions.

In reality, tags are only the shortcuts of share plugin to make your life easier. You can always write out the full transaction. Sometimes it does make more sense.








When to use Share and when Allocate plugins?
===============================================================================
> TL;DR: internal parties - Allocate, external - Share.

There is another quite similar plugin [beancoun_share](https://github.com/Akuukis/beancount_share). The key differences between allocate and share functionalities:

- allocate assigns transactions to equity accounts within the ledger
- share assigns transactions (and spams new creditor/debtor accounts) to external parties.


You can always use both for their specific purposes.






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
