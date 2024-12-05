//
//  ModelReceivedJobRequest.swift
//  Munka
//
//  Created by Amit on 02/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelReceivedJobRequest : NSObject, NSCoding{

    var msg : String!
    var requestList : [ModelRequestList]!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        requestList = [ModelRequestList]()
        if let requestListArray = dictionary["request_list"] as? [[String:Any]]{
            for dic in requestListArray{
                let value = ModelRequestList(fromDictionary: dic)
                requestList.append(value)
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
        if requestList != nil{
            var dictionaryElements = [[String:Any]]()
            for requestListElement in requestList {
                dictionaryElements.append(requestListElement.toDictionary())
            }
            dictionary["requestList"] = dictionaryElements
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
        requestList = aDecoder.decodeObject(forKey: "request_list") as? [ModelRequestList]
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
        if requestList != nil{
            aCoder.encode(requestList, forKey: "request_list")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
class ModelRequestList : NSObject, NSCoding{

    var appliedBy : [ModelAppliedBy]!
    var budgetAmount : String!
    var created : String!
    var jobDescription : String!
    var jobEndDate : String!
    var jobId : String!
    var jobStartDate : String!
    var jobTitle : String!
    var jobType : String!
    var name : String!
    var postedBy : String!
    var timeDuration : String!
    var trackValue : Int!

    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        budgetAmount = dictionary["budget_amount"] as? String
        created = dictionary["created"] as? String
        jobDescription = dictionary["job_description"] as? String
        jobEndDate = dictionary["job_end_date"] as? String
        jobId = dictionary["job_id"] as? String
        jobStartDate = dictionary["job_start_date"] as? String
        jobTitle = dictionary["job_title"] as? String
        jobType = dictionary["job_type"] as? String
        name = dictionary["name"] as? String
        postedBy = dictionary["posted_by"] as? String
        timeDuration = dictionary["time_duration"] as? String
        appliedBy = [ModelAppliedBy]()
        trackValue = dictionary["track_value"] as? Int
        if let appliedByArray = dictionary["applied_by"] as? [[String:Any]]{
            for dic in appliedByArray{
                let value = ModelAppliedBy(fromDictionary: dic)
                appliedBy.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if budgetAmount != nil{
            dictionary["budget_amount"] = budgetAmount
        }
        if trackValue != nil{
            dictionary["applied_by"] = trackValue
        }
        if created != nil{
            dictionary["created"] = created
        }
        if jobDescription != nil{
            dictionary["job_description"] = jobDescription
        }
        if jobEndDate != nil{
            dictionary["job_end_date"] = jobEndDate
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if jobStartDate != nil{
            dictionary["job_start_date"] = jobStartDate
        }
        if jobTitle != nil{
            dictionary["job_title"] = jobTitle
        }
        if jobType != nil{
            dictionary["job_type"] = jobType
        }
        if name != nil{
            dictionary["name"] = name
        }
        if postedBy != nil{
            dictionary["posted_by"] = postedBy
        }
        if timeDuration != nil{
            dictionary["time_duration"] = timeDuration
        }
        if appliedBy != nil{
            var dictionaryElements = [[String:Any]]()
            for appliedByElement in appliedBy {
                dictionaryElements.append(appliedByElement.toDictionary())
            }
            dictionary["appliedBy"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
         trackValue = aDecoder.decodeObject(forKey: "track_value") as? Int
        appliedBy = aDecoder.decodeObject(forKey: "applied_by") as? [ModelAppliedBy]
        budgetAmount = aDecoder.decodeObject(forKey: "budget_amount") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        jobDescription = aDecoder.decodeObject(forKey: "job_description") as? String
        jobEndDate = aDecoder.decodeObject(forKey: "job_end_date") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobStartDate = aDecoder.decodeObject(forKey: "job_start_date") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        jobType = aDecoder.decodeObject(forKey: "job_type") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        postedBy = aDecoder.decodeObject(forKey: "posted_by") as? String
        timeDuration = aDecoder.decodeObject(forKey: "time_duration") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if trackValue != nil{
            aCoder.encode(trackValue, forKey: "track_value")
        }
        if appliedBy != nil{
            aCoder.encode(appliedBy, forKey: "applied_by")
        }
        if budgetAmount != nil{
            aCoder.encode(budgetAmount, forKey: "budget_amount")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if jobDescription != nil{
            aCoder.encode(jobDescription, forKey: "job_description")
        }
        if jobEndDate != nil{
            aCoder.encode(jobEndDate, forKey: "job_end_date")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if jobStartDate != nil{
            aCoder.encode(jobStartDate, forKey: "job_start_date")
        }
        if jobTitle != nil{
            aCoder.encode(jobTitle, forKey: "job_title")
        }
        if jobType != nil{
            aCoder.encode(jobType, forKey: "job_type")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if postedBy != nil{
            aCoder.encode(postedBy, forKey: "posted_by")
        }
        if timeDuration != nil{
            aCoder.encode(timeDuration, forKey: "time_duration")
        }
    }
}
class ModelAppliedBy : NSObject, NSCoding{

    var appliedBy : String!
    var created : String!
    var email : String!
    var firstName : String!
    var id : String!
    var jobId : String!
    var lastName : String!
    var mobile : String!
    var modified : String!
    var profilePic : String!
    var rating : String!
    var rejectedReason : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        appliedBy = dictionary["applied_by"] as? String
        created = dictionary["created"] as? String
        email = dictionary["email"] as? String
        firstName = dictionary["first_name"] as? String
        id = dictionary["id"] as? String
        jobId = dictionary["job_id"] as? String
        lastName = dictionary["last_name"] as? String
        mobile = dictionary["mobile"] as? String
        modified = dictionary["modified"] as? String
        profilePic = dictionary["profile_pic"] as? String
        rating = dictionary["rating"] as? String
        rejectedReason = dictionary["rejected_reason"] as? String
        status = dictionary["status"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if appliedBy != nil{
            dictionary["applied_by"] = appliedBy
        }
        if created != nil{
            dictionary["created"] = created
        }
        if email != nil{
            dictionary["email"] = email
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if id != nil{
            dictionary["id"] = id
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if modified != nil{
            dictionary["modified"] = modified
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if rejectedReason != nil{
            dictionary["rejected_reason"] = rejectedReason
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
        appliedBy = aDecoder.decodeObject(forKey: "applied_by") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        modified = aDecoder.decodeObject(forKey: "modified") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        rejectedReason = aDecoder.decodeObject(forKey: "rejected_reason") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if appliedBy != nil{
            aCoder.encode(appliedBy, forKey: "applied_by")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if mobile != nil{
            aCoder.encode(mobile, forKey: "mobile")
        }
        if modified != nil{
            aCoder.encode(modified, forKey: "modified")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if rejectedReason != nil{
            aCoder.encode(rejectedReason, forKey: "rejected_reason")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
