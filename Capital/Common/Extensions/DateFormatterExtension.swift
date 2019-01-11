import Foundation
// MARK: - Extension allows to initialize Date Formatter with one command
extension DateFormatter {
    internal convenience init(_ format: String? = nil) {
        self.init()
        self.dateFormat = format
    }
}
