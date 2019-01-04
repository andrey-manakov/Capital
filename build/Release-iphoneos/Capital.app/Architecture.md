#  App Archticture

## Data Model


## Rules

### Types Of Classses
1. VC - Childs of UIViewController class, uses UIKit
2. Service class - Helper for VC, **doesn't** implement UIKit, it uses Model Classes
3. Views - implement UIKit
4. Data - doesn't implement UIKit, uses Model Classes
5. FireStoreData, FireAuth - implemenent FireStore

Note: Implement means usage of the corresponding classes


### Classes Communications
One way connections: Views<- **VC** ->Service->Data->FireStoreData.
1. Service doesn't have reference to VC
2. Data doesn't have reference to VC, Service
3. FireStoreData doesn't have references to VC, Serivce, Firestore
4. VC doesn't call Data, FireStore, it only calls Service
5. Views, VC, FireStoreData - doesn't use Model Classes (FinTransaction, Account, Account.Group) - ???
6. Service and Data use Model classes (in communication between each other)

### Protocols
1. Communication strictly through protocols
2. Protocols are named as {ClassNameProtocol}.
3. Protocols are stored in a separate files in case of complex classes, in the same file in case of simple classes

### Documentation
1. All Classes, functions, properties are documented
2. Class instance properties are documented in class description (above the class declaration)
3. Function description is above function

### Views
Views doesn't have references to VC, except complex VC with implementation of delegate pattern

### Other
1. ALways unowned self in closure
2. All data base actions have completion and log error to special class (to switch between printing during debug and sending info during production)
3. Try to move as much code as possible from VC to VC Service (including for example unwrapping)