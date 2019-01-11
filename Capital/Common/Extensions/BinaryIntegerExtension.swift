extension BinaryInteger {
    internal var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}
