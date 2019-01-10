protocol AdvancedNewTransactionVCProtocol: ViewControllerProtocol {
    var service: AdvancedNewTransactionServiceProtocol { get set }
    var tableData: DataModel { get set }
    func reloadData(for indexPath: IndexPath?)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func setAmountFieldFirstResponder()
}

protocol AdvancedNewTransactionTableProtocol: class { // TODO: compare with TemplateTableProtocol
    func reloadRows(at indexPath: [IndexPath], with: UITableView.RowAnimation)
    func reloadData()
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

class AdvancedNewTransactionVC: ViewController, AdvancedNewTransactionVCProtocol {

    var service: AdvancedNewTransactionServiceProtocol = AdvancedNewTransactionService()
    private lazy var table: AdvancedNewTransactionTableProtocol = AdvancedNewTransactionTable(self)
    var tableData = DataModel()
    var amountTextField: TextFieldProtocol?
    var date: Date?

    override func viewDidLoad() {
        super.viewDidLoad()

        service.viewDidLoad(self)
        title = "New Transaction"
        view.add(subView: table as? UIView, withConstraints: ["H:|[v]|", "V:|[v]|"])
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonItem.SystemItem.done,
            target: self, action: #selector(didTapDone))
    }

    @objc func didTapCancel() {
        dismissNavigationViewController()
    }

    @objc func didTapDone() {
        service.didTapDone()
    }

    func setAmountFieldFirstResponder() {
        _ = amountTextField?.becomeFirstResponder()
    }

}

extension AdvancedNewTransactionVC {

    class AdvancedNewTransactionTable: UITableView, AdvancedNewTransactionTableProtocol {
        init(_ viewController: AdvancedNewTransactionVC) {
            super.init(frame: CGRect.zero, style: UITableView.Style.plain)
            register(LeftRightCell.self, forCellReuseIdentifier: LeftRightCell.self.description())
            register(InputAmountCell.self, forCellReuseIdentifier: InputAmountCell.self.description())
            register(DateSelectionCell.self, forCellReuseIdentifier: DateSelectionCell.self.description())
            self.delegate = viewController
            self.dataSource = viewController
        }

        required init?(coder aDecoder: NSCoder) {
            return nil
        }
    }
}

extension AdvancedNewTransactionVC: UITableViewDataSource {

    func reloadData(for indexPath: IndexPath? = nil) {
        if let indexPath = indexPath {
            table.reloadRows(at: [indexPath], with: .fade)
        } else {
            table.reloadData()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.sections[section].rows.count
    }

    private func getTransactionItem(at indexPath: IndexPath) -> TransactionItem? {
        if let id = tableData[indexPath].id {
            return TransactionItem(rawValue: id)
        } else {
            return nil
        }
    }

    private func leftRightCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: LeftRightCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: LeftRightCell.self.description()) as? LeftRightCell else {
                    return UITableViewCell()
        }
        cell.textLabel?.text = tableData[indexPath].name
        cell.detailTextLabel?.text = tableData[indexPath].desc
        cell.detailTextLabel?.textColor = .red
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func inputAmountCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard let cell: InputAmountCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: InputAmountCell.self.description()) as? InputAmountCell else {
                    return UITableViewCell()
        }
        cell.textLabel?.text = tableData[indexPath].name
        amountTextField = cell.amountTextField
        cell.amountTextField.delegate = self
        amountTextField?.text = tableData[indexPath].desc
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    private func dateSelectionCell(_ tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        guard var cell: DateSelectionCellProtocol =
            tableView.dequeueReusableCell(
                withIdentifier: DateSelectionCell.self.description()) as? DateSelectionCell else {
                    return UITableViewCell()
        }
        cell.date = tableData[indexPath].desc?.date
        if let item = getTransactionItem(at: indexPath) {
            cell.actionOnDateChange = {[unowned self] date in
                self.service.didChoose(transactionItem: item, with: date)
            }
        }
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = getTransactionItem(at: indexPath) else {
            return UITableViewCell()
        }
        let cell: UITableViewCell
        switch item {
        case .from, .to, .recurrenceFrequency, .approvalMode, .date, .recurrenceEnd:
            cell = leftRightCell(tableView, at: indexPath)
        case .amount:
            cell = inputAmountCell(tableView, at: indexPath)
        case .dateSelection, .recurrenceEndDate:
            cell = dateSelectionCell(tableView, at: indexPath)
        }
        return cell
    }

    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        table.deleteRows(at: indexPaths, with: animation)
    } // TODO: check if this is delegate

    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        table.insertRows(at: indexPaths, with: animation)
    }

}

extension AdvancedNewTransactionVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableData[indexPath].height ?? 45
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableData[indexPath].height ?? 45
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let id = tableData[indexPath].id, let item = TransactionItem(rawValue: id) else { return }
        service.didSelect(item)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        service.didScroll()
    }// TODO: check if this event is correct choice

}

extension AdvancedNewTransactionVC: UITextFieldDelegate {

    func textFieldDidEndEditing(_ textField: UITextField) {
        service.didChoose(transactionItem: .amount, with: textField.text)
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
    }

}
