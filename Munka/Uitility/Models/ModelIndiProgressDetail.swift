//
//  ModelIndiProgressDetail.swift
//  Munka
//
//  Created by Amit on 13/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation
class ModelIndiProgressDetail : NSObject, NSCoding{

    var details : ModelProgressDetail!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        if let detailsData = dictionary["details"] as? [String:Any]{
            details = ModelProgressDetail(fromDictionary: detailsData)
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
            dictionary["details"] = details.toDictionary()
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        details = aDecoder.decodeObject(forKey: "details") as? ModelProgressDetail
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
class ModelProgressDetail : NSObject, NSCoding{

    var appliedBy : String!
    var budgetAmount : String!
    var created : String!
    var distance : String!
    var endDate : String!
    var hourlyAmount : String!
    var hourlyJobTime : [ModelHourlyTime]!
    var id : String!
    var isDeleted : String!
    var isFavourite : String!
    var isPrivate : String!
    var isProfessional : String!
    var isPublish : String!
    var isReview : String!
    var jobDescription : String!
    var jobEndDate : String!
    var jobEndTime : String!
    var jobId : String!
    var jobLocation : String!
    var jobStartDate : String!
    var jobStartTime : String!
    var jobStatus : String!
    var jobTitle : String!
    var jobType : String!
    var jobWorkedBy : String!
    var joiningDate : String!
    var lateComingMinutes : String!
    var lateComingStatus : String!
    var latitude : String!
    var longitude : String!
    var materialDescription : String!
    var message : String!
    var modified : String!
    var postedBy : String!
    var profilePic : String!
    var radius : String!
    var sendMaterial : String!
    var serviceCatagory : String!
    var serviceCategory : String!
    var startDate : String!
    var status : String!
    var timeDuration : String!
    var timeSpand : String!
    var todayStatus : String!
    var urgentFill : String!
    var freelancerprofilepic : String!
    var individualprofilepic : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        appliedBy = dictionary["applied_by"] as? String
        budgetAmount = dictionary["budget_amount"] as? String
        created = dictionary["created"] as? String
        distance = dictionary["distance"] as? String
        endDate = dictionary["end_date"] as? String
        hourlyAmount = dictionary["hourly_amount"] as? String
        id = dictionary["id"] as? String
        isDeleted = dictionary["is_deleted"] as? String
        isFavourite = dictionary["is_favourite"] as? String
        isPrivate = dictionary["is_private"] as? String
        isProfessional = dictionary["is_professional"] as? String
        isPublish = dictionary["is_publish"] as? String
        isReview = dictionary["is_review"] as? String
        jobDescription = dictionary["job_description"] as? String
        jobEndDate = dictionary["job_end_date"] as? String
        jobEndTime = dictionary["job_end_time"] as? String
        jobId = dictionary["job_id"] as? String
        jobLocation = dictionary["job_location"] as? String
        jobStartDate = dictionary["job_start_date"] as? String
        jobStartTime = dictionary["job_start_time"] as? String
        jobStatus = dictionary["job_status"] as? String
        jobTitle = dictionary["job_title"] as? String
        jobType = dictionary["job_type"] as? String
        jobWorkedBy = dictionary["job_worked_by"] as? String
        joiningDate = dictionary["joining_date"] as? String
        lateComingMinutes = dictionary["late_coming_minutes"] as? String
        lateComingStatus = dictionary["late_coming_status"] as? String
        latitude = dictionary["latitude"] as? String
        longitude = dictionary["longitude"] as? String
        materialDescription = dictionary["material_description"] as? String
        message = dictionary["message"] as? String
        modified = dictionary["modified"] as? String
        postedBy = dictionary["posted_by"] as? String
        profilePic = dictionary["profile_pic"] as? String
        radius = dictionary["radius"] as? String
        sendMaterial = dictionary["send_material"] as? String
        serviceCatagory = dictionary["service_catagory"] as? String
        serviceCategory = dictionary["service_category"] as? String
        startDate = dictionary["start_date"] as? String
        status = dictionary["status"] as? String
        timeDuration = dictionary["time_duration"] as? String
        timeSpand = dictionary["time_spand"] as? String
        todayStatus = dictionary["today_status"] as? String
        urgentFill = dictionary["urgent_fill"] as? String
         freelancerprofilepic = dictionary["freelancer_profile_pic"] as? String
         individualprofilepic = dictionary["individual_profile_pic"] as? String
        
        
       
        hourlyJobTime = [ModelHourlyTime]()
        if let hourlyJobTimeArray = dictionary["hourly_job_time"] as? [[String:Any]]{
            for dic in hourlyJobTimeArray{
                let value = ModelHourlyTime(fromDictionary: dic)
                hourlyJobTime.append(value)
            }
        }
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
        if budgetAmount != nil{
            dictionary["budget_amount"] = budgetAmount
        }
        if created != nil{
            dictionary["created"] = created
        }
        if distance != nil{
            dictionary["distance"] = distance
        }
        if endDate != nil{
            dictionary["end_date"] = endDate
        }
        if hourlyAmount != nil{
            dictionary["hourly_amount"] = hourlyAmount
        }
        if id != nil{
            dictionary["id"] = id
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if isFavourite != nil{
            dictionary["is_favourite"] = isFavourite
        }
        if isPrivate != nil{
            dictionary["is_private"] = isPrivate
        }
        if isProfessional != nil{
            dictionary["is_professional"] = isProfessional
        }
        if isPublish != nil{
            dictionary["is_publish"] = isPublish
        }
        if isReview != nil{
            dictionary["is_review"] = isReview
        }
        if jobDescription != nil{
            dictionary["job_description"] = jobDescription
        }
        if jobEndDate != nil{
            dictionary["job_end_date"] = jobEndDate
        }
        if jobEndTime != nil{
            dictionary["job_end_time"] = jobEndTime
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
        if jobStartTime != nil{
            dictionary["job_start_time"] = jobStartTime
        }
        if jobStatus != nil{
            dictionary["job_status"] = jobStatus
        }
        if jobTitle != nil{
            dictionary["job_title"] = jobTitle
        }
        if jobType != nil{
            dictionary["job_type"] = jobType
        }
        if jobWorkedBy != nil{
            dictionary["job_worked_by"] = jobWorkedBy
        }
        if joiningDate != nil{
            dictionary["joining_date"] = joiningDate
        }
        if lateComingMinutes != nil{
            dictionary["late_coming_minutes"] = lateComingMinutes
        }
        if lateComingStatus != nil{
            dictionary["late_coming_status"] = lateComingStatus
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if materialDescription != nil{
            dictionary["material_description"] = materialDescription
        }
        if message != nil{
            dictionary["message"] = message
        }
        if modified != nil{
            dictionary["modified"] = modified
        }
        if postedBy != nil{
            dictionary["posted_by"] = postedBy
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if radius != nil{
            dictionary["radius"] = radius
        }
        if sendMaterial != nil{
            dictionary["send_material"] = sendMaterial
        }
        if serviceCatagory != nil{
            dictionary["service_catagory"] = serviceCatagory
        }
        if serviceCategory != nil{
            dictionary["service_category"] = serviceCategory
        }
        if startDate != nil{
            dictionary["start_date"] = startDate
        }
        if status != nil{
            dictionary["status"] = status
        }
        if timeDuration != nil{
            dictionary["time_duration"] = timeDuration
        }
        if timeSpand != nil{
            dictionary["time_spand"] = timeSpand
        }
        if todayStatus != nil{
            dictionary["today_status"] = todayStatus
        }
        if urgentFill != nil{
            dictionary["urgent_fill"] = urgentFill
        }
        if freelancerprofilepic != nil{
            dictionary["freelancer_profile_pic"] = freelancerprofilepic
        }
        if individualprofilepic != nil{
            dictionary["individual_profile_pic"] = individualprofilepic
        }
        
        
        if hourlyJobTime != nil{
            var dictionaryElements = [[String:Any]]()
            for hourlyJobTimeElement in hourlyJobTime {
                dictionaryElements.append(hourlyJobTimeElement.toDictionary())
            }
            dictionary["hourlyJobTime"] = dictionaryElements
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
        budgetAmount = aDecoder.decodeObject(forKey: "budget_amount") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        distance = aDecoder.decodeObject(forKey: "distance") as? String
        endDate = aDecoder.decodeObject(forKey: "end_date") as? String
        hourlyAmount = aDecoder.decodeObject(forKey: "hourly_amount") as? String
        hourlyJobTime = aDecoder.decodeObject(forKey: "hourly_job_time") as? [ModelHourlyTime]
        id = aDecoder.decodeObject(forKey: "id") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        isFavourite = aDecoder.decodeObject(forKey: "is_favourite") as? String
        isPrivate = aDecoder.decodeObject(forKey: "is_private") as? String
        isProfessional = aDecoder.decodeObject(forKey: "is_professional") as? String
        isPublish = aDecoder.decodeObject(forKey: "is_publish") as? String
        isReview = aDecoder.decodeObject(forKey: "is_review") as? String
        jobDescription = aDecoder.decodeObject(forKey: "job_description") as? String
        jobEndDate = aDecoder.decodeObject(forKey: "job_end_date") as? String
        jobEndTime = aDecoder.decodeObject(forKey: "job_end_time") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobLocation = aDecoder.decodeObject(forKey: "job_location") as? String
        jobStartDate = aDecoder.decodeObject(forKey: "job_start_date") as? String
        jobStartTime = aDecoder.decodeObject(forKey: "job_start_time") as? String
        jobStatus = aDecoder.decodeObject(forKey: "job_status") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        jobType = aDecoder.decodeObject(forKey: "job_type") as? String
        jobWorkedBy = aDecoder.decodeObject(forKey: "job_worked_by") as? String
        joiningDate = aDecoder.decodeObject(forKey: "joining_date") as? String
        lateComingMinutes = aDecoder.decodeObject(forKey: "late_coming_minutes") as? String
        lateComingStatus = aDecoder.decodeObject(forKey: "late_coming_status") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        materialDescription = aDecoder.decodeObject(forKey: "material_description") as? String
        message = aDecoder.decodeObject(forKey: "message") as? String
        modified = aDecoder.decodeObject(forKey: "modified") as? String
        postedBy = aDecoder.decodeObject(forKey: "posted_by") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        radius = aDecoder.decodeObject(forKey: "radius") as? String
        sendMaterial = aDecoder.decodeObject(forKey: "send_material") as? String
        serviceCatagory = aDecoder.decodeObject(forKey: "service_catagory") as? String
        serviceCategory = aDecoder.decodeObject(forKey: "service_category") as? String
        startDate = aDecoder.decodeObject(forKey: "start_date") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        timeDuration = aDecoder.decodeObject(forKey: "time_duration") as? String
        timeSpand = aDecoder.decodeObject(forKey: "time_spand") as? String
        todayStatus = aDecoder.decodeObject(forKey: "today_status") as? String
        urgentFill = aDecoder.decodeObject(forKey: "urgent_fill") as? String
        
        
        freelancerprofilepic = aDecoder.decodeObject(forKey: "freelancer_profile_pic") as? String
        individualprofilepic = aDecoder.decodeObject(forKey: "individual_profile_pic") as? String
        
        
        
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
        if budgetAmount != nil{
            aCoder.encode(budgetAmount, forKey: "budget_amount")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if distance != nil{
            aCoder.encode(distance, forKey: "distance")
        }
        if endDate != nil{
            aCoder.encode(endDate, forKey: "end_date")
        }
        if hourlyAmount != nil{
            aCoder.encode(hourlyAmount, forKey: "hourly_amount")
        }
        if hourlyJobTime != nil{
            aCoder.encode(hourlyJobTime, forKey: "hourly_job_time")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if isFavourite != nil{
            aCoder.encode(isFavourite, forKey: "is_favourite")
        }
        if isPrivate != nil{
            aCoder.encode(isPrivate, forKey: "is_private")
        }
        if isProfessional != nil{
            aCoder.encode(isProfessional, forKey: "is_professional")
        }
        if isPublish != nil{
            aCoder.encode(isPublish, forKey: "is_publish")
        }
        if isReview != nil{
            aCoder.encode(isReview, forKey: "is_review")
        }
        if jobDescription != nil{
            aCoder.encode(jobDescription, forKey: "job_description")
        }
        if jobEndDate != nil{
            aCoder.encode(jobEndDate, forKey: "job_end_date")
        }
        if jobEndTime != nil{
            aCoder.encode(jobEndTime, forKey: "job_end_time")
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
        if jobStartTime != nil{
            aCoder.encode(jobStartTime, forKey: "job_start_time")
        }
        if jobStatus != nil{
            aCoder.encode(jobStatus, forKey: "job_status")
        }
        if jobTitle != nil{
            aCoder.encode(jobTitle, forKey: "job_title")
        }
        if jobType != nil{
            aCoder.encode(jobType, forKey: "job_type")
        }
        if jobWorkedBy != nil{
            aCoder.encode(jobWorkedBy, forKey: "job_worked_by")
        }
        if joiningDate != nil{
            aCoder.encode(joiningDate, forKey: "joining_date")
        }
        if lateComingMinutes != nil{
            aCoder.encode(lateComingMinutes, forKey: "late_coming_minutes")
        }
        if lateComingStatus != nil{
            aCoder.encode(lateComingStatus, forKey: "late_coming_status")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if materialDescription != nil{
            aCoder.encode(materialDescription, forKey: "material_description")
        }
        if message != nil{
            aCoder.encode(message, forKey: "message")
        }
        if modified != nil{
            aCoder.encode(modified, forKey: "modified")
        }
        if postedBy != nil{
            aCoder.encode(postedBy, forKey: "posted_by")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if radius != nil{
            aCoder.encode(radius, forKey: "radius")
        }
        if sendMaterial != nil{
            aCoder.encode(sendMaterial, forKey: "send_material")
        }
        if serviceCatagory != nil{
            aCoder.encode(serviceCatagory, forKey: "service_catagory")
        }
        if serviceCategory != nil{
            aCoder.encode(serviceCategory, forKey: "service_category")
        }
        if startDate != nil{
            aCoder.encode(startDate, forKey: "start_date")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if timeDuration != nil{
            aCoder.encode(timeDuration, forKey: "time_duration")
        }
        if timeSpand != nil{
            aCoder.encode(timeSpand, forKey: "time_spand")
        }
        if todayStatus != nil{
            aCoder.encode(todayStatus, forKey: "today_status")
        }
        if urgentFill != nil{
            aCoder.encode(urgentFill, forKey: "urgent_fill")
        }
        if freelancerprofilepic != nil{
            aCoder.encode(freelancerprofilepic, forKey: "freelancer_profile_pic")
        }
        if individualprofilepic != nil{
            aCoder.encode(individualprofilepic, forKey: "individual_profile_pic")
        }
        
        
    }
}
class ModelHourlyTime : NSObject, NSCoding{

    var created : String!
    var date : String!
    var endTime : String!
    var id : String!
    var jobId : String!
    var jobStatus : String!
    var lateComingMinutes : String!
    var lateComingStatus : String!
    var startTime : String!
    var timeDuration : String!
    var timeSpand : String!
    var userId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        created = dictionary["created"] as? String
        date = dictionary["date"] as? String
        endTime = dictionary["end_time"] as? String
        id = dictionary["id"] as? String
        jobId = dictionary["job_id"] as? String
        jobStatus = dictionary["job_status"] as? String
        lateComingMinutes = dictionary["late_coming_minutes"] as? String
        lateComingStatus = dictionary["late_coming_status"] as? String
        startTime = dictionary["start_time"] as? String
        timeDuration = dictionary["time_duration"] as? String
        timeSpand = dictionary["time_spand"] as? String
        userId = dictionary["user_id"] as? String
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
        if date != nil{
            dictionary["date"] = date
        }
        if endTime != nil{
            dictionary["end_time"] = endTime
        }
        if id != nil{
            dictionary["id"] = id
        }
        if jobId != nil{
            dictionary["job_id"] = jobId
        }
        if jobStatus != nil{
            dictionary["job_status"] = jobStatus
        }
        if lateComingMinutes != nil{
            dictionary["late_coming_minutes"] = lateComingMinutes
        }
        if lateComingStatus != nil{
            dictionary["late_coming_status"] = lateComingStatus
        }
        if startTime != nil{
            dictionary["start_time"] = startTime
        }
        if timeDuration != nil{
            dictionary["time_duration"] = timeDuration
        }
        if timeSpand != nil{
            dictionary["time_spand"] = timeSpand
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
        created = aDecoder.decodeObject(forKey: "created") as? String
        date = aDecoder.decodeObject(forKey: "date") as? String
        endTime = aDecoder.decodeObject(forKey: "end_time") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobStatus = aDecoder.decodeObject(forKey: "job_status") as? String
        lateComingMinutes = aDecoder.decodeObject(forKey: "late_coming_minutes") as? String
        lateComingStatus = aDecoder.decodeObject(forKey: "late_coming_status") as? String
        startTime = aDecoder.decodeObject(forKey: "start_time") as? String
        timeDuration = aDecoder.decodeObject(forKey: "time_duration") as? String
        timeSpand = aDecoder.decodeObject(forKey: "time_spand") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
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
        if date != nil{
            aCoder.encode(date, forKey: "date")
        }
        if endTime != nil{
            aCoder.encode(endTime, forKey: "end_time")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if jobId != nil{
            aCoder.encode(jobId, forKey: "job_id")
        }
        if jobStatus != nil{
            aCoder.encode(jobStatus, forKey: "job_status")
        }
        if lateComingMinutes != nil{
            aCoder.encode(lateComingMinutes, forKey: "late_coming_minutes")
        }
        if lateComingStatus != nil{
            aCoder.encode(lateComingStatus, forKey: "late_coming_status")
        }
        if startTime != nil{
            aCoder.encode(startTime, forKey: "start_time")
        }
        if timeDuration != nil{
            aCoder.encode(timeDuration, forKey: "time_duration")
        }
        if timeSpand != nil{
            aCoder.encode(timeSpand, forKey: "time_spand")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
    }
}
