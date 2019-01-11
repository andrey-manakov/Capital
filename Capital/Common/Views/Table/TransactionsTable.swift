internal protocol TransactionsTableProtocol: SimpleTableWithSwipeProtocol {

}

internal class TransactionsTable: SimpleTableWithSwipe, TransactionsTableProtocol {

    override internal init() {
        super.init()
        register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.self.description())
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        guard let cell: TransactionCellProtocol = dequeueReusableCell(
            withIdentifier: TransactionCell.self.description()) as? TransactionCell else {
            return UITableViewCell()
        }
        cell.date.text = "\(data[indexPath].left ?? "")"
        cell.from.text = "from: \(data[indexPath].up ?? "")"
        cell.to.text = "to: \(data[indexPath].down ?? "")"
        cell.amount.text = data[indexPath].right
        return cell as? TransactionCell ?? UITableViewCell()
    }

}
