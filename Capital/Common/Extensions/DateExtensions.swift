import Foundation

extension Date {
    internal var month: Int? { return Calendar.current.dateComponents([.month], from: self).month }
    internal var monthString: String? { return DateFormatter("LLLL").string(from: self) }
    internal var day: Int? { return Calendar.current.dateComponents([.day], from: self).day }
    internal var localDay: Int? {
        let dateFormatter = DateFormatter("dd")
        dateFormatter.timeZone = TimeZone.current
        return Int(dateFormatter.string(from: self))
    }
    internal var year: Int? { return Calendar.current.dateComponents([.year], from: self).year }
    //    var day: Int
}
// MARK: Compare dates

extension Date {
    internal func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }

    internal func isBefore(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }

    internal func isAfter(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
}

extension Date {
    internal func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    internal func isWeekEnd() -> Bool {
        let weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday
        return (weekDay == 1 || weekDay == 7) ? true : false
    }
}

extension Date {
    internal var string: String { return DateFormatter("yyyy MMM-dd").string(from: self) }
    internal var strFireBasePath: String { return DateFormatter("/yyyy/MM/dd").string(from: self) }

    internal func str(_ format: String) -> String {
        return DateFormatter(format).string(from: self)
    }
}
