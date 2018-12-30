#  App Archticture

## Data Model


## Rules

### Types Of Classses
VC - Childs of UIViewController class, uses UIKit
Service class - Helper for VC, **doesn't** implement UIKit, it uses Model Classes
Views - implement UIKit
Data - doesn't implement UIKit, uses Model Classes
FireStoreData, FireAuth - implemenent FireStore

Note: Implement means usage of the corresponding classes


### Classes Communications
One way connections: Views<- **VC** ->Service->Data->FireStoreData.
- Service doesn't have reference to VC
- Data doesn't have reference to VC, Service
- FireStoreData doesn't have references to VC, Serivce, Firestore
- VC doesn't call Data, FireStore, it only calls Service
- Views, VC, FireStoreData - doesn't use Model Classes (FinTransaction, Account, Account.Group) - ???
- Service and Data use Model classes (in communication between each other)

### Protocols
Communication strictly through protocols
Protocols are named as {ClassNameProtocol}.
Protocols are stored in a separate files in case of complex classes, in the same file in case of simple classes

### Documentation
All Classes, functions, properties are documented
Class instance properties are documented in class description (above the class declaration)
Function description is above function

### Views
Views doesn't have references to VC, except complex VC with implementation of delegate pattern

### Other
ALways unowned self in closure
All data base actions have completion and log error to special class (to switch between printing during debug and sending info during production)
Try to move as much code as possible from VC to VC Service (including for example unwrapping)
