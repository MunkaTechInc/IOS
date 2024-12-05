//
//  ModelPaymentInfo.swift
//  Munka
//
//  Created by Amit on 10/12/19.
//  Copyright © 2019 Amit. All rights reserved.
//

import Foundation



class ModelPaymentInfo : NSObject, NSCoding{

    var details : ModelPaymentInfoDetail!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        if let detailsData = dictionary["details"] as? [String:Any]{
            details = ModelPaymentInfoDetail(fromDictionary: detailsData)
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
        details = aDecoder.decodeObject(forKey: "details") as? ModelPaymentInfoDetail
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



class ModelPaymentInfoDetail : NSObject, NSCoding{

    var actionBy : String!
    var budgetAmount : String!
    var contractId : String!
    var created : String!
    var freelancerGet : String!
    var freelancerId : String!
    var freelancerJoiningDate : String!
    var freelancerName : String!
    var freelancerPenalty : String!
    var freelancerProfilePic : String!
    var id : String!
    var individualId : String!
    var individualJoiningDate : String!
    var individualName : String!
    var individualProfilePic : String!
    var indivisibleGet : String!
    var indivisiblePenalty : String!
    var jobEndDate : String!
    var jobId : String!
    var jobStartDate : String!
    var jobTitle : String!
    var mFreelancerId : String!
    var mIndividualId : String!
    var modified : String!
    var paidBy : String!
    var penaltyType : String!
    var status : String!
    var systemCharges : String!
    var transactionId : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        actionBy = dictionary["action_by"] as? String
        budgetAmount = dictionary["budget_amount"] as? String
        contractId = dictionary["contract_id"] as? String
        created = dictionary["created"] as? String
        freelancerGet = dictionary["freelancer_get"] as? String
        freelancerId = dictionary["freelancer_id"] as? String
        freelancerJoiningDate = dictionary["freelancer_joining_date"] as? String
        freelancerName = dictionary["freelancer_name"] as? String
        freelancerPenalty = dictionary["freelancer_penalty"] as? String
        freelancerProfilePic = dictionary["freelancer_profile_pic"] as? String
        id = dictionary["id"] as? String
        individualId = dictionary["individual_id"] as? String
        individualJoiningDate = dictionary["individual_joining_date"] as? String
        individualName = dictionary["individual_name"] as? String
        individualProfilePic = dictionary["individual_profile_pic"] as? String
        indivisibleGet = dictionary["indivisible_get"] as? String
        indivisiblePenalty = dictionary["indivisible_penalty"] as? String
        jobEndDate = dictionary["job_end_date"] as? String
        jobId = dictionary["job_id"] as? String
        jobStartDate = dictionary["job_start_date"] as? String
        jobTitle = dictionary["job_title"] as? String
        mFreelancerId = dictionary["m_freelancer_id"] as? String
        mIndividualId = dictionary["m_individual_id"] as? String
        modified = dictionary["modified"] as? String
        paidBy = dictionary["paid_by"] as? String
        penaltyType = dictionary["penalty_type"] as? String
        status = dictionary["status"] as? String
        systemCharges = dictionary["system_charges"] as? String
        transactionId = dictionary["transaction_id"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if actionBy != nil{
            dictionary["action_by"] = actionBy
        }
        if budgetAmount != nil{
            dictionary["budget_amount"] = budgetAmount
        }
        if contractId != nil{
            dictionary["contract_id"] = contractId
        }
        if created != nil{
            dictionary["created"] = created
        }
        if freelancerGet != nil{
            dictionary["freelancer_get"] = freelancerGet
        }
        if freelancerId != nil{
            dictionary["freelancer_id"] = freelancerId
        }
        if freelancerJoiningDate != nil{
            dictionary["freelancer_joining_date"] = freelancerJoiningDate
        }
        if freelancerName != nil{
            dictionary["freelancer_name"] = freelancerName
        }
        if freelancerPenalty != nil{
            dictionary["freelancer_penalty"] = freelancerPenalty
        }
        if freelancerProfilePic != nil{
            dictionary["freelancer_profile_pic"] = freelancerProfilePic
        }
        if id != nil{
            dictionary["id"] = id
        }
        if individualId != nil{
            dictionary["individual_id"] = individualId
        }
        if individualJoiningDate != nil{
            dictionary["individual_joining_date"] = individualJoiningDate
        }
        if individualName != nil{
            dictionary["individual_name"] = individualName
        }
        if individualProfilePic != nil{
            dictionary["individual_profile_pic"] = individualProfilePic
        }
        if indivisibleGet != nil{
            dictionary["indivisible_get"] = indivisibleGet
        }
        if indivisiblePenalty != nil{
            dictionary["indivisible_penalty"] = indivisiblePenalty
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
        if mFreelancerId != nil{
            dictionary["m_freelancer_id"] = mFreelancerId
        }
        if mIndividualId != nil{
            dictionary["m_individual_id"] = mIndividualId
        }
        if modified != nil{
            dictionary["modified"] = modified
        }
        if paidBy != nil{
            dictionary["paid_by"] = paidBy
        }
        if penaltyType != nil{
            dictionary["penalty_type"] = penaltyType
        }
        if status != nil{
            dictionary["status"] = status
        }
        if systemCharges != nil{
            dictionary["system_charges"] = systemCharges
        }
        if transactionId != nil{
            dictionary["transaction_id"] = transactionId
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        actionBy = aDecoder.decodeObject(forKey: "action_by") as? String
        budgetAmount = aDecoder.decodeObject(forKey: "budget_amount") as? String
        contractId = aDecoder.decodeObject(forKey: "contract_id") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        freelancerGet = aDecoder.decodeObject(forKey: "freelancer_get") as? String
        freelancerId = aDecoder.decodeObject(forKey: "freelancer_id") as? String
        freelancerJoiningDate = aDecoder.decodeObject(forKey: "freelancer_joining_date") as? String
        freelancerName = aDecoder.decodeObject(forKey: "freelancer_name") as? String
        freelancerPenalty = aDecoder.decodeObject(forKey: "freelancer_penalty") as? String
        freelancerProfilePic = aDecoder.decodeObject(forKey: "freelancer_profile_pic") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        individualId = aDecoder.decodeObject(forKey: "individual_id") as? String
        individualJoiningDate = aDecoder.decodeObject(forKey: "individual_joining_date") as? String
        individualName = aDecoder.decodeObject(forKey: "individual_name") as? String
        individualProfilePic = aDecoder.decodeObject(forKey: "individual_profile_pic") as? String
        indivisibleGet = aDecoder.decodeObject(forKey: "indivisible_get") as? String
        indivisiblePenalty = aDecoder.decodeObject(forKey: "indivisible_penalty") as? String
        jobEndDate = aDecoder.decodeObject(forKey: "job_end_date") as? String
        jobId = aDecoder.decodeObject(forKey: "job_id") as? String
        jobStartDate = aDecoder.decodeObject(forKey: "job_start_date") as? String
        jobTitle = aDecoder.decodeObject(forKey: "job_title") as? String
        mFreelancerId = aDecoder.decodeObject(forKey: "m_freelancer_id") as? String
        mIndividualId = aDecoder.decodeObject(forKey: "m_individual_id") as? String
        modified = aDecoder.decodeObject(forKey: "modified") as? String
        paidBy = aDecoder.decodeObject(forKey: "paid_by") as? String
        penaltyType = aDecoder.decodeObject(forKey: "penalty_type") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        systemCharges = aDecoder.decodeObject(forKey: "system_charges") as? String
        transactionId = aDecoder.decodeObject(forKey: "transaction_id") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if actionBy != nil{
            aCoder.encode(actionBy, forKey: "action_by")
        }
        if budgetAmount != nil{
            aCoder.encode(budgetAmount, forKey: "budget_amount")
        }
        if contractId != nil{
            aCoder.encode(contractId, forKey: "contract_id")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if freelancerGet != nil{
            aCoder.encode(freelancerGet, forKey: "freelancer_get")
        }
        if freelancerId != nil{
            aCoder.encode(freelancerId, forKey: "freelancer_id")
        }
        if freelancerJoiningDate != nil{
            aCoder.encode(freelancerJoiningDate, forKey: "freelancer_joining_date")
        }
        if freelancerName != nil{
            aCoder.encode(freelancerName, forKey: "freelancer_name")
        }
        if freelancerPenalty != nil{
            aCoder.encode(freelancerPenalty, forKey: "freelancer_penalty")
        }
        if freelancerProfilePic != nil{
            aCoder.encode(freelancerProfilePic, forKey: "freelancer_profile_pic")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if individualId != nil{
            aCoder.encode(individualId, forKey: "individual_id")
        }
        if individualJoiningDate != nil{
            aCoder.encode(individualJoiningDate, forKey: "individual_joining_date")
        }
        if individualName != nil{
            aCoder.encode(individualName, forKey: "individual_name")
        }
        if individualProfilePic != nil{
            aCoder.encode(individualProfilePic, forKey: "individual_profile_pic")
        }
        if indivisibleGet != nil{
            aCoder.encode(indivisibleGet, forKey: "indivisible_get")
        }
        if indivisiblePenalty != nil{
            aCoder.encode(indivisiblePenalty, forKey: "indivisible_penalty")
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
        if mFreelancerId != nil{
            aCoder.encode(mFreelancerId, forKey: "m_freelancer_id")
        }
        if mIndividualId != nil{
            aCoder.encode(mIndividualId, forKey: "m_individual_id")
        }
        if modified != nil{
            aCoder.encode(modified, forKey: "modified")
        }
        if paidBy != nil{
            aCoder.encode(paidBy, forKey: "paid_by")
        }
        if penaltyType != nil{
            aCoder.encode(penaltyType, forKey: "penalty_type")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if systemCharges != nil{
            aCoder.encode(systemCharges, forKey: "system_charges")
        }
        if transactionId != nil{
            aCoder.encode(transactionId, forKey: "transaction_id")
        }
    }
}
