// MARK: - Fields enum - to name all the fields of Account class
extension Account {
    enum Fields: String {
        case name, amount, min, type, groups
        // swiftlint:disable nesting
        enum Min: String {
            case amount
            case date
        }
    }
}
final class Account: DataObject {
    var name: AccountName?
    var amount: Int?
    var minAmount: Int?
    var minDate: Date?
    var min: (amount: Int, date: Date)? {
        guard let minAmount = minAmount, let minDate = minDate else {return nil}
        return (minAmount, minDate)
    }
    var typeId: Int?
    var type: AccountType? {
        guard let typeId = typeId, let accountType = AccountType(rawValue: typeId) else {return nil}
        return accountType
    }
    var groups: [GroupId: GroupName]?

    required convenience init(_ data: [String: Any]) {
        self.init()
        for (key, value) in data {update(field: key, value: value)
        }
    }

    func update(field: String, value: Any) {
        guard let property = Account.Fields(rawValue: field) else {return}
        switch property {
        case .name: self.name = value as? String
        case .amount: self.amount = value as? Int
        case .min:
            guard let value = value as? [String: Any] else {return}
            if let minAmount = value[Account.Fields.Min.amount.rawValue] as? Int {
                self.minAmount = minAmount
            }
            if let minDate = (value[Account.Fields.Min.date.rawValue] as? Timestamp)?.dateValue() {
                self.minDate = minDate
            }
        case .type: self.typeId = value as? Int
        case .groups: self.groups =  value as? [String: String]
        }
    }
}

extension Account: Equatable {
    var json: String {
        let jsonEncoder = JSONEncoder()
        let json: String
        do {
            let jsonData = try jsonEncoder.encode(self)
            json = String(data: jsonData, encoding: String.Encoding.utf8) ?? ""
        } catch {
            json = ""
        }
        return json
    }

    static func == (lhs: Account, rhs: Account) -> Bool {
        let currentDate = Date()
        return lhs.amount == rhs.amount &&
            lhs.groups == rhs.groups &&
            lhs.minAmount == rhs.minAmount &&
            (lhs.minDate ?? currentDate).isSameDate(rhs.minDate ?? currentDate) &&
            lhs.name == rhs.name &&
            lhs.type == rhs.type
    }
}

// MARK: - Adds conformance to CustomStringConvertible, CustomDebugStringConvertible
extension Account: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {return json}
    var debugDescription: String {return description}
}
