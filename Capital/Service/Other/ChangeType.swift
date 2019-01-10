/// Duplicates FireStore Enum FIRDocumentChangeType,
/// for the use in other parts of the program
/// and not to be dependent on FireStore Library
///
/// - added: added: record was added
/// - modified: record was modified
/// - removed: record was removed
internal enum ChangeType: Int {
    /// - added: record was added
    case added
    /// - modified: record was modified
    case modified
    /// - removed: record was removed
    case removed
}

/// Duplicates FireStore Enum FIRComparisonType
///
/// - isEqualTo: equal caomparison
/// - isLessThan: less
/// - isLessThanOrEqualTo: less or equal
/// - isGreaterThan: greater
/// - isGreaterThanOrEqualTo: greater or equal
/// - arrayContains: array contains
internal enum ComparisonType: Int {
    case isEqualTo
    case isLessThan
    case isLessThanOrEqualTo
    case isGreaterThan
    case isGreaterThanOrEqualTo
    case arrayContains
}
