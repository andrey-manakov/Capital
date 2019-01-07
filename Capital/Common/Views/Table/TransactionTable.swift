import UIKit

protocol TransactionsTableProtocol: SimpleTableWithSwipeProtocol {

}

class TransactionsTable: SimpleTableWithSwipe, TransactionsTableProtocol {

    override init() {
        super.init()
        register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.self.description())
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: TransactionCellProtocol = dequeueReusableCell(withIdentifier: TransactionCell.self.description()) as? TransactionCell else {
            return UITableViewCell()
        }
        cell.date.text = "\(data[indexPath].left ?? "")"
        cell.from.text = "from: \(data[indexPath].up ?? "")"
        cell.to.text = "to: \(data[indexPath].down ?? "")"
        cell.amount.text = data[indexPath].right
        return cell as? TransactionCell ?? UITableViewCell()
    }

}
