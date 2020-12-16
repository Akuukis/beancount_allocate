Feature: allocate a single posting to single account

  Background: default
    Given the following setup:
      2020-01-01 open Equity:Earnings:Current
      2020-01-01 open Assets:Cash
      2020-01-01 open Expenses:Food:Drinks
      2020-01-01 open Expenses:Food:Snacks
      2020-01-01 open Income:RandomVeryVeryLong

  Scenario: Partially allocate sole Expense posting using absolute amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash           -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Equity:Bob-4"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 4.00 EUR"
        Equity:Bob                  4.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Partially allocate sole Expense posting with short account name
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash           -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-4"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 4.00 EUR"
        Equity:Bob                  4.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Partially allocate sole Expense posting using relative amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash           -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-40%"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 40% (4.00 EUR)"
        Equity:Bob                  4.00 EUR
          allocated: "Expenses:Food:Drinks 40% (4.00 EUR)"
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Fully allocate sole Expense posting using absolute amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-10"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 10.00 EUR"
        Equity:Bob                 10.00 EUR
          allocated: "Expenses:Food:Drinks 10.00 EUR"
        Equity:Earnings:Current   -10.00 EUR

  Scenario: Fully allocate sole Expense posting using relative amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-100%"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 100% (10.00 EUR)"
        Equity:Bob                 10.00 EUR
          allocated: "Expenses:Food:Drinks 100% (10.00 EUR)"
        Equity:Earnings:Current   -10.00 EUR

  Scenario: Fully allocate sole Expense posting using ommitted amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash           -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob (100%, 10.00 EUR)"
        Equity:Bob                 10.00 EUR
          allocated: "Expenses:Food:Drinks (100%, 10.00 EUR)"
        Equity:Earnings:Current   -10.00 EUR

  Scenario: allocate sole Income posting
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Found change on floor with Bob"
        Assets:Cash                10.00 EUR
        Income:RandomVeryVeryLong
          allocate: "Bob-40%"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Found change on floor with Bob"
        Assets:Cash                10.00 EUR
        Income:RandomVeryVeryLong -10.00 EUR
          allocated: "Equity:Bob 40% (-4.00 EUR)"
        Equity:Bob                 -4.00 EUR
          allocated: "Income:RandomVeryVeryLong 40% (-4.00 EUR)"
        Equity:Earnings:Current     4.00 EUR

  Scenario: allocate one of several postings
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -12.00 EUR
        Expenses:Food:Snacks        2.00 EUR
        Expenses:Food:Drinks
          allocate: "Equity:Bob-4"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch"
        Assets:Cash               -12.00 EUR
        Expenses:Food:Snacks        2.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 4.00 EUR"
        Equity:Bob                  4.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Earnings:Current    -4.00 EUR
