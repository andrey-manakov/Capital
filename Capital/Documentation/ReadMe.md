
# Capital app documentation

## General App Description


## Use Cases

### Use Cases List

Group A - Check availability before big purchase

1. Considering big purchase especially financed with initial payment and loan financed it's useful to check how it will influence the future wealth

    - Check cash availible for the purchase
    - Check cash availible for the purchase taking into consideration future spending
    - Check finance availible for the purchase taking into consideration credit cards
    - Check finance availible for the purchase taking into consideration credit cards & future spending (incl. repayment of credit cards)  

Group B - One time interactions
1. Input info about expense on the fly (e.g. bought coffee)

Group C - Asset Purchase financed by collateral based loan
1. Input info about car loan / mortgage (any collateral based loan), plan of payments, asset purchased
2. Payments execution and reflection in data base (influence on expenses, liabilities, etc.)
3. Monitoring of current status and forecast of: value of collateral, value of body (liability), expenses. 
4. Eraly repayment: editing of future transactions, enter transaction of early repayment

Group D - Future regular transactions
1. Each working day I have business lunch 250-500 rubles, I enter the transaction once, and then it charges my account automatically each day

### Use Cases Implementation

Group A

Check cash availible for the purchase

Functions needed:

1. Group related funcs
    - create
    - delete
    - list
    - change name
    - list accounts inside the group
    - add accounts to the group
    - remove accounts from the group
    - calculation of current value and min future value

2. Account related funcs
    - create
    - delete
    - list
    - change name
    - change amount
    - add to the groups
    - remove from the groups
    - list trasactions
    - transfer funds from one account to another

3. Transaction related funcs
    - create simple
    - create recurrent
    - delete one transaction
    - delete recurrent transaction
    - list
    - change one transaction
    - change recurrent transaction
    - auto approve transaction on app start

Group C - Asset Purchase financed by collateral based loan

Considerations:
Two options for early repayment 
1. consider rules and auto calculation of the future transactions on the fly, 
2. or recreation of the repayment plan from scratch after the repayment date.

Group 3
1. Daily transaction could create too heavy load on online database
2. How to select the source for auto transactions: simply one, priority queue switching to the next after reaching 0, etc.


## Bug Fix Needed
1. When app is opened Accounts View Controller is not being updated after accounts are loaded



