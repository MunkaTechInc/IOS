//
//  ModelReasonList.swift
//  Munka
//
//  Created by Amit on 10/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelReasonList : NSObject, NSCoding{

    var details : [ModelReasonDetail]!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        details = [ModelReasonDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelReasonDetail(fromDictionary: dic)
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
        details = aDecoder.decodeObject(forKey: "details") as? [ModelReasonDetail]
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
class ModelReasonDetail : NSObject, NSCoding{

    var created : String!
    var id : String!
    var name : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        created = dictionary["created"] as? String
        id = dictionary["id"] as? String
        name = dictionary["name"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if created != nil{
            dictionary["created"] = created
        }
        if id != nil{
            dictionary["id"] = id
        }
        if name != nil{
            dictionary["name"] = name
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        created = aDecoder.decodeObject(forKey: "created") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
    }
}
