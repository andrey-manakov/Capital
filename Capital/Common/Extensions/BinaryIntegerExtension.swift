import Foundation
/// Extension is needed to format numbers
extension BinaryInteger {
	/// formatted number to show in interface
    internal var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
