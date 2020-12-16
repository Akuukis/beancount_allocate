Feature: Shortcuts for marking postings

  Background: default
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Expenses:Food:Drinks

  Scenario: Transaction meta translates to meta for every applicable posting without their own allocate- meta (positive case)
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        allocate: "Bob-4"
        Assets:Cash               -10.00 USD
        Expenses:Food:Drinks

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Assets:Cash               -10.00 USD
        Expenses:Food:Drinks       10.00 USD
          allocated: "Equity:Bob 4.00 USD"
        Equity:Bob                  4.00 USD
          allocated: "Expenses:Food:Drinks 4.00 USD"
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Transaction meta translates to meta for every applicable posting without their own allocate- meta (negative case)
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        allocate: "Bob-9"
        Assets:Cash               -10.00 USD
        Expenses:Food:Drinks
          allocate: "Bob-4"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Assets:Cash               -10.00 USD
        Expenses:Food:Drinks       10.00 USD
          allocated: "Equity:Bob 4.00 USD"
        Equity:Bob                  4.00 USD
          allocated: "Expenses:Food:Drinks 4.00 USD"
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Tags are translated and appended to transaction meta
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with friend Bob" #allocate-Bob-4
        Assets:Cash               -10.00 USD
        Expenses:Food:Drinks

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch with friend Bob"
        Assets:Cash               -10.00 USD
        Expenses:Food:Drinks       10.00 USD
          allocated: "Equity:Bob 4.00 USD"
        Equity:Bob                  4.00 USD
          allocated: "Expenses:Food:Drinks 4.00 USD"
        Equity:Earnings:Current    -4.00 EUR
