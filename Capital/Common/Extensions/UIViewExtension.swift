extension UIView {
    /// Adds subviews to UIView based on Visual Formatting
    ///
    /// - Parameters:
    ///   - views: dictionary of views to add
    ///   - constraints: array of Visual Formatting strings to apply
    internal func add(subViews views: [String: UIView?], withConstraints constraints: [String]) {
        guard let views = views as? [String: UIView] else {
            print("error in addSubviewsWithConstraints")
            return
        }
        for (accessibilityIdentifier, view) in views {
            self.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.accessibilityIdentifier = accessibilityIdentifier
        }

        for index in 0..<constraints.count {
            self.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: constraints[index],
                options: NSLayoutConstraint.FormatOptions(rawValue: 0),
                metrics: nil,
                views: views
                )
            )
        }
    }

    internal func add(subView view: UIView?, withConstraints constraints: [String]) {
        add(subViews: ["v": view], withConstraints: constraints)
    }

    internal var views: [String: UIView] {
        var views = [String: UIView]()
        for view in self.subviews {
            guard let id = view.accessibilityIdentifier else { continue }
            views[id] = view
        }
        return views
    }

    internal var id: String { return ObjectIdentifier(self).debugDescription }
}
