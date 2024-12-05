//
//  ModelMyWallet.swift
//  Munka
//
//  Created by Amit on 29/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//



import Foundation


class ModelMyWallet : NSObject, NSCoding{

    var details : [ModelMyWalletDetail]!
    var msg : String!
    var status : String!
    var walletAmount : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        walletAmount = dictionary["wallet_amount"] as? String
        details = [ModelMyWalletDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelMyWalletDetail(fromDictionary: dic)
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
        if walletAmount != nil{
            dictionary["wallet_amount"] = walletAmount
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
        details = aDecoder.decodeObject(forKey: "details") as? [ModelMyWalletDetail]
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        walletAmount = aDecoder.decodeObject(forKey: "wallet_amount") as? String
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
        if walletAmount != nil{
            aCoder.encode(walletAmount, forKey: "wallet_amount")
        }
    }
}
class ModelMyWalletDetail : NSObject, NSCoding{

    var amount : String!
    var amountType : String!
    var created : String!
    var id : String!
    var jobId : String!
    var jobTitle : String!
    var message : String!
    var name : String!
    var transactionId : String!
    var transactionType : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        amount = dictionary["amount"] as? String
        amountType = dictionary["amount_type"] as? String
        created = dictionary["created"] as? String
        id = dictionary["id"] as? String
        jobId = dictionary["job_id"] as? String
        jobTitle = dictionary["job_title"] as? String
        message = dictionary["message"] as? String
        name = dictionary["name"] as? String
        transactionId = dictionary["transaction_id"] as? String
        transactionType = dictionary["transaction_type"] as? String
        userId = dictionary["user_id"] as? String
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
        if amountType != nil{
            dictionary["amount_type"] = amountType
        }
        if created != nil{
            dictionary["created"] = created
        }
        if id != nil{
            dictionary["id"] = id
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if jobTitle != nil{
            dictionary["job_title"] = jobTitle
        }
        if message != nil{
            dictionary["message"] = message
        }
        if name != nil{
            dictionary["name"] = name
        }
        if transactionId != nil{
            dictionary["transaction_id"] = transactionId
        }
        if transactionType != nil{
            dictionary["transaction_type"] = transactionType
        }
        if userId != nil{
            dictionary["user_id"] = userId
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
        amountType = aDecoder.decodeObject(forKey: "amount_type") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        transactionId = aDecoder.decodeObject(forKey: "transaction_id") as? String
        transactionType = aDecoder.decodeObject(forKey: "transaction_type") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
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
        if amountType != nil{
            aCoder.encode(amountType, forKey: "amount_type")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if jobTitle != nil{
            aCoder.encode(jobTitle, forKey: "job_title")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if transactionId != nil{
            aCoder.encode(transactionId, forKey: "transaction_id")
        }
        if transactionType != nil{
            aCoder.encode(transactionType, forKey: "transaction_type")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
