extension String {
    internal var date: Date? { return DateFormatter("yyyy MMM-dd").date(from: self) }

    internal func date(withFormat format: String) -> Date? {
        return DateFormatter(format).date(from: self)
    }
}

extension String {

     internal static func randomWithSmallLetters(length: Int = 10) -> String {
        let letters = "abcdefghijklmnopqrstuvwxyz"
        return String((0...length - 1).map { _ in letters.randomElement() ?? Character("x") })
    }
}
