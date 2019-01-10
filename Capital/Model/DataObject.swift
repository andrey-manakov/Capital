internal protocol DataObjectProtocol {
    init(_ data: [String: Any])
}

internal typealias AccountId = String
internal typealias AccountName = String
internal typealias AccountInfo = (id: AccountId, name: AccountName)

internal class DataObject: DataObjectProtocol, Codable {
    internal typealias GroupId = String
    internal typealias GroupName = String
    internal typealias FieldName = String

    internal init() {}
    required internal init(_ data: [String: Any]) {
    }
}
