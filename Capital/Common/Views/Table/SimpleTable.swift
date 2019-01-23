internal protocol SimpleTableProtocol: TemplateTableProtocol {
}

internal class SimpleTable: TemplateTable, SimpleTableProtocol {
    override internal init() {
        super.init()
        register(LeftRightCell.self, forCellReuseIdentifier: LeftRightCell.self.description())
        register(
            SimpleSectionHeader.self,
            forHeaderFooterViewReuseIdentifier: SimpleSectionHeader.self.description()
        )
    }

    internal required init?(coder aDecoder: NSCoder) {
        return nil
    }

    override internal func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: LeftRightCell.self.description())
        cell?.textLabel?.text = data[indexPath].texts[.name]
        cell?.detailTextLabel?.text = data[indexPath].texts[.desc]
        cell?.accessoryType = UITableViewCell.AccessoryType(rawValue: data[indexPath].accessory ?? 0) ?? .none
        cell?.accessibilityIdentifier = data[indexPath].texts[.name]
        return cell ?? UITableViewCell()
    }
}
