//
//  ModelIndividualPromoCode.swift
//  Munka
//
//  Created by Amit on 18/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelIndividualPromoCode : NSObject, NSCoding{

    var msg : String!
    var offersList : [ModelOffersList]!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        offersList = [ModelOffersList]()
        if let offersListArray = dictionary["offers_list"] as? [[String:Any]]{
            for dic in offersListArray{
                let value = ModelOffersList(fromDictionary: dic)
                offersList.append(value)
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
        if offersList != nil{
            var dictionaryElements = [[String:Any]]()
            for offersListElement in offersList {
                dictionaryElements.append(offersListElement.toDictionary())
            }
            dictionary["offersList"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        offersList = aDecoder.decodeObject(forKey: "offers_list") as? [ModelOffersList]
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if msg != nil{
            aCoder.encode(msg, forKey: "msg")
        }
        if offersList != nil{
            aCoder.encode(offersList, forKey: "offers_list")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
class ModelOffersList : NSObject, NSCoding{

    var code : String!
    var created : String!
    var descriptionField : String!
    var endDate : String!
    var expired : String!
    var isDeleted : String!
    var maxDiscount : String!
    var minAmount : String!
    var modified : String!
    var offerId : String!
    var redemptionPerUser : String!
    var startDate : String!
    var status : String!
    var title : String!
    var totalRedemption : String!
    var type : String!
    var value : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        code = dictionary["code"] as? String
        created = dictionary["created"] as? String
        descriptionField = dictionary["description"] as? String
        endDate = dictionary["end_date"] as? String
        expired = dictionary["expired"] as? String
        isDeleted = dictionary["is_deleted"] as? String
        maxDiscount = dictionary["max_discount"] as? String
        minAmount = dictionary["min_amount"] as? String
        modified = dictionary["modified"] as? String
        offerId = dictionary["offer_id"] as? String
        redemptionPerUser = dictionary["redemption_per_user"] as? String
        startDate = dictionary["start_date"] as? String
        status = dictionary["status"] as? String
        title = dictionary["title"] as? String
        totalRedemption = dictionary["total_redemption"] as? String
        type = dictionary["type"] as? String
        value = dictionary["value"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if code != nil{
            dictionary["code"] = code
        }
        if created != nil{
            dictionary["created"] = created
        }
        if descriptionField != nil{
            dictionary["description"] = descriptionField
        }
        if endDate != nil{
            dictionary["end_date"] = endDate
        }
        if expired != nil{
            dictionary["expired"] = expired
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if maxDiscount != nil{
            dictionary["max_discount"] = maxDiscount
        }
        if minAmount != nil{
            dictionary["min_amount"] = minAmount
        }
        if modified != nil{
            dictionary["modified"] = modified
        }
        if offerId != nil{
            dictionary["offer_id"] = offerId
        }
        if redemptionPerUser != nil{
            dictionary["redemption_per_user"] = redemptionPerUser
        }
        if startDate != nil{
            dictionary["start_date"] = startDate
        }
        if status != nil{
            dictionary["status"] = status
        }
        if title != nil{
            dictionary["title"] = title
        }
        if totalRedemption != nil{
            dictionary["total_redemption"] = totalRedemption
        }
        if type != nil{
            dictionary["type"] = type
        }
        if value != nil{
            dictionary["value"] = value
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        code = aDecoder.decodeObject(forKey: "code") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        descriptionField = aDecoder.decodeObject(forKey: "description") as? String
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        expired = aDecoder.decodeObject(forKey: "expired") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        maxDiscount = aDecoder.decodeObject(forKey: "max_discount") as? String
        minAmount = aDecoder.decodeObject(forKey: "min_amount") as? String
        modified = aDecoder.decodeObject(forKey: "modified") as? String
        offerId = aDecoder.decodeObject(forKey: "offer_id") as? String
        redemptionPerUser = aDecoder.decodeObject(forKey: "redemption_per_user") as? String
        startDate = aDecoder.decodeObject(forKey: "start_date") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        title = aDecoder.decodeObject(forKey: "title") as? String
        totalRedemption = aDecoder.decodeObject(forKey: "total_redemption") as? String
        type = aDecoder.decodeObject(forKey: "type") as? String
        value = aDecoder.decodeObject(forKey: "value") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if code != nil{
            aCoder.encode(code, forKey: "code")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if descriptionField != nil{
            aCoder.encode(descriptionField, forKey: "description")
        }
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if expired != nil{
            aCoder.encode(expired, forKey: "expired")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if maxDiscount != nil{
            aCoder.encode(maxDiscount, forKey: "max_discount")
        }
        if minAmount != nil{
            aCoder.encode(minAmount, forKey: "min_amount")
        }
        if modified != nil{
            aCoder.encode(modified, forKey: "modified")
        }
        if offerId != nil{
            aCoder.encode(offerId, forKey: "offer_id")
        }
        if redemptionPerUser != nil{
            aCoder.encode(redemptionPerUser, forKey: "redemption_per_user")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if title != nil{
            aCoder.encode(title, forKey: "title")
        }
        if totalRedemption != nil{
            aCoder.encode(totalRedemption, forKey: "total_redemption")
        }
        if type != nil{
            aCoder.encode(type, forKey: "type")
        }
        if value != nil{
            aCoder.encode(value, forKey: "value")
        }
    }
}
