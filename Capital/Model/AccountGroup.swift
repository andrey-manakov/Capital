private enum AccountGroupField: String, CaseIterable {
    case accounts
    case name
    case amount
    case minAmount
    case minDate
}

internal struct AccountGroupFields {
    internal let accounts = AccountGroupField.accounts.rawValue
    internal let name = AccountGroupField.name.rawValue
    internal let amount = AccountGroupField.amount.rawValue
    internal let minAmount = AccountGroupField.minAmount.rawValue
    internal let minDate = AccountGroupField.minDate.rawValue
}

// MARK: - Introduction of Account.Group class
internal final class AccountGroup: DataObject, Equatable {
    /// Fields names
    ///
    /// - accounts: accounts field
    /// - name: name field
    /// - amount: amount field
    /// - min: amount and date of minimum value
//    internal enum Fields: String {
//        case accounts
//        case name
//        case amount
//        case minAmount
//        case minDate
//
////        internal enum Min: String {
////            case amount, date
////        }
//    }

    // MARK: - Static properties
    internal static var fields = AccountGroupFields()

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
        case .name:
            self.name = value as? String

        case .amount:
            self.amount = value as? Int

        case .minAmount:
            self.minAmount = value as? Int

        case .minDate:
            self.minDate = (value as? Timestamp)?.dateValue()
//            guard let value = value as? [String: Any],
//                 // CRITICAL!!!
//                let minAmount = value[Account.fields.minAmount] as? Int,
//                // CRITICAL!!!
//                let minDate = (value[Account.fields.minDate] as? Timestamp)?.dateValue() else {
//                    return
//            }
//            self.min = (amount: minAmount, date: minDate)

        case .accounts:
            self.accounts = (value as? [String: String]) ?? [String: String]()
        }
    }
}
