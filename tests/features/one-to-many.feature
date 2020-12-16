Feature: Allocate a single posting to several accounts

  Background: default
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Expenses:Food:Drinks

  Scenario: Allocate a posting to several different accounts using absolute amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-4"
          allocate2: "Charlie-4"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 4.00 EUR"
          allocated901: "Equity:Charlie 4.00 EUR"
        Equity:Bob                  4.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Charlie              4.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Earnings:Current    -4.00 EUR
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Allocate a posting to several different accounts using relative amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-40%"
          allocate2: "Charlie-40%"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 40% (4.00 EUR)"
          allocated901: "Equity:Charlie 40% (4.00 EUR)"
        Equity:Bob                  4.00 EUR
          allocated: "Expenses:Food:Drinks 40% (4.00 EUR)"
        Equity:Charlie              4.00 EUR
          allocated: "Expenses:Food:Drinks 40% (4.00 EUR)"
        Equity:Earnings:Current    -4.00 EUR
        Equity:Earnings:Current    -4.00 EUR

  Scenario: Allocate a posting to several different accounts using omitted amount
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob"
          allocate2: "Charlie"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob (50%, 5.00 EUR)"
          allocated901: "Equity:Charlie (50%, 5.00 EUR)"
        Equity:Bob                  5.00 EUR
          allocated: "Expenses:Food:Drinks (50%, 5.00 EUR)"
        Equity:Charlie              5.00 EUR
          allocated: "Expenses:Food:Drinks (50%, 5.00 EUR)"
        Equity:Earnings:Current    -5.00 EUR
        Equity:Earnings:Current    -5.00 EUR

  Scenario: Allocate a posting to several different accounts using mixed amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-4"
          allocate2: "Charlie-40%"
          allocate3: "David"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash             -10.00 EUR
        Expenses:Food:Drinks     10.80 EUR
          allocated: "Equity:Bob 4.00 EUR"
          allocated901: "Equity:Charlie 40% (2.40 EUR)"
          allocated902: "Equity:David (60%, 1.80 EUR)"
        Equity:Bob                4.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Charlie            2.40 EUR
          allocated: "Expenses:Food:Drinks 40% (2.40 EUR)"
        Equity:David              3.60 EUR
          allocated: "Expenses:Food:Drinks (60%, 1.80 EUR)"
        Equity:Earnings:Current  -4.00 EUR
        Equity:Earnings:Current  -2.40 EUR
        Equity:Earnings:Current  -3.60 EUR

  Scenario: Allocate a posting to the same account several times using absolute amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-4"
          allocate2: "Bob-4"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 4.00 EUR"
          allocated901: "Equity:Bob 4.00 EUR"
        Equity:Bob                  8.00 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
          allocated901: "Expenses:Food:Drinks 4.00 EUR"
        Equity:Earnings:Current    -8.00 EUR

  Scenario: Allocate a posting to the same account several times using relative amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my friend Bob (a lot)"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-40%"
          allocate2: "Bob-40%"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer with my friend Bob (a lot)"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob 40% (4.00 EUR)"
          allocated901: "Equity:Bob 40% (4.00 EUR)"
        Equity:Bob                  8.00 EUR
          allocated: "Expenses:Food:Drinks 40% (4.00 EUR)"
          allocated901: "Expenses:Food:Drinks 40% (4.00 EUR)"
        Equity:Earnings:Current    -8.00 EUR

  Scenario: Allocate a posting to the same account several times using omitted amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my friend Bob (a lot)"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob"
          allocate2: "Bob"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer with my friend Bob (a lot)"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.00 EUR
          allocated: "Equity:Bob (50%, 5.00 EUR)"
          allocated901: "Equity:Bob (50%, 5.00 EUR)"
        Equity:Bob                 10.00 EUR
          allocated: "Expenses:Food:Drinks (50%, 5.00 EUR)"
          allocated901: "Expenses:Food:Drinks (50%, 5.00 EUR)"
        Equity:Earnings:Current   -10.00 EUR

  Scenario: Allocate a posting to the same account several times using mixed amounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Beer with my friend Bob (a lot)"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks
          allocate: "Bob-4"
          allocate2: "Bob-40%"
          allocate3: "Bob"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Beer with my friend Bob (a lot)"
        Assets:Cash               -10.00 EUR
        Expenses:Food:Drinks       10.80 EUR
          allocated: "Equity:Bob 4.00 EUR"
          allocated901: "Equity:Bob 40% (2.40 EUR)"
          allocated902: "Equity:Bob (30%, 3.60 EUR)"
        Equity:Bob                  8.20 EUR
          allocated: "Expenses:Food:Drinks 4.00 EUR"
          allocated901: "Expenses:Food:Drinks 40% (2.40 EUR)"
          allocated902: "Expenses:Food:Drinks (30%, 3.60 EUR)"
        Equity:Earnings:Current   -10.00 EUR
