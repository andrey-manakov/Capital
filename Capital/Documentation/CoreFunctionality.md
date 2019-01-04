# Simple Finance - Core Functionality
Answer the question: ::how much I can spend, why and when::? (Question later on) By the way, this could be the title. 

## Similar app
In App Store there is a simple app Today’s budget with similar functionality , but it is too simple. It doesn’t answer the question why, it doesn’t support credit card mechanics (when you use credit card you should pay back) 

## From Purpose to functional requirements
### Complication #1 - NOT ONLY WALLET
To show cash available we just need to track **one** amount, but it’s also important to see where we have money. So we need details - different accounts.

### Complication #2 - SEVERAL WAYS TO ANSWER THE QUESTION
There are different kind of answers to the Question:
* Cash in wallet, 
* Plus debit cards
* Plus credit cards
* Minus forecasted spendings including credit card payback
* Plus short term deposits and liquid assets, receivables & minus short term debts and payables 
* Plus long term deposits and fixed assets & long short term debts

So, to answer the question accurately, we need tool to take into account these complications.

### Complication #3 - WHEN
We need to understand time dimension, we can spend today X, but tomorrow we could spend Y (if the salary is supposed to come)

### Complication #4 - WHY
There is also “why” in Question, meaning that we should take into account.
So, we need to understand 

### Complication #5 - SEVERAL SPENDERS
What if several people participate in spending, so you need to put together information to provide accurate answer to the Question

### Complication #6 - DIFFERENT PLATFORMS
In a modern world - this should be open meaning that we should be able to send info related to the Question to Web, to Excel to whatever destination

