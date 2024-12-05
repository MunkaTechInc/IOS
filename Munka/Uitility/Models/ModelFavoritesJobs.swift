//
//  ModelFavoritesJobs.swift
//  Munka
//
//  Created by Amit on 23/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelFavoritesJobs : NSObject, NSCoding{

    var details : [ModelFavoritesJobDetail]!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        details = [ModelFavoritesJobDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelFavoritesJobDetail(fromDictionary: dic)
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
        details = aDecoder.decodeObject(forKey: "details") as? [ModelFavoritesJobDetail]
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
class ModelFavoritesJobDetail : NSObject, NSCoding{

    var budgetAmount : String!
    var created : String!
    var distance : String!
    var id : String!
    var isPrivate : String!
    var jobDescription : String!
    var jobEndDate : String!
    var jobId : String!
    var jobLocation : String!
    var jobStartDate : String!
    var jobTitle : String!
    var jobType : String!
    var timeDuration : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        budgetAmount = dictionary["budget_amount"] as? String
        created = dictionary["created"] as? String
        distance = dictionary["distance"] as? String
        id = dictionary["id"] as? String
        isPrivate = dictionary["is_private"] as? String
        jobDescription = dictionary["job_description"] as? String
        jobEndDate = dictionary["job_end_date"] as? String
        jobId = dictionary["job_id"] as? String
        jobLocation = dictionary["job_location"] as? String
        jobStartDate = dictionary["job_start_date"] as? String
        jobTitle = dictionary["job_title"] as? String
        jobType = dictionary["job_type"] as? String
        timeDuration = dictionary["time_duration"] as? String
        userId = dictionary["user_id"] as? String
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
        if created != nil{
            dictionary["created"] = created
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isPrivate != nil{
            dictionary["is_private"] = isPrivate
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
        if jobLocation != nil{
            dictionary["job_location"] = jobLocation
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
        if timeDuration != nil{
            dictionary["time_duration"] = timeDuration
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
        budgetAmount = aDecoder.decodeObject(forKey: "budget_amount") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        isPrivate = aDecoder.decodeObject(forKey: "is_private") as? String
        jobDescription = aDecoder.decodeObject(forKey: "job_description") as? String
        jobEndDate = aDecoder.decodeObject(forKey: "job_end_date") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobLocation = aDecoder.decodeObject(forKey: "job_location") as? String
        jobStartDate = aDecoder.decodeObject(forKey: "job_start_date") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        jobType = aDecoder.decodeObject(forKey: "job_type") as? String
        timeDuration = aDecoder.decodeObject(forKey: "time_duration") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if budgetAmount != nil{
            aCoder.encode(budgetAmount, forKey: "budget_amount")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isPrivate != nil{
            aCoder.encode(isPrivate, forKey: "is_private")
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
        if jobLocation != nil{
            aCoder.encode(jobLocation, forKey: "job_location")
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
        if timeDuration != nil{
            aCoder.encode(timeDuration, forKey: "time_duration")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
