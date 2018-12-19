

class EnumValuesSelectorVC: ViewController {
    var table: SimpleTableProtocol = SimpleTable()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        let dataV = data as! (sourceData: ()->(DataModel), selectionAction: (String?)->())
        table.dataFormula = dataV.sourceData
        table.didSelect = {[unowned self] row, ix in
            dataV.selectionAction(row.id)
            self.dismiss()
        }
    }
}
