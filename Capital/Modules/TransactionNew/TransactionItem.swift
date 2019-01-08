import UIKit

enum TransactionItem: String, CaseIterable {
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

    var name: String {
        switch self {
        case .from: return "from"
        case .to: return "to"
        case .amount: return "amount"
        case .date: return "date"
        case .dateSelection: return ""
        case .approvalMode: return "approval mode"
        case .recurrenceFrequency: return "repeat"
        case .recurrenceEnd: return "end repeat"
        case .recurrenceEndDate: return ""
        }
    }

    var height: CGFloat {
        switch self {
        case .dateSelection, .recurrenceEndDate: return 200
        default: return 45
        }
    }

}
