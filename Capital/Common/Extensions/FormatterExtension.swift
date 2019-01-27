import Foundation
/// Number fomatting
extension Formatter {
	/// Formatted number with " " 000 separator
    internal static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}
