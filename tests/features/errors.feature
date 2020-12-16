Feature: Report meaningful errors

  Background: default
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Assets:Safe
      2020-01-01 open Expenses:Food:Drinks
      2020-01-01 open Expenses:Food:Lunch
      2020-01-01 open Income:Random

  Scenario: Throw Error if no account provided
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob" #allocate-
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks

    Then the original transaction should not be modified
    And should produce plugin error:
      Plugin "allocate" requires mark to contain account name, seperated with "-".

  Scenario: Throw Error for badly formatted abosulute amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob" #allocate-Bob-2a50
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks

    Then the original transaction should not be modified
    And should produce plugin error:
      Something wrong with absolute fraction "2a50", please use a dot, e.g. "2.50".

  Scenario: Throw Error for badly formatted relative amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob" #allocate-Bob-3a33p
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks

    Then the original transaction should not be modified
    And should produce plugin error:
      Something wrong with relative fraction "3a33p", please use a dot, e.g. "33.33p".

  Scenario: Throw Error if sharing a non-applicable posting (Assets, Liabilities or Equity)
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Assets:Cash               -10.00 EUR
          allocate: "Bob-4"
        Expenses:Food:Drinks

    Then the original transaction should not be modified
    And should produce plugin error:
      Mark "allocate" doesn't make sense on a "Assets" type posting.

  Scenario: Throw Error if total shared absolute amount is greater than posting amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my guy friends"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-6"
          allocate2: "Charlie-6"

    Then the original transaction should not be modified
    Then should produce plugin error:
        The posting can't allocate more than it's absolute value

  Scenario: Throw Error if total shared relative amount is greater than 100%
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my guy friends"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-60%"
          allocate2: "Charlie-60%"

    Then the original transaction should not be modified
    And should produce plugin error:
        The posting can't allocate more percent than 100%.

  Scenario: Throw Error if further sharing a posting whose amount is reduced to zero after sharing absolute amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my guy friends"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-10"
          allocate2: "Charlie-42%"

    Then the original transaction should not be modified
    And should produce plugin error:
        It doesn't make sense to allocate a remaining amount of zero.

  Scenario: Throw Error if further sharing a posting whose amount is already shared by 100%
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my guy friends"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-100%"
          allocate2: "Charlie"

    Then the original transaction should not be modified
    And should produce plugin error:
        It doesn't make sense to further auto-allocate when amount is already allocate for full 100%.

  Scenario: Throw Error if sharing mark has no effect
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with my guy friends" #allocate-Bob
        Assets:Cash           -15.00 EUR
        Assets:Safe

    Then the original transaction should not be modified
    And should produce plugin error:
        Plugin "allocate" doesn't work on transactions that has nor income and expense.

  Scenario: Throw Error if sharing both Expense and Income postings
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with my guy friends"
        Assets:Cash           -15.00 EUR
        Expenses:Food:Lunch    17.00 EUR
          allocate: "Bob"
        Income:Random          -2.00 EUR
          allocate: "Bob"

    Then the original transaction should not be modified
    And should produce plugin error:
        Plugin "allocate" doesn't work on transactions that has both income and expense: please allocate it up into two transactions instead.
