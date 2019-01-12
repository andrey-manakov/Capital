/// Transaction is operation of moving of funds from one Account to another
internal final class FinTransaction: DataObject {
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
    internal var isApproved: Bool?
    /// approvalMode - defines what happens when transaction date comes
    internal var approvalMode: ApprovalMode?
    /// recurrenceFrequency - defines whether transaction should repeat, nil means no repeating
    internal var recurrenceFrequency: RecurrenceFrequency?
    /// recurrenceEnd - date when repeating of the transaction should end
    internal var recurrenceEnd: Date?
    /// parent is Transaction used for recurrence, which produced this transaction,
    /// through the parent transactions is it possible to get all the related transactions
    internal var parent: String?

    /// MARK: - Initialization
    internal required convenience init(_ data: [String: Any]) {
        self.init()
        for (field, value) in data { self.update(field: field, value: value) }
    }

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
        guard let field = Fields(rawValue: field) else {
            return
        }

        switch field {
        case .from:
            guard let value = value as? [String: Any],
                let id = value[Fields.From.id.rawValue] as? String,
                let name = value[Fields.From.name.rawValue] as? String else { return }
            self.from = (id, name)

        case .to:
            guard let value = value as? [String: Any],
                let id = value[Fields.To.id.rawValue] as? String,
                let name = value[Fields.To.name.rawValue] as? String else { return }
            self.to = (id, name)

        case .amount:
            self.amount = value as? Int

        case .date:
            self.date = (value as? Timestamp)?.dateValue()

        case .serverTime:
            self.serverTime = (value as? Timestamp)?.dateValue()

        case .isApproved:
            self.isApproved = value as? Bool

        case .approvalMode:
            if let rawValue = value as? Int { self.approvalMode = ApprovalMode(rawValue: rawValue) }

        case .recurrenceFrequency:
            if let rawValue = value as? Int {
                self.recurrenceFrequency = RecurrenceFrequency(rawValue: rawValue)
            }

        case .recurrenceEnd:
            self.recurrenceEnd = (value as? Timestamp)?.dateValue()

        case .parent:
            self.parent = value as? String
        }
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
