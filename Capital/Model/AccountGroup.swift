/// Stores name constants for the `AccountGroupFields` struct
///
/// - accounts: `AccountGroup.accounts` field name constant
/// - name: `AccountGroup.name` field name constant
/// - amount: `AccountGroup.amount` field name constant
/// - minAmount: `AccountGroup.minAmount` field name constant
/// - minDate: `AccountGroup.minDate` field name constant
internal enum AccountGroupField: String, CaseIterable {
    case accounts
    case name
    case amount
    case minAmount
    case minDate
}

/// Defines name constant for `AccountGroup` class
internal struct AccountGroupFields {
    internal let accounts = AccountGroupField.accounts.rawValue
    internal let name = AccountGroupField.name.rawValue
    internal let amount = AccountGroupField.amount.rawValue
    internal let minAmount = AccountGroupField.minAmount.rawValue
    internal let minDate = AccountGroupField.minDate.rawValue
}

// MARK: - Introduction of Account.Group class
internal final class AccountGroup: DataObject {
    // MARK: - Static properties
    internal static var fields = AccountGroupFields()

    // MARK: - Instance properties
    internal var name: String?
    internal var amount: Int?
    internal var minAmount: Int?
    internal var minDate: Date?
    internal var min: (amount: Int, date: Date)? {
        guard let minAmount = minAmount, let minDate = minDate else {
            return nil
        }
        return (minAmount, minDate)
    }
    internal var accounts = [AccountId: AccountName]()

    // TODO: consider unowned self, check if instance is correctly deinitialized
    // TODO: create test which check that all the fields are processed
    internal lazy var update: [AccountGroupField: (Any) -> Void] = [
        .name: { self.name = $0 as? String },
        .amount: { self.amount = $0 as? Int },
        .minDate: { self.minDate = ($0 as? Timestamp)?.dateValue() },
        .minAmount: { self.minAmount = $0 as? Int },
        .accounts: { self.accounts = ($0 as? [String: String]) ?? [String: String]() }]

    internal required convenience init(_ data: [String: Any]) {
        self.init()
        for (field, value) in data {
            update(field: field, value: value)
        }
    }

    internal func update(field: String, value: Any) {
        if let field = AccountGroupField(rawValue: field) {
            update[field]?(value)
        } else {
            fatalError("Unknown field name")
        }
    }
}

extension AccountGroup: Equatable {
    internal static func == (lhs: AccountGroup, rhs: AccountGroup) -> Bool {
        let currentDate = Date()
        let lhsmin = lhs.min ?? (amount: 0, date: currentDate)
        let rhsmin = rhs.min ?? (amount: 0, date: currentDate)
        return lhs.amount == rhs.amount &&
            lhs.accounts == rhs.accounts &&
            lhsmin.amount == rhsmin.amount &&
            rhsmin.date.isSameDate(lhsmin.date) &&
            lhs.name == rhs.name
    }
}
