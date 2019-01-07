enum RecurrenceFrequency: Int, CaseIterable {
    case never, everyDay, everyWorkingDay, everyWeek, everyMonth, everyYear
    var name: String {
        switch self {
        case .never: return "Never"
        case .everyDay: return "Every Day"
        case .everyWorkingDay: return "Every Working Day"
        case .everyWeek: return "Every Week"
        case .everyMonth: return "Every Month"
        case .everyYear: return "Every Year"
        }
    }
}
