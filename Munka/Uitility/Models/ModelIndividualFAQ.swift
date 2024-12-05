//
//  ModelIndividualFAQ.swift
//  Munka
//
//  Created by Amit on 19/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation



class ModelIndividualFAQ : NSObject, NSCoding{

    var details : [ModelFAQDetail]!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        details = [ModelFAQDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelFAQDetail(fromDictionary: dic)
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
        details = aDecoder.decodeObject(forKey: "details") as? [ModelFAQDetail]
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
class ModelFAQDetail : NSObject, NSCoding{

    var answer : String!
    var created : String!
    var faqId : String!
    var modified : String!
    var position : String!
    var question : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        answer = dictionary["answer"] as? String
        created = dictionary["created"] as? String
        faqId = dictionary["faq_id"] as? String
        modified = dictionary["modified"] as? String
        position = dictionary["position"] as? String
        question = dictionary["question"] as? String
        status = dictionary["status"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if answer != nil{
            dictionary["answer"] = answer
        }
        if created != nil{
            dictionary["created"] = created
        }
        if faqId != nil{
            dictionary["faq_id"] = faqId
        }
        if modified != nil{
            dictionary["modified"] = modified
        }
        if position != nil{
            dictionary["position"] = position
        }
        if question != nil{
            dictionary["question"] = question
        }
        if status != nil{
            dictionary["status"] = status
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        answer = aDecoder.decodeObject(forKey: "answer") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        faqId = aDecoder.decodeObject(forKey: "faq_id") as? String
        modified = aDecoder.decodeObject(forKey: "modified") as? String
        position = aDecoder.decodeObject(forKey: "position") as? String
        question = aDecoder.decodeObject(forKey: "question") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if answer != nil{
            aCoder.encode(answer, forKey: "answer")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if faqId != nil{
            aCoder.encode(faqId, forKey: "faq_id")
        }
        if modified != nil{
            aCoder.encode(modified, forKey: "modified")
        }
        if position != nil{
            aCoder.encode(position, forKey: "position")
        }
        if question != nil{
            aCoder.encode(question, forKey: "question")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
