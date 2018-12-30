
class EmailField: SimpleTextField {
    override init(_ placeholder: String? = nil, _ actionOnReturn: (()->())? = nil) {
        super.init(placeholder, actionOnReturn)
        keyboardType = .emailAddress
    }
    required init?(coder aDecoder: NSCoder) {return nil}
}
