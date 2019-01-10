internal enum RecurrenceFrequency: Int, CaseIterable {
    case never, everyDay, everyWorkingDay, everyWeek, everyMonth, everyYear

    internal var name: String {
        let name: String
        switch self {
        case .never:
            name = "Never"
        case .everyDay:
            name = "Every Day"
        case .everyWorkingDay:
            name = "Every Working Day"
        case .everyWeek:
            name = "Every Week"
        case .everyMonth:
            name = "Every Month"
        case .everyYear:
            name = "Every Year"
        }
        return name
    }
}
