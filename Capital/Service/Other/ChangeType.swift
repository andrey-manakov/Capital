/// Duplicates FireStore Enum FIRDocumentChangeType for the use in other parts of the program and not to be dependent on FireStore Library
///
/// - added: record was added
/// - modified: record was modified
/// - removed: record was removed
enum ChangeType: Int {
    case added, modified, removed
}

enum ComparisonType: Int {
    case isEqualTo, isLessThan, isLessThanOrEqualTo, isGreaterThan, isGreaterThanOrEqualTo, arrayContains
}
