Feature: Share expenses with other people easily

#   Background: default

  Scenario: Example in this Readme

#     Given the following setup:
#       2020-01-01 open Assets:Cash
#       2020-01-01 open Expenses:Food:Drinks

#     When this transaction is processed:
#       2020-01-01 * "BarAlice" "Lunch with friend Bob" #allocate-Bob
#         Assets:Cash               -10.00 USD
#         Expenses:Food:Drinks

#     Then should not error
#     Then the original transaction should be modified:
#       2020-01-01 * "BarAlice" "Lunch with friend Bob"
#         Assets:Cash               -10.00 USD
#         Expenses:Food:Drinks        5.00 USD
#           allocated: "Assets:Debtors:Bob (50%, 5.00 USD)"
#         Assets:Debtors:Bob          5.00 USD
#           allocated: "Expenses:Food:Drinks (50%, 5.00 USD)"
