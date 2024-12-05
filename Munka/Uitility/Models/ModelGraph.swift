//
//  ModelGraph.swift
//  Munka
//
//  Created by Amit on 23/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelGraph : NSObject, NSCoding{

    var details : [ModelGrpahDetail]!
    var msg : String!
    var status : String!
    var totalAmount : String!
    var nextAmmount : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        totalAmount = dictionary["total_amount"] as? String
        nextAmmount = dictionary["next_payment"] as? String
        details = [ModelGrpahDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelGrpahDetail(fromDictionary: dic)
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
        if totalAmount != nil{
            dictionary["total_amount"] = totalAmount
        }
        if nextAmmount != nil{
            dictionary["next_payment"] = totalAmount
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
        details = aDecoder.decodeObject(forKey: "details") as? [ModelGrpahDetail]
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        totalAmount = aDecoder.decodeObject(forKey: "total_amount") as? String
        nextAmmount = aDecoder.decodeObject(forKey: "next_payment") as? String
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
        if totalAmount != nil{
            aCoder.encode(totalAmount, forKey: "total_amount")
        }
        if nextAmmount != nil{
                   aCoder.encode(totalAmount, forKey: "next_payment")
               }
    }
}
class ModelGrpahDetail : NSObject, NSCoding{

    var amount : String!
    var date : String!
    var day : String!
    var month : String!
    var number : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        amount = dictionary["amount"] as? String
        date = dictionary["date"] as? String
        day = dictionary["day"] as? String
        month = dictionary["month"] as? String
        number = dictionary["number"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if amount != nil{
            dictionary["amount"] = amount
        }
        if date != nil{
            dictionary["date"] = date
        }
        if day != nil{
            dictionary["day"] = day
        }
        if month != nil{
            dictionary["month"] = month
        }
        if number != nil{
            dictionary["number"] = number
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        amount = aDecoder.decodeObject(forKey: "amount") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
        day = aDecoder.decodeObject(forKey: "day") as? String
        month = aDecoder.decodeObject(forKey: "month") as? String
        number = aDecoder.decodeObject(forKey: "number") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if amount != nil{
            aCoder.encode(amount, forKey: "amount")
        }
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if day != nil{
            aCoder.encode(day, forKey: "day")
        }
        if month != nil{
            aCoder.encode(month, forKey: "month")
        }
        if number != nil{
            aCoder.encode(number, forKey: "number")
        }
    }
}
