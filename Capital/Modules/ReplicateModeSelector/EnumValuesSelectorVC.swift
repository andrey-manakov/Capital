class EnumValuesSelectorVC: ViewController {
    var table: SimpleTableProtocol = SimpleTable()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        guard let dataV = data as? (sourceData: () -> (DataModel), selectionAction: (Any?) -> Void) else {
            return
        }
        table.dataFormula = dataV.sourceData
        table.didSelect = {[unowned self] row, _ in
            dataV.selectionAction(row.id)
            self.dismiss()
        }
    }

}
