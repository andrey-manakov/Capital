class EnumValuesSelectorVC: ViewController {
    var table: SimpleTableProtocol = SimpleTable()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        guard let data = data as? (sourceData: () -> (DataModel), selectionAction: (String?) -> Void) else {
            return
        }
        table.dataFormula = data.sourceData
        table.didSelect = {[unowned self] row, ix in
            data.selectionAction(row.id)
            self.dismiss()
        }
    }
}
