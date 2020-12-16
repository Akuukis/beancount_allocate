Feature: Basics

  Scenario: Skip unmarked transactions.
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Assets:Safe
      2020-01-01 open Expenses:Food:Drinks
      2020-01-01 open Income:Random

    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Assets:Cash           -10.00 EUR
        Expenses:Food:Drinks

    Then the original transaction should not be modified
    Then should not error

  Scenario: Skip unmarked transactions even if they have both income and expense.
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Assets:Safe
      2020-01-01 open Expenses:Food:Drinks
      2020-01-01 open Income:Random

    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Income:Random         -10.00 EUR
        Expenses:Food:Drinks

    Then the original transaction should not be modified
    Then should not error

  Scenario: Skip unmarked transactions even if they have no income nor expense.
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Assets:Safe
      2020-01-01 open Expenses:Food:Drinks
      2020-01-01 open Income:Random

    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Assets:Cash           -10.00 EUR
        Assets:Safe

    Then the original transaction should not be modified
    Then should not error

  Scenario: Bug #1 - skip transactions inserted by padding.
    Given the following setup:
      2020-01-01 open Equity:Opening-Balances CHF
      2020-01-01 open Assets:Bank CHF
      2020-01-01 open Assets:Savings CHF
      2020-01-01 pad Assets:Bank Equity:Opening-Balances
      2020-02-02 balance Assets:Bank 2000 CHF

    When this transaction is processed:
      2020-11-17 * "Savings"
        Assets:Savings         1000 CHF
        Assets:Bank           -1000 CHF

    Then should not error
