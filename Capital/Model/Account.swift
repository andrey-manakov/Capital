/// Stores name constants for the `AccountFields` struct
///
/// - name: `Account.name` field name constant
/// - amount: `Account.amount` field name constant
/// - minAmount: `Account.minAmount` field name constant
/// - minDate: `Account.minDate` field name constant
/// - typeId: `Account.typeId` field name constant
/// - groups: `Account.groups` field name constant
internal enum AccountField: String, CaseIterable {
    case name
    case amount
    // TODO: Consider merge to one struct
    case minAmount
    case minDate
//    case minDynamics
    case typeId
    case groups
}

internal struct AccountFields {
    internal let name = AccountField.name.rawValue
    internal let amount = AccountField.amount.rawValue
    internal let minAmount = AccountField.minAmount.rawValue
    internal let minDate = AccountField.minDate.rawValue
//    internal let minDynamics = AccountField.minDynamics.rawValue
    internal let typeId = AccountField.typeId.rawValue
    internal let groups = AccountField.groups.rawValue
}

/// Account - is the entity to record transactions (`FinTransaction`).
internal final class Account: DataObject {
    // TODO: consider unowned self, check if instance is correctly deinitialized
    // TODO: create test which check that all the fields are processed
    internal lazy var update: [AccountField: (Any) -> Void] = [
        .name: { self.name = $0 as? String },
        .amount: { self.amount = $0 as? Int },
        .minDate: { self.minDate = ($0 as? Timestamp)?.dateValue() },
        .minAmount: { self.minAmount = $0 as? Int },
//        .minDynamics: { self.minDynamics = $0 as? [Date: Int]}
        .typeId: { self.typeId = $0 as? Int },
        .groups: { self.groups = ($0 as? [String: String]) ?? [String: String]() }]

    // MARK: - Static Properties
    internal static let fields = AccountFields()

    // MARK: - Properties
    /// Account name
    internal var name: AccountName?
    /// Account current balance
    internal var amount: Int?
    /// Account available amount, which takes into account future withdrawals
    internal var minAmount: Int?
    /// Date when Account reaches its min value (`Account.minAmount`)
    internal var minDate: Date?
// TODO: Consider move to separate object
    /// Non approved transaction values used to calculate `Account.minAmount` and `Account.minDate`
//    internal var minDynamics = [Date: Int]()

    /// Computed tuple holding `Account.minAmount` and `Account.minDate`
    /// In that way the data regarding `Account.minAmount` and `Account.minDate` is stored in Firestore.
    internal var min: (amount: Int, date: Date)? {
        guard let minAmount = minAmount, let minDate = minDate else {
            return nil
        }
        return (minAmount, minDate)
    }
    /// RawValue of Enum `AccountType`
    /// In that way data is stored in FireStore
    internal var typeId: Int?
    /// Computed value of Enum `AccountType` based on rawValue
    internal var type: AccountType? {
        guard let typeId = typeId, let accountType = AccountType(rawValue: typeId) else {
            return nil
        }
        return accountType
    }
    /// Groups to which 'Account' belongs to
    internal var groups = [GroupId: GroupName]()

    // MARK: - Initializers

    /// Initializer used to create instance of `Account` from data loaded from FireStore
    ///
    /// - Parameter data: data as it is stored in FireStore
    internal required convenience init(_ data: [String: Any]) {
        self.init()
        for (key, value) in data {update(field: key, value: value)
        }
    }

    // MARK: - Methods

    /// Updates instance field with new value
    ///
    /// - Parameters:
    ///   - field: field name
    ///   - value: value of the field
    internal func update(field: String, value: Any) {
        if let field = AccountField(rawValue: field) {
            update[field]?(value)
        } else {
            fatalError("Unknown field name")
        }
    }
}

// MARK: - Extends 'Account' to Equatable protocol
extension Account: Equatable {
    /// JSON representation of 'Account' instance
    internal var json: String {
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
    internal static func == (lhs: Account, rhs: Account) -> Bool {
        let currentDate = Date()
        return lhs.amount == rhs.amount &&
            lhs.groups == rhs.groups &&
            lhs.minAmount == rhs.minAmount &&
            (lhs.minDate ?? currentDate).isSameDate(rhs.minDate ?? currentDate) &&
            lhs.name == rhs.name &&
            lhs.type == rhs.type
    }
}

// MARK: - Extends  'Account' to CustomStringConvertible, CustomDebugStringConvertible protocols
extension Account: CustomStringConvertible, CustomDebugStringConvertible {
    internal var description: String { return json }
    internal var debugDescription: String { return description }
}
