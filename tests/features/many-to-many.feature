Feature: Share several postings to several accounts

  Background: default
    Given the following setup:
      2020-01-01 open Assets:Cash
      2020-01-01 open Expenses:Food:Drinks
      2020-01-01 open Expenses:Food:Lunch
      2020-01-01 open Expenses:Food:Snacks

  Scenario: Share all applicable postings to several overlapping accounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with my guy friends"
        Assets:Cash           -24.00 EUR
        Expenses:Food:Lunch    17.00 EUR
          allocate: "Bob-7"
          share2: "Charlie"
        Expenses:Food:Drinks    7.00 EUR
          allocate: "Bob"
          share2: "Charlie-3"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch with my guy friends"
        Assets:Cash             -24.00 EUR
        Expenses:Food:Lunch       5.00 EUR
          allocated: "Equity:Bob 7.00 EUR"
          shared901: "Equity:Charlie (100%, 10.00 EUR)"
        Expenses:Food:Drinks      2.00 EUR
          allocated: "Equity:Charlie 3.00 EUR"
          shared901: "Equity:Bob (100%, 4.00 EUR)"
        Equity:Bob               11.00 EUR
          allocated: "Expenses:Food:Lunch 7.00 EUR"
          shared901: "Expenses:Food:Drinks (100%, 4.00 EUR)"
        Equity:Charlie           13.00 EUR
          allocated: "Expenses:Food:Lunch (100%, 10.00 EUR)"
          shared901: "Expenses:Food:Drinks 3.00 EUR"
        Equity:Earnings:Current -11.00 EUR
        Equity:Earnings:Current -13.00 EUR

  Scenario: Share several applicable postings to several overlapping accounts
    When this transaction is processed:
      2020-01-01 * "BarAlice" "Lunch with my guy friends"
        Assets:Cash           -25.00 EUR
        Expenses:Food:Snacks    1.00 EUR
        Expenses:Food:Lunch    17.00 EUR
          allocate: "Bob-7"
          share2: "Charlie"
        Expenses:Food:Drinks
          allocate: "Bob"
          share2: "Charlie-3"

    Then should not error
    Then the original transaction should be modified:
      2020-01-01 * "BarAlice" "Lunch with my guy friends"
        Assets:Cash             -25.00 EUR
        Expenses:Food:Snacks      1.00 EUR
        Expenses:Food:Lunch       5.00 EUR
          allocated: "Equity:Bob 7.00 EUR"
          shared901: "Equity:Charlie (100%, 10.00 EUR)"
        Expenses:Food:Drinks      2.00 EUR
          allocated: "Equity:Charlie 3.00 EUR"
          shared901: "Equity:Bob (100%, 4.00 EUR)"
        Equity:Bob               11.00 EUR
          allocated: "Expenses:Food:Lunch 7.00 EUR"
          shared901: "Expenses:Food:Drinks (100%, 4.00 EUR)"
        Equity:Charlie           13.00 EUR
          allocated: "Expenses:Food:Lunch (100%, 10.00 EUR)"
          shared901: "Expenses:Food:Drinks 3.00 EUR"
        Equity:Earnings:Current -11.00 EUR
        Equity:Earnings:Current -13.00 EUR
