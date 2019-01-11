internal enum TransactionItem: String, CaseIterable {
    case from
    // swiftlint:disable identifier_name
    case to
    case amount
    case date
    case dateSelection
    case approvalMode
    case recurrenceFrequency
    case recurrenceEnd
    case recurrenceEndDate

    internal var name: String {
        let name: String
        switch self {
        case .from:
            name = "from"
        case .to:
            name = "to"
        case .amount:
            name = "amount"
        case .date:
            name = "date"
        case .dateSelection:
            name = ""
        case .approvalMode:
            name = "approval mode"
        case .recurrenceFrequency:
            name = "repeat"
        case .recurrenceEnd:
            name = "end repeat"
        case .recurrenceEndDate:
            name = ""
        }
        return name
    }

    internal var height: CGFloat {
        switch self {
        case .dateSelection, .recurrenceEndDate:
            return 200

        default:
            return 45
        }
    }
}
