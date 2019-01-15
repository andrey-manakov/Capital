internal protocol DataObjectProtocol {
    init(_ data: [String: Any])
}

internal typealias AccountId = String
internal typealias AccountName = String
internal typealias AccountInfo = (id: AccountId, name: AccountName)

// internal typealias TransactionId = String
// internal typealias TransactionInfo = (id: TransactionId, name: AccountName)

internal class DataObject: DataObjectProtocol, Codable {
    internal typealias GroupId = String
    internal typealias GroupName = String
    internal typealias FieldName = String

    internal init() {}
    internal required init(_ data: [String: Any]) {
    }

//    func valueFor(property:String, of object:Any) -> Any? {
//        let mirror = Mirror(reflecting: object)
//        return mirror.descendant(property)
//    }
//
//    func getTypeOfProperty (_ name: String) -> String? {
//
//        var type: Mirror = Mirror(reflecting: self)
//
//        for child in type.children {
//            if child.label! == name {
//                return "\(type(of: child.value))"
//            }
//        }
//        while let parent = type.superclassMirror {
//            for child in parent.children {
//                if child.label! == name {
//                    return String(describing: type(of: child.value))
//                }
//            }
//            type = parent
//        }
//        return nil
//    }
}
