# Capital App Documentation



Date: 29 dec 2018

Author: Andrey Manakov



## Contents

[Introduction](#introduction)

[App Concept](#app_concept)

[Interface](#interface)

[Services](#services)



## Introduction

<!--- provide document introduction --->



## App_Concept

### App Core Functionality

Answer the question: ::how much I can spend, why and when::? (Question later on) By the way, this could be the title. 

### Similar app

In App Store there is a simple app Today’s budget with similar functionality , but it is too simple. It doesn’t answer the question why, it doesn’t support credit card mechanics (when you use credit card you should pay back) 

### From Purpose to functional requirements

#### Complication #1 - NOT ONLY WALLET

To show cash available we just need to track **one** amount, but it’s also important to see where we have money. So we need details - different accounts.

#### Complication #2 - SEVERAL WAYS TO ANSWER THE QUESTION

There are different kind of answers to the Question:

- Cash in wallet, 
- Plus debit cards
- Plus credit cards
- Minus forecasted spendings including credit card payback
- Plus short term deposits and liquid assets, receivables & minus short term debts and payables 
- Plus long term deposits and fixed assets & long short term debts

So, to answer the question accurately, we need tool to take into account these complications.

#### Complication #3 - WHEN

We need to understand time dimension, we can spend today X, but tomorrow we could spend Y (if the salary is supposed to come)

#### Complication #4 - WHY

There is also “why” in Question, meaning that we should take into account.
So, we need to understand 

#### Complication #5 - SEVERAL SPENDERS

What if several people participate in spending, so you need to put together information to provide accurate answer to the Question

#### Complication #6 - DIFFERENT PLATFORMS

In a modern world - this should be open meaning that we should be able to send info related to the Question to Web, to Excel to whatever destination

### Use Cases

#### Use Cases List

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

#### Use Cases Implementation

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



### Accounting principles

#### Mortgage example

For example mortgage payment 70000: 60000 interest & 10000 body

VTB Debit account -(70000)-> Mortgage Short Term debt
Flat LO -(70000)-> Expense Living
Mortgage Short Term Debt -(60000)-> Revenue 
Mortgage Short Term Debt -(10000)-> Mortgage Long Term Debt 
Expense Living -(70000)-> Capital
Capital -(60000)-> Revenue? 

Totals:
VTB Debit account -70000
Mortgage Short Term debt 0
Revenue -60000
Mortgage Long Term Debt -10000
Expense Living -70000

## 

## Interface



1. [General purpose screens](#general_purpose_screens)
2. [DashBoard Branch](#dashboard_branch) 
3. [Accounts Branch](#accounts_branch)
4. [New Transaction Branch](#new_transaction_branch)
5. [Transactions Branch](#transactions_branch)
6. [Settings Branch](#settings_branch)



### General_purpose_screens

1. [Screen-LoginVC](#screen-loginvc)
2. [Screen-TabBarController](#screen-tabbarcontroller)
3. [Screen-SimpleSelectorVC](#screen-simpleselectorvc)



#### Screen-TemplateVC

##### Description

##### Elements

##### Actions

##### Called by



#### Screen-LoginVC

##### Description

The first screen users sees after opening of the app. Screen allows to login or sign up with email and password credentials.

##### Elements

1. *email* text field
2. *password* text field
3. button *sign in* calls [sign in service](#service-signin)
4. button *sign up* calls [sign up service](service-signup)

##### Actions

1. upon receival of info about user sign in opens [Main Screen](#screen-tabbarcontroller)



#### Screen-TabBarController

##### Description

Tab bar style screen with 5 tabs. Tab bar of this screen is present on most of the app's screens.

##### Elements

1. *dashboard* tab bar item opens [dashboard screen](#screen-accountgroupsvc)
2. *accounts* tab bar item opes [accounts screen](#screen-accountsvc)
3. *new transaction* tab bar item opens [new transaction screen](#screen-newtransactionvc)
4. *transaction* tab bar item opens [transactions screen](#screen-transactionsvc)
5. *settings* tab bar item opens [settings screen](#screen-settingsvc)

##### Actions

no additional actions

##### Called by

1. [Screen-LoginVC](#screen-loginvc)



#### Screen-SimpleSelectorVC

##### Description

Screen to select one value in the list provided

##### Elements

1. table with the list of values to select

##### Actions

1. returns the value selected to the caller

##### Called by

1. [Screen-TransactionEditVC](#screen-transactioneditvc)



### DashBoard_Branch

1. [Screen-AccountGroupsVC](#screen-accountgroupsvc)
2. [Screen-AccountGroupAccountsVC](#screen-accountgroupaccountsvc)
3. [Screen-AccountGroupChartVC](#screen-accountgroupchartvc)



#### Screen-AccountGroupsVC

##### Description

Screen shows account groups with information about each group: for cashflow-type group current and minimum amount, for profit&loss-type group current value.

##### Elements

1. segmented control to select account group type
2. list of account groups of selected type

##### Actions

1. gets data about account groups through service [setListnerToAccountGroup](#service-setlistnertoaccountgroup)
2. upon selection of segment in segmented control - filters data and update list
3. upon selection of account group opens [Account Group Accounts](#screen-accountgroupaccountsvc)

##### Called by

1. [Screen-TabBarController](#screen-tabbarcontroller)



#### Screen-AccountGroupAccountsVC

##### Description   

Screen shows accounts which belong to the group selected.

##### Elements

1. Table with accounts with info about current value and for 
   - asset-type accounts min value
   - liability-type accounts max value
2. Right navigation bar button *chart* opens [Screen-AccountGroupChartVC](#screen-accountgroupchartvc)

##### Actions

1. on tap on account row opens [Screen-AccountChartVC](#screen-accountchartvc)

##### Called by

1. [Screen-AccountGroupsVC](#screen-accountgroupsvc)



#### Screen-AccountGroupChartVC

##### Description

Shows time series chart of dynamics of account group amount including forecast.

##### Elements

1. chart element
2. transaction table on row tap opens [Screen-TransactionEditVC](#screen-transactioneditvc)

##### Actions

1. Move left-right on the chart showing the transactions corresponding the time moment
2. Move left-right on the bottom axis moving the axes start and end
3. Zoom in / out chart changing the scale
4. Tap on chart show the amount at the corresponding moment
5. Swipe transaction from right to left - delete transaction and update chart

##### Called by

1. [Screen-AccountGroupAccountsVC](#screen-accountgroupaccountsvc)



### Accounts_Branch

1. [Screen-AccountsVC](#screen-accountsvc)

2. [Screen-AccountChartVC](#screen-accountchartvc)

3. [Screen-AccountEditVC](#screen-accounteditvc)


#### Screen-AccountsVC

##### Description

Screen shows accounts with information about each account: for assets current and minimum amount, for liabilities current and max value.

##### Elements

1. segmented control to select account type
2. list of accounts of selected type

##### Actions

1. gets data about account groups through service [setListnerToAccount](#service-setlistnertoaccount)
2. upon selection of segment in segmented control - filters data and update list
3. upon selection of account group opens [Screen-AccountChartVC](#screen-accountchartvc)

##### Called by

1. [Screen-TabBarController](#screen-tabbarcontroller)



#### Screen-AccountChartVC

##### Description

Shows time series chart of dynamics of account amount including forecast.

##### Elements

1. chart element
2. transaction table on row tap opens [Screen-TransactionEditVC](#screen-transactioneditvc)
3. right navigation bar button *edit* opens [Screen-AccountEditVC](#screen-accounteditvc)

##### Actions

1. Move left-right on the chart showing the transactions corresponding the time moment
2. Move left-right on the bottom axis moving the axes start and end
3. Zoom in / out chart changing the scale
4. Tap on chart show the amount at the corresponding moment
5. Swipe transaction from right to left - delete transaction and update chart

##### Called by

1. [Screen-AccountGroupAccountsVC](#screen-accountgroupaccountsvc)



#### Screen-AccountEditVC

##### Description

Allows to edit/delete account

##### Elements

1. *account type* segmented control
2. *account name* text field
3. *account amount* text field
4. *delete* button
5. right navigation bar button *done*

##### Actions

1. delete with deletion of all related transaction
2. delete from interface (hide)
3. delete with replacing in related transactions to another account
4. delete with replacing in related transactions to capital account
5. saving account info on edit button tap

##### Called by

1. [Screen-AccountChartVC](#screen-accountchartvc)



### New_Transaction_Branch

1. [Screen-TransactionEditVC](#screen-transactioneditvc)
2. [Screen-AccountSelectVC](#screen-accountselectvc)

#### Screen-TransactionEditVC

##### Description

Screen allows to edit and delete selected transaction

##### Elements

1. from row on tap opens [Screen-AccountSelectVC](#screen-accountselectvc)
2. amount row on tap make amount text field first responder
3. to row on tap opens [Screen-AccountSelectVC](#screen-accountselectvc)
4. date row on tap show / hide date selection row
5. date selection row (shown after date row is tapped) on change updates date row
6. approval mode (show if selected date is in future) on tap opens
7. repeat mode row (never by default) on tap opens [Screen-SimpleSelectorVC](#screen-simpleselectorvc)
8. repeat end daterow  (shown if repeat mode is not never)
9. repeat end date selection row (shown after repeat end date is tapped)
10. *delete* button
11. right navigation bar button *done*

##### Actions

1. delete only selected transaction
2. delete selected trasaction and recurrent transaction in future
3. delete selected transaction and all recurrent transactions
4. save changes in selected transaction only
5. save changes in selected transaction and future recurrent transactions
6. save changes in selected transaction and all recurrent transactions
7. when one supplementary row (pp. 5, 8) is being open or amount field is becoming first responder (p. 2) other supplementary rows are removed

##### Called by

1. [Screen-AccountGroupChartVC](#screen-accountgroupchartvc)



#### Screen-AccountSelectVC

##### Description

Allows to select one account

##### Elements

1. segmented control to select account type
2. list of accounts of selected type

##### Actions

1. gets data about account groups through service [setListnerToAccount](#service-setlistnertoaccount)
2. upon selection of segment in segmented control - filters data and update list

##### Called by

1. [Screen-TransactionEditVC](#screen-transactioneditvc)



### Transactions_Branch

1. [Screen-TransactionsVC](#screen-transactionsvc)



#### Screen-TransactionsVC

##### Description

##### Elements

##### Actions

##### Called by

1. [Screen-TabBarController](#screen-tabbarcontroller)



### Settings_Branch

1. [Screen-SettingsVC](#screen-settingsvc)



#### Screen-SettingsVC

##### Description

##### Elements

##### Actions

##### Called by

1. [Screen-TabBarController](#screen-tabbarcontroller)

### 

## Services

### DataServices

#### Service-SignIn

#### Service-SignUp

#### Service-setListnerToAccountGroup

#### Service-setListnerToAccount



## Data_Model

### Account



## App Archticture

### Data Model

- [ ] Create Data Model description



#### Rules

##### Types Of Classses

1. VC - Childs of UIViewController class, uses UIKit
2. Service class - Helper for VC, **doesn't** implement UIKit, it uses Model Classes
3. Views - implement UIKit
4. Data - doesn't implement UIKit, uses Model Classes
5. FireStoreData, FireAuth - implemenent FireStore

Note: Implement means usage of the corresponding classes

##### Classes Communications

One way connections: Views<- **VC** ->Service->Data->FireStoreData.

1. Service doesn't have reference to VC
2. Data doesn't have reference to VC, Service
3. FireStoreData doesn't have references to VC, Serivce, Firestore
4. VC doesn't call Data, FireStore, it only calls Service
5. Views, VC, FireStoreData - doesn't use Model Classes (FinTransaction, Account, Account.Group) - ???
6. Service and Data use Model classes (in communication between each other)

##### Protocols

1. Communication strictly through protocols
2. Protocols are named as {ClassNameProtocol}.
3. Protocols are stored in a separate files in case of complex classes, in the same file in case of simple classes

##### Documentation

1. All Classes, functions, properties are documented
2. Class instance properties are documented in class description (above the class declaration)
3. Function description is above function

##### Views

Views doesn't have references to VC, except complex VC with implementation of delegate pattern

##### Other

1. Always unowned self in closure
2. All data base actions have completion and log error to special class (to switch between printing during debug and sending info during production)
3. Try to move as much code as possible from VC to VC Service (including for example unwrapping)



## Tasks

### Operations

#### Accounts

1. Create Account
   - Check of Capital account existance upon sign in, sign out
   - Create transaction for initial value
2. List Account
   - Button create account at the bottom to add new account (optional)
3. Delete Account
   - Delete account from groups
   - Change deleted account to capital
   - Prevent delete of capital account
4. Edit Account

#### Transactions

1. Create trasnsaction
   - Simple transaction
   - Transaction in past
   - Transaction in future
   - Reccurrent transaction
   - Update account amount
   - Update account min account amount
2. Edit transaction

- Edit simple transaction
- 

#### Account Groups



- 







## Decisions to be made

### Mechanisms of firestore update

1. Simple update of all related records from client
2. Update within transaction
3. Make primary change from client + server side client functions to update the rest

### Future transactions

How to store information about future transactions

1. Rules based: do not create and store transaction, store rules, and when needed calculate forecast based on that rules
2. Transaction based: 



## General App Description

## 

## Sample date

### Sample transactions

#### Expenses

1. Children swimming pool - 15000 RUB/Month + Taxi 10000 RUB / Month
2. Children gymnastics - 15000 RUB/Month
3. KinderGarden+ - 10000 RUB/Month
4. Utilities - 13000 RUB/Month
5. Children Health (incl. Sanare) - 40000 RUB/Year - 4000 RUB/M
6. Mortgage - 70000 RUB/Month
7. Loan VTB800 - 22000 RUB/Month
8. Loan Skoda Yeti - 31000 RUB/Month
9. Parking - 10000 RUB/Month
10. Business Lunch - 300 RUB / Wokring Day - 6000 RUB / Month
11. Products - 20000 Rub/Month
12. Beuty procedures - 10000 Rub / Month
13. Sport Club - 60000 RUB/Year - 5000 Rub / Month
14. Apparel - 60000 Rub/Year - 5000 Rub / Month
15. Entertainment & Dine Out -  20000 Rub / Month
16. Gasolina - 4000 RUB/Month
17. Car Insurance - 40000 Rub / Year - 3500 Rub / Month
18. Mortgage Insurance - 40000 Rub / Year
19. Kids Birthdays - 40000 Rub / Year
20. Our Birthdays - 40000 Rub / Year
21. Cell Phones, Internet, Mobile Subscriptions, Cloud Drives - 10000 Rub / Month
22. QClean 12000 Rub/Month

Total 

#### Revenue

1. Salary



## Video lesson series
### Contents
#### PART I - Starting
1. Intro
2. First step (Xcode applications, one page app with and without storyboard)
3. First working app - some table view with fake lines
4. TabViewController & NavigationViewController

#### PART II - Logic
1. Core functionality & Functional requirements
2. Mockup screens in storyboard

