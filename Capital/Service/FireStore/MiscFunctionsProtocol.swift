protocol MiscFunctionsProtocol {

}

extension MiscFunctionsProtocol {
    /// Calculates next transaction date based on previous transaction date and recurrence frequency
    ///
    /// - Parameters:
    ///   - date: date of previous transaction
    ///   - recurrenceFrequency: recurrence frequency enum
    /// - Returns: next transaction date
    func nextDate(from date: Date?, recurrenceFrequency: RecurrenceFrequency?) -> Date? {
        // TODO: consider moving to sendFinTransaction
        guard let rf = recurrenceFrequency, let date = date else {return nil}
        let newDate: Date?
        switch rf {
        case .never: newDate = nil
        case .everyDay:
            newDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: date)
        case .everyWorkingDay:
            newDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: date)
        //FIXME: if transactionDate.isWeekEnd() {continue} remove weekend
        case .everyWeek:
            newDate = Calendar.current.date(byAdding: Calendar.Component.day, value: 1, to: date)
        case .everyMonth:
            newDate = Calendar.current.date(byAdding: Calendar.Component.month, value: 1, to: date)
        case .everyYear:
            newDate = Calendar.current.date(byAdding: Calendar.Component.year, value: 1, to: date)
        }
        return newDate
//         && !(date!.isAfter(recurrenceEnd ?? Date()))
    }
}
