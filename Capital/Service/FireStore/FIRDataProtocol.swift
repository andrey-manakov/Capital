

protocol FIRDataProtocol {
    
    func create(_ dataObject: DataObjectType, with data: [String: Any?], completion: ((String?)->())?)
    func update(_ dataObject: DataObjectType, id: String?, with values: [String: Any?], completion: (()->())?)
    
    func deleteAll(_ completion: (()->())?)
    func checkIfCapitalAccountExist(completion: ((Error?)->())?)
}
