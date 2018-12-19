protocol DataObjectProtocol {
    init(_ data: [String: Any])
}

typealias AccountId = String
typealias AccountName = String
typealias AccountInfo = (id: AccountId, name: AccountName)

class DataObject: DataObjectProtocol, Codable {
    typealias GroupId = String
    typealias GroupName = String
    typealias FieldName = String
    
    init() {}
    required init(_ data: [String : Any]) {
    }
}
