/// Stores name constants for the `AccountGroupFields` struct
///
/// - accounts: `AccountGroup.accounts` field name constant
/// - name: `AccountGroup.name` field name constant
/// - amount: `AccountGroup.amount` field name constant
/// - minAmount: `AccountGroup.minAmount` field name constant
/// - minDate: `AccountGroup.minDate` field name constant
internal enum AccountGroupField: String, CaseIterable {
    /// `AccountGroup.accounts` field name constant
    case accounts
    /// `AccountGroup.name` field name constant
    case name
    /// `AccountGroup.amount` field name constant
    case amount
    /// `AccountGroup.minAmount` field name constant
    case minAmount
    /// `AccountGroup.minDate` field name constant
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

/// Group of `Account`s with aggregate characteristics
internal final class AccountGroup: DataObjectProtocol, Codable {
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

    internal required convenience init(_ data: [String: Any]) {
        self.init()
        for (field, value) in data {
            update(field: field, value: value)
        }
    }

    internal func update(field: String, value: Any) {
        guard let property = AccountGroupField(rawValue: field) else {
            return
        }
        switch property {
        case .accounts:
            self.accounts = (value as? [String: String]) ?? [String: String]()

        case .name:
            self.name = value as? String

        case .amount:
            self.amount = value as? Int

        case .minAmount:
            self.minAmount = value as? Int

        case .minDate:
            self.minDate = (value as? Timestamp)?.dateValue()
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
