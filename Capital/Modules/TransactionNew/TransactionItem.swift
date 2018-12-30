
import UIKit

enum TransactionItem: String, CaseIterable {
    case from, to, amount, date, dateSelection, approvalMode, recurrenceFrequency, recurrenceEnd, recurrenceEndDate
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
