import UIKit

// MARK: - functions add subViews to view easily with one command using Visual Format

extension UIView {

    func add(subViews views: [String: UIView?], withConstraints constraints: [String]) {
        guard let views = views as? [String: UIView] else {
            print("error in addSubviewsWithConstraints")
            return
        }
        for (accessibilityIdentifier, view) in views {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.accessibilityIdentifier = accessibilityIdentifier
        }

        for index in 0..<constraints.count {
            self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: constraints[index], options:
                NSLayoutConstraint.FormatOptions(rawValue: 0), metrics: nil, views: views))
        }
    }

    func add(subView view: UIView?, withConstraints constraints: [String]) {
        add(subViews: ["v": view], withConstraints: constraints)
    }

    var views: [String: UIView] {
        var views = [String: UIView]()
        for view in self.subviews {
            guard let id = view.accessibilityIdentifier else {continue}
            views[id] = view
        }
        return views
    }

    var id: String {return ObjectIdentifier(self).debugDescription}
}

// MARK: - Extension allows to initialize Date Formatter with one command

extension DateFormatter {
    convenience init(_ format: String? = nil) {
        self.init()
        self.dateFormat = format
    }
}
extension Date {
    var string: String {return DateFormatter("yyyy MMM-dd").string(from: self)}
    var strFireBasePath: String {return DateFormatter("/yyyy/MM/dd").string(from: self)}
    func str(_ format: String) -> String {return DateFormatter(format).string(from: self)}
}
extension String {
    var date: Date? {return DateFormatter("yyyy MMM-dd").date(from: self)}
    func date(withFormat format: String) -> Date? {return DateFormatter(format).date(from: self)}
}

extension Date {
    var month: Int {return Calendar.current.dateComponents([.month], from: self).month!}
    // swiftlint:disable identifier_name
    var day: Int {return Calendar.current.dateComponents([.day], from: self).day!}
    var year: Int {return Calendar.current.dateComponents([.year], from: self).year!}
//    var day: Int
}

extension String {
    static func randomWithSmallLetters(length: Int = 10) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz" //ABCDEFGHIJKLMNOPQRSTUVWXYZ"//0123456789"
        return String((0...length-1).map { _ in letters.randomElement()! })
    }
}

// MARK: Compare dates

extension Date {
    func isSameDate(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedSame
    }

    func isBefore(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedAscending
    }

    func isAfter(_ comparisonDate: Date) -> Bool {
        let order = Calendar.current.compare(self, to: comparisonDate, toGranularity: .day)
        return order == .orderedDescending
    }
}

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }

    func isWeekEnd() -> Bool {
        let weekDay = Calendar.current.dateComponents([.weekday], from: self).weekday
        return (weekDay == 1 || weekDay == 7) ? true : false
    }
}

// MARK: - Number fomatting

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
