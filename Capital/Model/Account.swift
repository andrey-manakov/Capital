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

/// Account - is the entity to record transactions (`FinTransaction`).
final class Account: DataObject {

    // MARK - Properties

    /// Account name
    var name: AccountName?
    /// Account current balance
    var amount: Int?
    /// Account available amount, which takes into account future withdrawals
    var minAmount: Int?
    /// Date when Account reaches its min value (`Account.minAmount`)
    var minDate: Date?
    /// Computed tuple holding `Account.minAmount` and `Account.minDate`
    /// In that way the data regarding `Account.minAmount` and `Account.minDate` is stored in Firestore.
    var min: (amount: Int, date: Date)? {
        guard let minAmount = minAmount, let minDate = minDate else {return nil}
        return (minAmount, minDate)
    }
    /// RawValue of Enum `AccountType`
    /// In that way data is stored in FireStore
    var typeId: Int?
    /// Computed value of Enum `AccountType` based on rawValue
    var type: AccountType? {
        guard let typeId = typeId, let accountType = AccountType(rawValue: typeId) else {return nil}
        return accountType
    }
    /// Groups to which 'Account' belongs to
    var groups: [GroupId: GroupName]?

    // MARK - Initializers

    /// Initializer used to create instance of `Account` from data loaded from FireStore
    ///
    /// - Parameter data: data as it is stored in FireStore
    required convenience init(_ data: [String: Any]) {
        self.init()
        for (key, value) in data {update(field: key, value: value)
        }
    }

    // MARK - Methods

    /// Updates instance field with new value
    ///
    /// - Parameters:
    ///   - field: field name
    ///   - value: value of the field
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

// MARK: - Extends 'Account' to Equatable protocol
extension Account: Equatable {
    /// JSON representation of 'Account' instance
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

    /// Implementation of '==' to comply with Equatable protocol
    ///
    /// - Parameters:
    ///   - lhs: first instance
    ///   - rhs: second instance
    /// - Returns: true if first and second instances are equal
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

/// MARK: - Extends  'Account' to CustomStringConvertible, CustomDebugStringConvertible protocols
extension Account: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {return json}
    var debugDescription: String {return description}
}
