internal enum FinTransactionField: String, CaseIterable {
    case from
    case to
    case amount
    case date
    case serverTime
    case isApproved
    case approvalMode
    case recurrenceFrequency
    case recurrenceEnd
    case parent

    case accountId = "id"
    case accountName = "name"

//    enum From: String {
//        case id
//        case name
//    }
//    enum To: String {
//        case id
//        case name
//    }
    // TODO: check if these fields are needed
    //    case accountId = "id"
    //    case accountName = "name"
}

internal struct FinTransactionFields {
    internal let from = FinTransactionField.from.rawValue
    internal let to = FinTransactionField.to.rawValue
    internal let amount = FinTransactionField.amount.rawValue
    internal let date = FinTransactionField.date.rawValue
    internal let serverTime = FinTransactionField.serverTime.rawValue
    internal let isApproved = FinTransactionField.isApproved.rawValue
    internal let approvalMode = FinTransactionField.approvalMode.rawValue
    internal let recurrenceFrequency = FinTransactionField.recurrenceFrequency.rawValue
    internal let recurrenceEnd = FinTransactionField.recurrenceEnd.rawValue
    internal let parent = FinTransactionField.parent.rawValue
    internal let accountId = FinTransactionField.accountId.rawValue
    internal let accountName = FinTransactionField.accountName.rawValue
}
// MARK: Definition of Fields enum - names of the FinTransaction class properties EXCEPT calculated fields
extension FinTransaction {
    internal enum Fields: String, CaseIterable {
        case from
        case to
        case amount
        case date
        case serverTime
        case isApproved
        case approvalMode
        case recurrenceFrequency
        case recurrenceEnd
        case parent
        internal enum From: String { case id, name }
        internal enum To: String { case id, name }
    }
}

/// Transaction is operation of moving of funds from one Account to another
internal final class FinTransaction: DataObject {
    // MARK: - Static Properties
    internal static let fields = FinTransactionFields()

    /// MARK: - Properties
    /// account **from** which is the transfer of funds - reference to `Account` instance
    internal var from: AccountInfo?
    /// to - account **to** which is the transfer of funds
    internal var to: AccountInfo?
    /// amount - amount of funds transferred
    internal var amount: Int?
    /// date - when transaction is supposed to take place
    internal var date: Date?
    /// serverTime - when transaction reecord is created in Online database
    internal var serverTime: Date?
    /// dateText  - date in text format, date converted to text in format yyyy MMM-dd
    internal var dateText: String {
        guard let date = date else {
            return "" // TODO: consider making dateText - Optional
        }
        return DateFormatter("yyyy MMM-dd").string(from: date as Date)
    }
    /// isApproved - defines if transaction is approved,
    /// if it is actually took place and should it be taken into account value calculation
    internal var isApproved = false
    // TODO: Refactor to RawValue
    /// approvalMode - defines what happens when transaction date comes
    internal var approvalMode: ApprovalMode?
    // TODO: Refactor to RawValue
    /// recurrenceFrequency - defines whether transaction should repeat, nil means no repeating
    internal var recurrenceFrequency: RecurrenceFrequency?
    /// recurrenceEnd - date when repeating of the transaction should end
    internal var recurrenceEnd: Date?
    /// parent is refernce to `FinTransaction` used for recurrence, which produced this transaction,
    /// through the parent transactions is it possible to get all the related transactions
    internal var parent: String?

    internal lazy var update: [FinTransactionField: (Any) -> Void] = [
        .from: {
            guard let value = $0 as? [String: Any],
                let id = value[FinTransaction.fields.accountId] as? String,
                let name = value[FinTransaction.fields.accountName] as? String else { return }
            self.from = (id, name)
        },
        .to: {
            guard let value = $0 as? [String: Any],
                let id = value[FinTransaction.fields.accountId] as? String,
                let name = value[FinTransaction.fields.accountName] as? String else { return }
            self.from = (id, name)
        },
        .amount: { self.amount = $0 as? Int },
        .date: { self.date = ($0 as? Timestamp)?.dateValue() },
        .serverTime: { self.serverTime = ($0 as? Timestamp)?.dateValue() },
        .isApproved: { self.isApproved = ($0 as? Bool) ?? false },
        .approvalMode: { self.approvalMode = ApprovalMode(rawValue: $0 as? Int ?? 0) },
        .recurrenceFrequency: { self.recurrenceFrequency = RecurrenceFrequency(rawValue: $0 as? Int ?? 0) },
        .recurrenceEnd: { self.recurrenceEnd = ($0 as? Timestamp)?.dateValue() },
        .parent: { self.parent = $0 as? String }
    ]

    /// MARK: - Initialization
    internal required convenience init(_ data: [String: Any]) {
        self.init()
        for (field, value) in data { self.update(field: field, value: value) }
    }

    /// Initilizes simple transaction without recurrence
    ///
    /// - Parameters:
    ///   - from: reference to `Account` from which funds are transferred
    ///   - to: reference to `Account` to which funds are transferred
    ///   - amount: amount of funds to be transferred
    ///   - date: date when transaction took place
    internal convenience init(from: AccountInfo, to: AccountInfo, amount: Int, date: Date) {
        self.init()
        self.from = from
        self.to = to
        self.amount = amount
        self.date = date
    }

    /// MARK: - Methods
    /// Updates field value of Transaction with value provided
    ///
    /// - Parameters:
    ///   - field: field name
    ///   - value: value to use for field update
    internal func update(field: String, value: Any) {
        if let field = FinTransactionField(rawValue: field) {
            update[field]?(value)
        } else {
            fatalError("Unknown field name")
        }

//        switch field {
//        case .from:
//            guard let value = value as? [String: Any],
//                let id = value[Fields.From.id.rawValue] as? String,
//                let name = value[Fields.From.name.rawValue] as? String else { return }
//            self.from = (id, name)
//
//        case .to:
//            guard let value = value as? [String: Any],
//                let id = value[Fields.To.id.rawValue] as? String,
//                let name = value[Fields.To.name.rawValue] as? String else { return }
//            self.to = (id, name)
//
//        case .amount:
//            self.amount = value as? Int
//
//        case .date:
//            self.date = (value as? Timestamp)?.dateValue()
//
//        case .serverTime:
//            self.serverTime = (value as? Timestamp)?.dateValue()
//
//        case .isApproved:
//            self.isApproved = (value as? Bool) ?? false
//
//        case .approvalMode:
//            if let rawValue = value as? Int { self.approvalMode = ApprovalMode(rawValue: rawValue) }
//
//        case .recurrenceFrequency:
//            if let rawValue = value as? Int {
//                self.recurrenceFrequency = RecurrenceFrequency(rawValue: rawValue)
//            }
//
//        case .recurrenceEnd:
//            self.recurrenceEnd = (value as? Timestamp)?.dateValue()
//
//        case .parent:
//            self.parent = value as? String
//        }
    }
}

// MARK: - Introduction of ApprovalMode enum
extension FinTransaction {
    /// Enum defines the approach for transactionы scheduled on FUTURE date:
    /// what to do when the transaction date comes.
    internal enum ApprovalMode: Int, CaseIterable {
        /// autoApprove: transaction is approved automatically
        case autoApprove
        /// autoPostpone: transaction is moved forward in time with unapproved status
        case autoPostpone
        /// autoCancel: transaction is cancelled (unless it is approved manually)
        case autoCancel
        /// manual: transaction just left unapproved without any auto action
        case manual

        /// String name of the enum member
        internal var name: String {
            let name: String
            switch self {
            case .autoApprove:
                name = "Auto Approve"
            case .autoPostpone:
                name = "Auto Postpone"
            case .autoCancel:
                name = "Auto Cancel"
            case .manual:
                name = "Manual"
            }
            return name
        }
    }
}

// MARK: Adds conformance to CustomStringConvertible, CustomDebugStringConvertible
extension FinTransaction: CustomStringConvertible, CustomDebugStringConvertible {
    internal var description: String {
        return """
        from: \(from?.name ?? "") to: \(to?.name ?? "")
        amount: \(amount ?? 0) date: \(date?.string ?? "")
        """
    }

    internal var debugDescription: String { return description }
}

extension FinTransaction: Equatable {
    internal static func == (lhs: FinTransaction, rhs: FinTransaction) -> Bool {
        let currentDate = Date()

        return lhs.amount == rhs.amount && lhs.approvalMode == rhs.approvalMode &&
            (lhs.date ?? currentDate).isSameDate(rhs.date ?? currentDate) &&
            lhs.from ?? ("", "") == rhs.from ?? ("", "") && lhs.to ?? ("", "") == rhs.to ?? ("", "") &&
            lhs.isApproved == rhs.isApproved && lhs.parent == rhs.parent &&
            lhs.recurrenceEnd == rhs.recurrenceEnd && lhs.recurrenceFrequency == rhs.recurrenceFrequency
    }
}
