//
//  ModelReviews.swift
//  Munka
//
//  Created by Amit on 25/11/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelReviews : NSObject, NSCoding{

    var msg : String!
    var reviewList : [ModelReviewList]!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        reviewList = [ModelReviewList]()
        if let reviewListArray = dictionary["review_list"] as? [[String:Any]]{
            for dic in reviewListArray{
                let value = ModelReviewList(fromDictionary: dic)
                reviewList.append(value)
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
        if reviewList != nil{
            var dictionaryElements = [[String:Any]]()
            for reviewListElement in reviewList {
                dictionaryElements.append(reviewListElement.toDictionary())
            }
            dictionary["reviewList"] = dictionaryElements
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
        reviewList = aDecoder.decodeObject(forKey: "review_list") as? [ModelReviewList]
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
        if reviewList != nil{
            aCoder.encode(reviewList, forKey: "review_list")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
class ModelReviewList : NSObject, NSCoding{

    var created : String!
    var id : String!
    var isDeleted : String!
    var isPrivate : String!
    var jobId : String!
    var jobTitle : String!
    var profilePic : String!
    var rating : String!
    var receiverName : String!
    var review : String!
    var senderName : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        created = dictionary["created"] as? String
        id = dictionary["id"] as? String
        isDeleted = dictionary["is_deleted"] as? String
        isPrivate = dictionary["is_private"] as? String
        jobId = dictionary["job_id"] as? String
        jobTitle = dictionary["job_title"] as? String
        profilePic = dictionary["profile_pic"] as? String
        rating = dictionary["rating"] as? String
        receiverName = dictionary["receiver_name"] as? String
        review = dictionary["review"] as? String
        senderName = dictionary["sender_name"] as? String
        status = dictionary["status"] as? String
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
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if isPrivate != nil{
            dictionary["is_private"] = isPrivate
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if jobTitle != nil{
            dictionary["job_title"] = jobTitle
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if receiverName != nil{
            dictionary["receiver_name"] = receiverName
        }
        if review != nil{
            dictionary["review"] = review
        }
        if senderName != nil{
            dictionary["sender_name"] = senderName
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
        created = aDecoder.decodeObject(forKey: "created") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        isPrivate = aDecoder.decodeObject(forKey: "is_private") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        receiverName = aDecoder.decodeObject(forKey: "receiver_name") as? String
        review = aDecoder.decodeObject(forKey: "review") as? String
        senderName = aDecoder.decodeObject(forKey: "sender_name") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
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
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if isPrivate != nil{
            aCoder.encode(isPrivate, forKey: "is_private")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if jobTitle != nil{
            aCoder.encode(jobTitle, forKey: "job_title")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if receiverName != nil{
            aCoder.encode(receiverName, forKey: "receiver_name")
        }
        if review != nil{
            aCoder.encode(review, forKey: "review")
        }
        if senderName != nil{
            aCoder.encode(senderName, forKey: "sender_name")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
