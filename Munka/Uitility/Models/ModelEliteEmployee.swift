class ModelEliteEmployee : NSObject, NSCoding{

    var details : [ModelEliteDetail]!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        details = [ModelEliteDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelEliteDetail(fromDictionary: dic)
                details.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if msg != nil{
            dictionary["msg"] = msg
        }
        if status != nil{
            dictionary["status"] = status
        }
        if details != nil{
            var dictionaryElements = [[String:Any]]()
            for detailsElement in details {
                dictionaryElements.append(detailsElement.toDictionary())
            }
            dictionary["details"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        details = aDecoder.decodeObject(forKey: "details") as? [ModelEliteDetail]
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if details != nil{
            aCoder.encode(details, forKey: "details")
        }
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
class ModelEliteDetail : NSObject, NSCoding{

    var aboutUs : String!
    var fullName : String!
    var profilePic : String!
    var rating : String!
    var userId : String!
    var workCategory : [ModelWorkCategory]!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aboutUs = dictionary["about_us"] as? String
        fullName = dictionary["full_name"] as? String
        profilePic = dictionary["profile_pic"] as? String
        rating = dictionary["rating"] as? String
        userId = dictionary["user_id"] as? String
        workCategory = [ModelWorkCategory]()
        if let workCategoryArray = dictionary["work_category"] as? [[String:Any]]{
            for dic in workCategoryArray{
                let value = ModelWorkCategory(fromDictionary: dic)
                workCategory.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aboutUs != nil{
            dictionary["about_us"] = aboutUs
        }
        if fullName != nil{
            dictionary["full_name"] = fullName
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if workCategory != nil{
            var dictionaryElements = [[String:Any]]()
            for workCategoryElement in workCategory {
                dictionaryElements.append(workCategoryElement.toDictionary())
            }
            dictionary["workCategory"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        aboutUs = aDecoder.decodeObject(forKey: "about_us") as? String
        fullName = aDecoder.decodeObject(forKey: "full_name") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        workCategory = aDecoder.decodeObject(forKey: "work_category") as? [ModelWorkCategory]
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if aboutUs != nil{
            aCoder.encode(aboutUs, forKey: "about_us")
        }
        if fullName != nil{
            aCoder.encode(fullName, forKey: "full_name")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if workCategory != nil{
            aCoder.encode(workCategory, forKey: "work_category")
        }
    }
}
class ModelWorkCategory : NSObject, NSCoding{

    var id : String!
    var serviceCategory : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        id = dictionary["id"] as? String
        serviceCategory = dictionary["service_category"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if id != nil{
            dictionary["id"] = id
        }
        if serviceCategory != nil{
            dictionary["service_category"] = serviceCategory
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        id = aDecoder.decodeObject(forKey: "id") as? String
        serviceCategory = aDecoder.decodeObject(forKey: "service_category") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if serviceCategory != nil{
            aCoder.encode(serviceCategory, forKey: "service_category")
        }
    }
}
