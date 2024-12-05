//
//  ModelMyEarning.swift
//  Munka
//
//  Created by Amit on 21/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelMyEarning : NSObject, NSCoding{

    var details : [ModelMyEarnDetail]!
    var msg : String!
    var nextPayment : String!
    var status : String!
    var totalEarning : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        nextPayment = dictionary["next_payment"] as? String
        status = dictionary["status"] as? String
        totalEarning = dictionary["total_earning"] as? String
        details = [ModelMyEarnDetail]()
        if let detailsArray = dictionary["details"] as? [[String:Any]]{
            for dic in detailsArray{
                let value = ModelMyEarnDetail(fromDictionary: dic)
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
        if nextPayment != nil{
            dictionary["next_payment"] = nextPayment
        }
        if status != nil{
            dictionary["status"] = status
        }
        if totalEarning != nil{
            dictionary["total_earning"] = totalEarning
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
        details = aDecoder.decodeObject(forKey: "details") as? [ModelMyEarnDetail]
        msg = aDecoder.decodeObject(forKey: "msg") as? String
        nextPayment = aDecoder.decodeObject(forKey: "next_payment") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        totalEarning = aDecoder.decodeObject(forKey: "total_earning") as? String
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
        if nextPayment != nil{
            aCoder.encode(nextPayment, forKey: "next_payment")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if totalEarning != nil{
            aCoder.encode(totalEarning, forKey: "total_earning")
        }
    }
}
class ModelMyEarnDetail : NSObject, NSCoding{

    var earnAmount : String!
    var jobEndDate : String!
    var jobId : String!
    var jobStartDate : String!
    var jobTitle : String!
    var jobType : String!
    var joiningDate : String!
    var name : String!
    var profilePic : String!
    var timeDuration : String!
    var workedBy : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        earnAmount = dictionary["earn_amount"] as? String
        jobEndDate = dictionary["job_end_date"] as? String
        jobId = dictionary["job_id"] as? String
        jobStartDate = dictionary["job_start_date"] as? String
        jobTitle = dictionary["job_title"] as? String
        jobType = dictionary["job_type"] as? String
        joiningDate = dictionary["joining_date"] as? String
        name = dictionary["name"] as? String
        profilePic = dictionary["profile_pic"] as? String
        timeDuration = dictionary["time_duration"] as? String
        workedBy = dictionary["worked_by"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if earnAmount != nil{
            dictionary["earn_amount"] = earnAmount
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
        if joiningDate != nil{
            dictionary["joining_date"] = joiningDate
        }
        if name != nil{
            dictionary["name"] = name
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if timeDuration != nil{
            dictionary["time_duration"] = timeDuration
        }
        if workedBy != nil{
            dictionary["worked_by"] = workedBy
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        earnAmount = aDecoder.decodeObject(forKey: "earn_amount") as? String
        jobEndDate = aDecoder.decodeObject(forKey: "job_end_date") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobStartDate = aDecoder.decodeObject(forKey: "job_start_date") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        jobType = aDecoder.decodeObject(forKey: "job_type") as? String
        joiningDate = aDecoder.decodeObject(forKey: "joining_date") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        timeDuration = aDecoder.decodeObject(forKey: "time_duration") as? String
        workedBy = aDecoder.decodeObject(forKey: "worked_by") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if earnAmount != nil{
            aCoder.encode(earnAmount, forKey: "earn_amount")
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
        if joiningDate != nil{
            aCoder.encode(joiningDate, forKey: "joining_date")
        }
        if name != nil{
            aCoder.encode(name, forKey: "name")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if timeDuration != nil{
            aCoder.encode(timeDuration, forKey: "time_duration")
        }
        if workedBy != nil{
            aCoder.encode(workedBy, forKey: "worked_by")
        }
    }
}
