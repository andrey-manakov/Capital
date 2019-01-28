internal final class RecurrenceFrequencySelectorVC: ViewController {
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        let table: SimpleTableProtocol = SimpleTable()
        table.dataFormula = {
            DataModel(RecurrenceFrequency.allCases.map {
                DataModelRow(texts: [.id: "\($0.rawValue)", .name: $0.name])
            })
        }
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        let selectionAction = data as? ((Any?) -> Void)
        table.didSelect = {[unowned self] row, _ in
            selectionAction?(row.texts[.id])
            self.dismiss()
        }
    }
}
