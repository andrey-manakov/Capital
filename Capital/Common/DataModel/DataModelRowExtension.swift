extension DataModelRow: Equatable {
    internal static func == (lhs: DataModelRow, rhs: DataModelRow) -> Bool {
        return lhs.id == rhs.id &&
            lhs.name == rhs.name &&
            lhs.desc == rhs.desc &&
            lhs.height == rhs.height &&
            lhs.left == rhs.left &&
            lhs.up == rhs.up &&
            lhs.down == rhs.down &&
            lhs.right == rhs.right &&
            lhs.style == rhs.style &&
            lhs.accessory == rhs.accessory
    }
}
