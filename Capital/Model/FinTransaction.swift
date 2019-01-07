/// Transaction is operation of moving of funds from one Account to another
final class FinTransaction: DataObject {
    /// account **from** which is the transfer of funds - reference to `Account` instance
    var from: AccountInfo?
    /// to - account **to** which is the transfer of funds
    var to: AccountInfo?
    /// amount - amount of funds transferred
    var amount: Int?
    /// date - when transaction is supposed to take place
    var date: Date?
    /// serverTime - when transaction reecord is created in Online database
    var serverTime: Date?
    /// dateText  - date in text format, date converted to text in format yyyy MMM-dd
    var dateText: String {return date == nil ? "" :  DateFormatter("yyyy MMM-dd").string(from: date! as Date)}
    /// isApproved - defines if transaction is approved it is actually took place and should it be taken into account value calculation
    var isApproved: Bool?
    /// approvalMode - defines what happens when transaction date comes
    var approvalMode: ApprovalMode?
    /// recurrenceFrequency - defines whether transaction should repeat, nil means no repeating
    var recurrenceFrequency: RecurrenceFrequency?
    /// recurrenceEnd - date when repeating of the transaction should end
    var recurrenceEnd: Date?
    /// parent is Transaction used for recuerrence, which produced this transaction, through the parent transactions is it possible to get all the related transactions
    var parent: String?

    required convenience init(_ data: [String: Any]) {
        self.init()
        for (field, value) in data {self.update(field: field, value: value)}
    }

    convenience init(from: AccountInfo, to: AccountInfo, amount: Int, date: Date) {
        self.init()
        self.from = from
        self.to = to
        self.amount = amount
        self.date = date
    }

    //swiftlint:disable cyclomatic_complexity
    /// Updates field value of Transaction with value provided
    ///
    /// - Parameters:
    ///   - field: field name
    ///   - value: value to use for field update
    func update(field: String, value: Any) {
        guard let field = Fields.init(rawValue: field) else {return}

        switch field {
        case .from:
            guard let value = value as? [String: Any],
                let id = value[Fields.From.id.rawValue] as? String,
                let name = value[Fields.From.name.rawValue] as? String else {return}
            self.from = (id, name)
        case .to:
            guard let value = value as? [String: Any],
                let id = value[Fields.To.id.rawValue] as? String,
                let name = value[Fields.To.name.rawValue] as? String else {return}
            self.to = (id, name)
        case .amount: self.amount = value as? Int
        case .date: self.date = (value as? Timestamp)?.dateValue()
        case .serverTime: self.serverTime = (value as? Timestamp)?.dateValue()
        case .isApproved: self.isApproved = value as? Bool
        case .approvalMode: if let rv = value as? Int {self.approvalMode = ApprovalMode(rawValue: rv)}
        case .recurrenceFrequency: if let rv = value as? Int {self.recurrenceFrequency = RecurrenceFrequency(rawValue: rv)}
        case .recurrenceEnd: self.recurrenceEnd = (value as? Timestamp)?.dateValue()
        case .parent: self.parent = value as? String
        }
    }
}

// MARK: - Introduction of ApprovalMode enum
extension FinTransaction {

    /// Enum defines the approach for transactionы scheduled on FUTURE date. What to do when the transaction date comes.
    ///
    /// - autoApprove: transaction is approved automatically
    /// - autoPostpone: transaction is moved forward in time with unapproved status
    /// - autoCancel: transaction is cancelled (unless it is approved manually)
    /// - manual: transaction just left unapproved without any auto action
    enum ApprovalMode: Int, CaseIterable {
        case autoApprove, autoPostpone, autoCancel, manual
        var name: String {
            switch self {
            case .autoApprove: return "Auto Approve"
            case .autoPostpone: return  "Auto Postpone"
            case .autoCancel: return "Auto Cancel"
            case .manual: return "Manual"
            }
        }
    }
}

// MARK: - Adds conformance to CustomStringConvertible, CustomDebugStringConvertible
extension FinTransaction: CustomStringConvertible, CustomDebugStringConvertible {
    var description: String {
        return "from: \(from?.name ?? "") to: \(to?.name ?? "") amount: \(amount ?? 0) date: \(date?.string ?? "")"
    }

    var debugDescription: String {return description}

}

// MARK: - Definition of Fields enum - names of the FinTransaction class properties EXCEPT calculated fields
extension FinTransaction {
    enum Fields: String, CaseIterable {
        case from, to, amount, date, serverTime, isApproved, approvalMode, recurrenceFrequency, recurrenceEnd, parent
        enum From: String {case id, name}
        enum To: String {case id, name}
    }

}

extension FinTransaction: Equatable {
    static func == (lhs: FinTransaction, rhs: FinTransaction) -> Bool {
        let currentDate = Date()

        return lhs.amount == rhs.amount && lhs.approvalMode == rhs.approvalMode && (lhs.date ?? currentDate).isSameDate(rhs.date ?? currentDate) && lhs.from ?? ("", "") == rhs.from ?? ("", "") && lhs.to ?? ("", "") == rhs.to ?? ("", "") && lhs.isApproved == rhs.isApproved && lhs.parent == rhs.parent && lhs.recurrenceEnd == rhs.recurrenceEnd && lhs.recurrenceFrequency == rhs.recurrenceFrequency
    }
}
