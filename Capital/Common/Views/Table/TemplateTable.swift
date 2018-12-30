
import UIKit

/// Template Table Protocol is public interface to Template Table. All the initializations of TemplateTable should be done through the TemplateTableProtocol
///
/// **Application Example**
///````
///let sampleTemplateTable: TemplateTableProtocol = TemplateTable()
///````

protocol TemplateTableProtocol: class {
    var localData: DataModelProtocol? {get set}
    var dataFormula: (()->(DataModel))? {get set}
    var didSelect: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> ())? {get set}
    var filter: ((DataModelRowProtocol)->(Bool))? {get set}
    
    func removeFromSuperview()
    
    func reloadData()
    func reloadRows(at: [IndexPath], with: UITableView.RowAnimation)
    func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    
}

//TODO: consider merge with SimpleTable Class
class TemplateTable: UITableView, TemplateTableProtocol, UITableViewDataSource, UITableViewDelegate {
    
    var dataFormula: (()->(DataModel))?
    var localData: DataModelProtocol? {didSet{reloadData()}} //Check if this works fine
    var dataBeforeFilter: DataModelProtocol {return dataFormula?() ?? localData ?? DataModel()}
    var data: DataModelProtocol {return dataBeforeFilter.filter(self.filter ?? {_ in return true})}
    var filter: ((DataModelRowProtocol)->(Bool))? {didSet{reloadData()}} //Check if this works fine
    
    var didSelect: ((_ row: DataModelRowProtocol, _ ix: IndexPath) -> ())?
    private var selectedRow: DataModelRowProtocol?
    
    init() {
        super.init(frame: CGRect.zero, style: UITableView.Style.plain)
        self.dataSource = self
        self.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {fatalError()}
    
    deinit {print("\(type(of: self)) deinit!")}
    
    // MARK: - Define sections
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return data.sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if data.sections[section].name == nil {return 0} else {return  44}
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.sections[section].rows.count
    }
    
    /* TODO: decide what to do with height def
     warning appears if i comment two functions below */
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(data[indexPath], indexPath)
        data[indexPath].selectAction?(data[indexPath], indexPath)
    }

}





