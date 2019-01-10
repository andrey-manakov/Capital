internal enum AccountType: Int, CaseIterable {
    case asset, liability, revenue, expense, capital

    internal static let all = ["asset", "liability", "revenue", "expense", "capital"]

    internal var name: String {
        return AccountType.all[self.rawValue]
    }
    internal var active: Bool {
        return self == .asset || self == .expense ? true : false
    }
}
