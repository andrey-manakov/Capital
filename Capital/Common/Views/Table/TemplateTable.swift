import UIKit

/// Template Table Protocol is public interface to Template Table.
/// All the initializations of TemplateTable should be done through the TemplateTableProtocol
///
/// **Application Example**
///````
///let sampleTemplateTable: TemplateTableProtocol = TemplateTable()
///````

internal protocol TemplateTableProtocol: AnyObject {
    var localData: DataModelProtocol? { get set }
    var dataFormula: (() -> (DataModel))? { get set }
    var didSelect: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)? { get set }
    var filter: ((DataModelRowProtocol) -> (Bool))? { get set }

    func removeFromSuperview()

    func reloadData()
    func reloadRows(at indexPath: [IndexPath], with: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
}

//TODO: consider merge with SimpleTable Class
internal class TemplateTable: UITableView, TemplateTableProtocol, UITableViewDataSource, UITableViewDelegate {
    internal var dataFormula: (() -> (DataModel))?
    internal var localData: DataModelProtocol? { didSet { reloadData() } } //Check if this works fine
    internal var dataBeforeFilter: DataModelProtocol { return dataFormula?() ?? localData ?? DataModel() }
    internal var data: DataModelProtocol {
        return dataBeforeFilter.filter(self.filter ?? { _ in return true })
    }
    internal var filter: ((DataModelRowProtocol) -> (Bool))? {
        didSet {
            reloadData()
        }
    } //Check if this works fine

    internal var didSelect: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> Void)?
    private var selectedRow: DataModelRowProtocol?

    internal init() {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.dataSource = self
        self.delegate = self
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    deinit { print("\(type(of: self)) deinit!") }

    // MARK: - Define sections

    internal func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }

    internal func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if data.sections[section].name == nil {
            return 0
        } else {
            return  44
        }
    }

    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sections[section].rows.count
    }

    // height def warning appears if i comment two functions below
    internal func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
        ) -> CGFloat {
        return 45
    }
    internal func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }

    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(data[indexPath], indexPath)
        data[indexPath].selectAction?(data[indexPath], indexPath)
    }
}
