enum AccountType: Int, CaseIterable {
    case asset, liability, revenue, expense, capital
    static let all = ["asset", "liability", "revenue", "expense", "capital"]
    var name: String { return AccountType.all[self.rawValue] }
    var active: Bool { return self == .asset || self == .expense ? true : false }
}
