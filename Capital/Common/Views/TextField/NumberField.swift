class NumberField: SimpleTextField {
    override init(_ placeholder: String? = nil, _ actionOnReturn: (() -> Void)? = nil) {
        super.init(placeholder, actionOnReturn)
        keyboardType = .numberPad
    }

    required init?(coder aDecoder: NSCoder) {fatalError("init(coder:) has not been implemented")}
}
