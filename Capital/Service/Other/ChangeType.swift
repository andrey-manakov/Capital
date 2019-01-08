/// Duplicates FireStore Enum FIRDocumentChangeType,
/// for the use in other parts of the program
/// and not to be dependent on FireStore Library
enum ChangeType: Int {
    /// - added: record was added
    case added
    /// - modified: record was modified
    case modified
    /// - removed: record was removed
    case removed
}

enum ComparisonType: Int {
    case isEqualTo
    case isLessThan
    case isLessThanOrEqualTo
    case isGreaterThan
    case isGreaterThanOrEqualTo
    case arrayContains
}
