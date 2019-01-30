/// View Controller showing enum values
internal final class EnumValuesSelectorVC: ViewController {
    internal var table: SimpleTableProtocol = SimpleTable()
    /// Configures view controller after view is loaded
    override internal func viewDidLoad() {
        super.viewDidLoad()
        view.add(view: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        guard let data = data as? (sourceData: () -> (DataModel), selectionAction: (Any?) -> Void) else {
            return
        }
        table.dataFormula = data.sourceData
        table.didSelect = {[unowned self] row, _ in
            data.selectionAction(row.texts[.id])
            self.dismiss()
        }
    }
}
