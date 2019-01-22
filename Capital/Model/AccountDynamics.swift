internal struct AccountDynamics: DataObjectProtocol {
    internal var data = [String: Int]()

    internal init(_ data: [String: Any]) {
        guard let data = data as? [String: Int] else {
            return
        }
        self.data = data
    }

    internal init() {
    }
}
