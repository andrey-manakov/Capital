#  To Do List


## Critical ToDo (to fit Viable requirement)
1. Create Account Group
2. Server func - update account group AMOUNT
    - on creation
    - on update of accounts field of account group
    - on update of amount of accounts from the account group
    - on delete of account
    
### Server funcs

1. Account Group
    1.1. OnCreate:
            - update groups frield of accounts from the group
            - update account group amount based on accounts amounts
    1.2.  OnUpdate:
            - if accounts field changes, update amount field of account group & update groups field of accounts
            - if name changes update groups field of account (nice to have)
    1.3. OnDelete:
            - Update groups field of accounts from the group

2. Account
    2.1. OnCreate:
        - If groups not nil, update accounts fields of account groups & amount of account group
    2.2. On Update:
        - Update account group amount and accounts fields

3. Transaction
    3.1. OnCreate
        - Update Account  
    3.2. OnUpdate
        - If from changes update old from & new from account
        - If to changes update old to & new to account
        - If amount changes update from & to account
3.3. OnDelete

3. Server func - update account group AMOUNT on change of accounts which belong to the group
4. Server func - update account group AM

## Nice to have

## Account Group TO DO
1. Filter accounts based on map field .GreaterThan instead of .isEqual
2. Segmented control with assets and expenses only? Get back if it becomes clear what is the idea of Account Group with Expenses and Revenues


## Short term to do

## Mid term to do
1. How to define when ChildAdded update ended. Need to start transaction load, capital account check, etc.
2. Fix that Capital account is not checked / created when user already logged in
3. Prevent deleting of capital account
4. Add print() to all custom deinit classes
5. Handle big loads of data: e.g. 3000 transactions... UI freezing, long load process etc.
6. Move Load initial data to FireStore with batch
7. Implement search in Simple Table    
1. Introduce Capital account creation, prevent delete, or check each time, or calculate it locally?
3. Process unapproved transactions: auto approve, auto postpone, etc.

## Long term to do list
1. Consider add hierachy level in accounts - account type
2. Make classes CustomStringConvertible
3. Check empty protocols, consider change to more high level protocols
4. Try not to use specific funcs for exchange between funcs
5. Check document existence before use (firestore)

## Done
2. Transaction view for account
4. Add delete all implementation

