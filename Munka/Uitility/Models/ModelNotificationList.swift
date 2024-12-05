//
//  ModelNotificationList.swift
//  Munka
//
//  Created by Amit on 19/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelNotificationList : NSObject, NSCoding{

    var msg : String!
    var notificationList : [ModelNewNotificationList]!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        notificationList = [ModelNewNotificationList]()
        if let notificationListArray = dictionary["notification_list"] as? [[String:Any]]{
            for dic in notificationListArray{
                let value = ModelNewNotificationList(fromDictionary: dic)
                notificationList.append(value)
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
        if notificationList != nil{
            var dictionaryElements = [[String:Any]]()
            for notificationListElement in notificationList {
                dictionaryElements.append(notificationListElement.toDictionary())
            }
            dictionary["notificationList"] = dictionaryElements
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
        notificationList = aDecoder.decodeObject(forKey: "notification_list") as? [ModelNewNotificationList]
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
        if notificationList != nil{
            aCoder.encode(notificationList, forKey: "notification_list")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
class ModelNewNotificationList : NSObject, NSCoding{

    var creationDatetime : String!
    var notificationDescription : String!
    var notificationId : String!
    var notificationTitle : String!
    var notificationType : String!
    var recordId : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        creationDatetime = dictionary["creation_datetime"] as? String
        notificationDescription = dictionary["notification_description"] as? String
        notificationId = dictionary["notification_id"] as? String
        notificationTitle = dictionary["notification_title"] as? String
        notificationType = dictionary["notification_type"] as? String
        recordId = dictionary["record_id"] as? String
        userId = dictionary["user_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if creationDatetime != nil{
            dictionary["creation_datetime"] = creationDatetime
        }
        if notificationDescription != nil{
            dictionary["notification_description"] = notificationDescription
        }
        if notificationId != nil{
            dictionary["notification_id"] = notificationId
        }
        if notificationTitle != nil{
            dictionary["notification_title"] = notificationTitle
        }
        if notificationType != nil{
            dictionary["notification_type"] = notificationType
        }
        if recordId != nil{
            dictionary["record_id"] = recordId
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
        creationDatetime = aDecoder.decodeObject(forKey: "creation_datetime") as? String
        notificationDescription = aDecoder.decodeObject(forKey: "notification_description") as? String
        notificationId = aDecoder.decodeObject(forKey: "notification_id") as? String
        notificationTitle = aDecoder.decodeObject(forKey: "notification_title") as? String
        notificationType = aDecoder.decodeObject(forKey: "notification_type") as? String
        recordId = aDecoder.decodeObject(forKey: "record_id") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if creationDatetime != nil{
            aCoder.encode(creationDatetime, forKey: "creation_datetime")
        }
        if notificationDescription != nil{
            aCoder.encode(notificationDescription, forKey: "notification_description")
        }
        if notificationId != nil{
            aCoder.encode(notificationId, forKey: "notification_id")
        }
        if notificationTitle != nil{
            aCoder.encode(notificationTitle, forKey: "notification_title")
        }
        if notificationType != nil{
            aCoder.encode(notificationType, forKey: "notification_type")
        }
        if recordId != nil{
            aCoder.encode(recordId, forKey: "record_id")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
