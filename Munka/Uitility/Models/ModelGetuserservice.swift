//
//  ModelGetuserservice.swift
//  Munka
//
//  Created by Amit on 05/05/20.
//  Copyright © 2020 Amit. All rights reserved.
//

import Foundation



class ModelGetuserservice : NSObject, NSCoding{

    var details : ModelServiceDetail!
    var msg : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        msg = dictionary["msg"] as? String
        status = dictionary["status"] as? String
        if let detailsData = dictionary["details"] as? [String:Any]{
            details = ModelServiceDetail(fromDictionary: detailsData)
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
        details = aDecoder.decodeObject(forKey: "details") as? ModelServiceDetail
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
class ModelServiceDetail : NSObject, NSCoding{

    var aboutUs : String!
    var accessPin : String!
    var address : String!
    var appStatusExpiryDate : AnyObject!
    var badgeCount : String!
    var businessAddress : String!
    var businessLatitude : String!
    var businessLongitude : String!
    var businessName : String!
    var chatStatus : String!
    var city : String!
    var cityId : String!
    var completeJob : Int!
    var country : String!
    var countryCode : String!
    var countryId : String!
    var created : String!
    var deviceId : String!
    var deviceType : String!
    var docStatus : String!
    var document : String!
    var email : String!
    var emailVerificationToken : String!
    var emailVerificationTokenDate : String!
    var emailVerified : String!
    var expiryDate : AnyObject!
    var fbId : String!
    var firstName : String!
    var freelancerPlus : String!
    var googleId : String!
    var isDeleted : String!
    var isProfessional : String!
    var lastName : String!
    var latitude : String!
    var llcNumber : String!
    var loginType : String!
    var longitude : String!
    var mobile : String!
    var mobileAuthToken : String!
    var mobileVerificationToken : String!
    var mobileVerificationTokenDate : String!
    var mobileVerified : String!
    var modified : String!
    var password : String!
    var paypalId : String!
    var professionalProof : String!
    var profilePic : String!
    var profileType : String!
    var publishAppStatus : String!
    var rating : String!
    var referralCode : String!
    var resetToken : String!
    var resetTokenDate : String!
    var resume : String!
    var reviewStatus : String!
    var reviewStatusCount : String!
    var sendNotification : String!
    var serviceArea : AnyObject!
    var serviceCategory : [ModelServiceCategory]!
    var serviceDescription : AnyObject!
    var ssnNumber : String!
    var state : String!
    var stateId : String!
    var status : String!
    var taxId : String!
    var totalReview : String!
    var unreadNotification : AnyObject!
    var upcomingJob : Int!
    var userChatId : String!
    var userId : String!
    var userType : String!
    var verifiedFreelancer : String!
    var walletAmount : String!
    var zipCode : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        aboutUs = dictionary["about_us"] as? String
        accessPin = dictionary["access_pin"] as? String
        address = dictionary["address"] as? String
        appStatusExpiryDate = dictionary["app_status_expiry_date"] as? AnyObject
        badgeCount = dictionary["badge_count"] as? String
        businessAddress = dictionary["business_address"] as? String
        businessLatitude = dictionary["business_latitude"] as? String
        businessLongitude = dictionary["business_longitude"] as? String
        businessName = dictionary["business_name"] as? String
        chatStatus = dictionary["chat_status"] as? String
        city = dictionary["city"] as? String
        cityId = dictionary["city_id"] as? String
        completeJob = dictionary["complete_job"] as? Int
        country = dictionary["country"] as? String
        countryCode = dictionary["country_code"] as? String
        countryId = dictionary["country_id"] as? String
        created = dictionary["created"] as? String
        deviceId = dictionary["device_id"] as? String
        deviceType = dictionary["device_type"] as? String
        docStatus = dictionary["doc_status"] as? String
        document = dictionary["document"] as? String
        email = dictionary["email"] as? String
        emailVerificationToken = dictionary["email_verification_token"] as? String
        emailVerificationTokenDate = dictionary["email_verification_token_date"] as? String
        emailVerified = dictionary["email_verified"] as? String
        expiryDate = dictionary["expiry_date"] as? AnyObject
        fbId = dictionary["fb_id"] as? String
        firstName = dictionary["first_name"] as? String
        freelancerPlus = dictionary["freelancer_plus"] as? String
        googleId = dictionary["google_id"] as? String
        isDeleted = dictionary["is_deleted"] as? String
        isProfessional = dictionary["is_professional"] as? String
        lastName = dictionary["last_name"] as? String
        latitude = dictionary["latitude"] as? String
        llcNumber = dictionary["llc_number"] as? String
        loginType = dictionary["login_type"] as? String
        longitude = dictionary["longitude"] as? String
        mobile = dictionary["mobile"] as? String
        mobileAuthToken = dictionary["mobile_auth_token"] as? String
        mobileVerificationToken = dictionary["mobile_verification_token"] as? String
        mobileVerificationTokenDate = dictionary["mobile_verification_token_date"] as? String
        mobileVerified = dictionary["mobile_verified"] as? String
        modified = dictionary["modified"] as? String
        password = dictionary["password"] as? String
        paypalId = dictionary["paypal_id"] as? String
        professionalProof = dictionary["professional_proof"] as? String
        profilePic = dictionary["profile_pic"] as? String
        profileType = dictionary["profile_type"] as? String
        publishAppStatus = dictionary["publish_app_status"] as? String
        rating = dictionary["rating"] as? String
        referralCode = dictionary["referral_code"] as? String
        resetToken = dictionary["reset_token"] as? String
        resetTokenDate = dictionary["reset_token_date"] as? String
        resume = dictionary["resume"] as? String
        reviewStatus = dictionary["review_status"] as? String
        reviewStatusCount = dictionary["review_status_count"] as? String
        sendNotification = dictionary["send_notification"] as? String
        serviceArea = dictionary["service_area"] as? AnyObject
        serviceDescription = dictionary["service_description"] as? AnyObject
        ssnNumber = dictionary["ssn_number"] as? String
        state = dictionary["state"] as? String
        stateId = dictionary["state_id"] as? String
        status = dictionary["status"] as? String
        taxId = dictionary["tax_id"] as? String
        totalReview = dictionary["total_review"] as? String
        unreadNotification = dictionary["unread_notification"] as? AnyObject
        upcomingJob = dictionary["upcoming_job"] as? Int
        userChatId = dictionary["user_chat_id"] as? String
        userId = dictionary["user_id"] as? String
        userType = dictionary["user_type"] as? String
        verifiedFreelancer = dictionary["verified_freelancer"] as? String
        walletAmount = dictionary["wallet_amount"] as? String
        zipCode = dictionary["zip_code"] as? String
        serviceCategory = [ModelServiceCategory]()
        if let serviceCategoryArray = dictionary["service_category"] as? [[String:Any]]{
            for dic in serviceCategoryArray{
                let value = ModelServiceCategory(fromDictionary: dic)
                serviceCategory.append(value)
            }
        }
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if aboutUs != nil{
            dictionary["about_us"] = aboutUs
        }
        if accessPin != nil{
            dictionary["access_pin"] = accessPin
        }
        if address != nil{
            dictionary["address"] = address
        }
        if appStatusExpiryDate != nil{
            dictionary["app_status_expiry_date"] = appStatusExpiryDate
        }
        if badgeCount != nil{
            dictionary["badge_count"] = badgeCount
        }
        if businessAddress != nil{
            dictionary["business_address"] = businessAddress
        }
        if businessLatitude != nil{
            dictionary["business_latitude"] = businessLatitude
        }
        if businessLongitude != nil{
            dictionary["business_longitude"] = businessLongitude
        }
        if businessName != nil{
            dictionary["business_name"] = businessName
        }
        if chatStatus != nil{
            dictionary["chat_status"] = chatStatus
        }
        if city != nil{
            dictionary["city"] = city
        }
        if cityId != nil{
            dictionary["city_id"] = cityId
        }
        if completeJob != nil{
            dictionary["complete_job"] = completeJob
        }
        if country != nil{
            dictionary["country"] = country
        }
        if countryCode != nil{
            dictionary["country_code"] = countryCode
        }
        if countryId != nil{
            dictionary["country_id"] = countryId
        }
        if created != nil{
            dictionary["created"] = created
        }
        if deviceId != nil{
            dictionary["device_id"] = deviceId
        }
        if deviceType != nil{
            dictionary["device_type"] = deviceType
        }
        if docStatus != nil{
            dictionary["doc_status"] = docStatus
        }
        if document != nil{
            dictionary["document"] = document
        }
        if email != nil{
            dictionary["email"] = email
        }
        if emailVerificationToken != nil{
            dictionary["email_verification_token"] = emailVerificationToken
        }
        if emailVerificationTokenDate != nil{
            dictionary["email_verification_token_date"] = emailVerificationTokenDate
        }
        if emailVerified != nil{
            dictionary["email_verified"] = emailVerified
        }
        if expiryDate != nil{
            dictionary["expiry_date"] = expiryDate
        }
        if fbId != nil{
            dictionary["fb_id"] = fbId
        }
        if firstName != nil{
            dictionary["first_name"] = firstName
        }
        if freelancerPlus != nil{
            dictionary["freelancer_plus"] = freelancerPlus
        }
        if googleId != nil{
            dictionary["google_id"] = googleId
        }
        if isDeleted != nil{
            dictionary["is_deleted"] = isDeleted
        }
        if isProfessional != nil{
            dictionary["is_professional"] = isProfessional
        }
        if lastName != nil{
            dictionary["last_name"] = lastName
        }
        if latitude != nil{
            dictionary["latitude"] = latitude
        }
        if llcNumber != nil{
            dictionary["llc_number"] = llcNumber
        }
        if loginType != nil{
            dictionary["login_type"] = loginType
        }
        if longitude != nil{
            dictionary["longitude"] = longitude
        }
        if mobile != nil{
            dictionary["mobile"] = mobile
        }
        if mobileAuthToken != nil{
            dictionary["mobile_auth_token"] = mobileAuthToken
        }
        if mobileVerificationToken != nil{
            dictionary["mobile_verification_token"] = mobileVerificationToken
        }
        if mobileVerificationTokenDate != nil{
            dictionary["mobile_verification_token_date"] = mobileVerificationTokenDate
        }
        if mobileVerified != nil{
            dictionary["mobile_verified"] = mobileVerified
        }
        if modified != nil{
            dictionary["modified"] = modified
        }
        if password != nil{
            dictionary["password"] = password
        }
        if paypalId != nil{
            dictionary["paypal_id"] = paypalId
        }
        if professionalProof != nil{
            dictionary["professional_proof"] = professionalProof
        }
        if profilePic != nil{
            dictionary["profile_pic"] = profilePic
        }
        if profileType != nil{
            dictionary["profile_type"] = profileType
        }
        if publishAppStatus != nil{
            dictionary["publish_app_status"] = publishAppStatus
        }
        if rating != nil{
            dictionary["rating"] = rating
        }
        if referralCode != nil{
            dictionary["referral_code"] = referralCode
        }
        if resetToken != nil{
            dictionary["reset_token"] = resetToken
        }
        if resetTokenDate != nil{
            dictionary["reset_token_date"] = resetTokenDate
        }
        if resume != nil{
            dictionary["resume"] = resume
        }
        if reviewStatus != nil{
            dictionary["review_status"] = reviewStatus
        }
        if reviewStatusCount != nil{
            dictionary["review_status_count"] = reviewStatusCount
        }
        if sendNotification != nil{
            dictionary["send_notification"] = sendNotification
        }
        if serviceArea != nil{
            dictionary["service_area"] = serviceArea
        }
        if serviceDescription != nil{
            dictionary["service_description"] = serviceDescription
        }
        if ssnNumber != nil{
            dictionary["ssn_number"] = ssnNumber
        }
        if state != nil{
            dictionary["state"] = state
        }
        if stateId != nil{
            dictionary["state_id"] = stateId
        }
        if status != nil{
            dictionary["status"] = status
        }
        if taxId != nil{
            dictionary["tax_id"] = taxId
        }
        if totalReview != nil{
            dictionary["total_review"] = totalReview
        }
        if unreadNotification != nil{
            dictionary["unread_notification"] = unreadNotification
        }
        if upcomingJob != nil{
            dictionary["upcoming_job"] = upcomingJob
        }
        if userChatId != nil{
            dictionary["user_chat_id"] = userChatId
        }
        if userId != nil{
            dictionary["user_id"] = userId
        }
        if userType != nil{
            dictionary["user_type"] = userType
        }
        if verifiedFreelancer != nil{
            dictionary["verified_freelancer"] = verifiedFreelancer
        }
        if walletAmount != nil{
            dictionary["wallet_amount"] = walletAmount
        }
        if zipCode != nil{
            dictionary["zip_code"] = zipCode
        }
        if serviceCategory != nil{
            var dictionaryElements = [[String:Any]]()
            for serviceCategoryElement in serviceCategory {
                dictionaryElements.append(serviceCategoryElement.toDictionary())
            }
            dictionary["serviceCategory"] = dictionaryElements
        }
        return dictionary
    }

    /**
     * NSCoding required initializer.
     * Fills the data from the passed decoder
     */
    @objc required init(coder aDecoder: NSCoder)
    {
        aboutUs = aDecoder.decodeObject(forKey: "about_us") as? String
        accessPin = aDecoder.decodeObject(forKey: "access_pin") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        appStatusExpiryDate = aDecoder.decodeObject(forKey: "app_status_expiry_date") as? AnyObject
        badgeCount = aDecoder.decodeObject(forKey: "badge_count") as? String
        businessAddress = aDecoder.decodeObject(forKey: "business_address") as? String
        businessLatitude = aDecoder.decodeObject(forKey: "business_latitude") as? String
        businessLongitude = aDecoder.decodeObject(forKey: "business_longitude") as? String
        businessName = aDecoder.decodeObject(forKey: "business_name") as? String
        chatStatus = aDecoder.decodeObject(forKey: "chat_status") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        cityId = aDecoder.decodeObject(forKey: "city_id") as? String
        completeJob = aDecoder.decodeObject(forKey: "complete_job") as? Int
        country = aDecoder.decodeObject(forKey: "country") as? String
        countryCode = aDecoder.decodeObject(forKey: "country_code") as? String
        countryId = aDecoder.decodeObject(forKey: "country_id") as? String
        created = aDecoder.decodeObject(forKey: "created") as? String
        deviceId = aDecoder.decodeObject(forKey: "device_id") as? String
        deviceType = aDecoder.decodeObject(forKey: "device_type") as? String
        docStatus = aDecoder.decodeObject(forKey: "doc_status") as? String
        document = aDecoder.decodeObject(forKey: "document") as? String
        email = aDecoder.decodeObject(forKey: "email") as? String
        emailVerificationToken = aDecoder.decodeObject(forKey: "email_verification_token") as? String
        emailVerificationTokenDate = aDecoder.decodeObject(forKey: "email_verification_token_date") as? String
        emailVerified = aDecoder.decodeObject(forKey: "email_verified") as? String
        expiryDate = aDecoder.decodeObject(forKey: "expiry_date") as? AnyObject
        fbId = aDecoder.decodeObject(forKey: "fb_id") as? String
        firstName = aDecoder.decodeObject(forKey: "first_name") as? String
        freelancerPlus = aDecoder.decodeObject(forKey: "freelancer_plus") as? String
        googleId = aDecoder.decodeObject(forKey: "google_id") as? String
        isDeleted = aDecoder.decodeObject(forKey: "is_deleted") as? String
        isProfessional = aDecoder.decodeObject(forKey: "is_professional") as? String
        lastName = aDecoder.decodeObject(forKey: "last_name") as? String
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        llcNumber = aDecoder.decodeObject(forKey: "llc_number") as? String
        loginType = aDecoder.decodeObject(forKey: "login_type") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        mobileAuthToken = aDecoder.decodeObject(forKey: "mobile_auth_token") as? String
        mobileVerificationToken = aDecoder.decodeObject(forKey: "mobile_verification_token") as? String
        mobileVerificationTokenDate = aDecoder.decodeObject(forKey: "mobile_verification_token_date") as? String
        mobileVerified = aDecoder.decodeObject(forKey: "mobile_verified") as? String
        modified = aDecoder.decodeObject(forKey: "modified") as? String
        password = aDecoder.decodeObject(forKey: "password") as? String
        paypalId = aDecoder.decodeObject(forKey: "paypal_id") as? String
        professionalProof = aDecoder.decodeObject(forKey: "professional_proof") as? String
        profilePic = aDecoder.decodeObject(forKey: "profile_pic") as? String
        profileType = aDecoder.decodeObject(forKey: "profile_type") as? String
        publishAppStatus = aDecoder.decodeObject(forKey: "publish_app_status") as? String
        rating = aDecoder.decodeObject(forKey: "rating") as? String
        referralCode = aDecoder.decodeObject(forKey: "referral_code") as? String
        resetToken = aDecoder.decodeObject(forKey: "reset_token") as? String
        resetTokenDate = aDecoder.decodeObject(forKey: "reset_token_date") as? String
        resume = aDecoder.decodeObject(forKey: "resume") as? String
        reviewStatus = aDecoder.decodeObject(forKey: "review_status") as? String
        reviewStatusCount = aDecoder.decodeObject(forKey: "review_status_count") as? String
        sendNotification = aDecoder.decodeObject(forKey: "send_notification") as? String
        serviceArea = aDecoder.decodeObject(forKey: "service_area") as? AnyObject
        serviceCategory = aDecoder.decodeObject(forKey: "service_category") as? [ModelServiceCategory]
        serviceDescription = aDecoder.decodeObject(forKey: "service_description") as? AnyObject
        ssnNumber = aDecoder.decodeObject(forKey: "ssn_number") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        stateId = aDecoder.decodeObject(forKey: "state_id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
        taxId = aDecoder.decodeObject(forKey: "tax_id") as? String
        totalReview = aDecoder.decodeObject(forKey: "total_review") as? String
        unreadNotification = aDecoder.decodeObject(forKey: "unread_notification") as? AnyObject
        upcomingJob = aDecoder.decodeObject(forKey: "upcoming_job") as? Int
        userChatId = aDecoder.decodeObject(forKey: "user_chat_id") as? String
        userId = aDecoder.decodeObject(forKey: "user_id") as? String
        userType = aDecoder.decodeObject(forKey: "user_type") as? String
        verifiedFreelancer = aDecoder.decodeObject(forKey: "verified_freelancer") as? String
        walletAmount = aDecoder.decodeObject(forKey: "wallet_amount") as? String
        zipCode = aDecoder.decodeObject(forKey: "zip_code") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if aboutUs != nil{
            aCoder.encode(aboutUs, forKey: "about_us")
        }
        if accessPin != nil{
            aCoder.encode(accessPin, forKey: "access_pin")
        }
        if address != nil{
            aCoder.encode(address, forKey: "address")
        }
        if appStatusExpiryDate != nil{
            aCoder.encode(appStatusExpiryDate, forKey: "app_status_expiry_date")
        }
        if badgeCount != nil{
            aCoder.encode(badgeCount, forKey: "badge_count")
        }
        if businessAddress != nil{
            aCoder.encode(businessAddress, forKey: "business_address")
        }
        if businessLatitude != nil{
            aCoder.encode(businessLatitude, forKey: "business_latitude")
        }
        if businessLongitude != nil{
            aCoder.encode(businessLongitude, forKey: "business_longitude")
        }
        if businessName != nil{
            aCoder.encode(businessName, forKey: "business_name")
        }
        if chatStatus != nil{
            aCoder.encode(chatStatus, forKey: "chat_status")
        }
        if city != nil{
            aCoder.encode(city, forKey: "city")
        }
        if cityId != nil{
            aCoder.encode(cityId, forKey: "city_id")
        }
        if completeJob != nil{
            aCoder.encode(completeJob, forKey: "complete_job")
        }
        if country != nil{
            aCoder.encode(country, forKey: "country")
        }
        if countryCode != nil{
            aCoder.encode(countryCode, forKey: "country_code")
        }
        if countryId != nil{
            aCoder.encode(countryId, forKey: "country_id")
        }
        if created != nil{
            aCoder.encode(created, forKey: "created")
        }
        if deviceId != nil{
            aCoder.encode(deviceId, forKey: "device_id")
        }
        if deviceType != nil{
            aCoder.encode(deviceType, forKey: "device_type")
        }
        if docStatus != nil{
            aCoder.encode(docStatus, forKey: "doc_status")
        }
        if document != nil{
            aCoder.encode(document, forKey: "document")
        }
        if email != nil{
            aCoder.encode(email, forKey: "email")
        }
        if emailVerificationToken != nil{
            aCoder.encode(emailVerificationToken, forKey: "email_verification_token")
        }
        if emailVerificationTokenDate != nil{
            aCoder.encode(emailVerificationTokenDate, forKey: "email_verification_token_date")
        }
        if emailVerified != nil{
            aCoder.encode(emailVerified, forKey: "email_verified")
        }
        if expiryDate != nil{
            aCoder.encode(expiryDate, forKey: "expiry_date")
        }
        if fbId != nil{
            aCoder.encode(fbId, forKey: "fb_id")
        }
        if firstName != nil{
            aCoder.encode(firstName, forKey: "first_name")
        }
        if freelancerPlus != nil{
            aCoder.encode(freelancerPlus, forKey: "freelancer_plus")
        }
        if googleId != nil{
            aCoder.encode(googleId, forKey: "google_id")
        }
        if isDeleted != nil{
            aCoder.encode(isDeleted, forKey: "is_deleted")
        }
        if isProfessional != nil{
            aCoder.encode(isProfessional, forKey: "is_professional")
        }
        if lastName != nil{
            aCoder.encode(lastName, forKey: "last_name")
        }
        if latitude != nil{
            aCoder.encode(latitude, forKey: "latitude")
        }
        if llcNumber != nil{
            aCoder.encode(llcNumber, forKey: "llc_number")
        }
        if loginType != nil{
            aCoder.encode(loginType, forKey: "login_type")
        }
        if longitude != nil{
            aCoder.encode(longitude, forKey: "longitude")
        }
        if mobile != nil{
            aCoder.encode(mobile, forKey: "mobile")
        }
        if mobileAuthToken != nil{
            aCoder.encode(mobileAuthToken, forKey: "mobile_auth_token")
        }
        if mobileVerificationToken != nil{
            aCoder.encode(mobileVerificationToken, forKey: "mobile_verification_token")
        }
        if mobileVerificationTokenDate != nil{
            aCoder.encode(mobileVerificationTokenDate, forKey: "mobile_verification_token_date")
        }
        if mobileVerified != nil{
            aCoder.encode(mobileVerified, forKey: "mobile_verified")
        }
        if modified != nil{
            aCoder.encode(modified, forKey: "modified")
        }
        if password != nil{
            aCoder.encode(password, forKey: "password")
        }
        if paypalId != nil{
            aCoder.encode(paypalId, forKey: "paypal_id")
        }
        if professionalProof != nil{
            aCoder.encode(professionalProof, forKey: "professional_proof")
        }
        if profilePic != nil{
            aCoder.encode(profilePic, forKey: "profile_pic")
        }
        if profileType != nil{
            aCoder.encode(profileType, forKey: "profile_type")
        }
        if publishAppStatus != nil{
            aCoder.encode(publishAppStatus, forKey: "publish_app_status")
        }
        if rating != nil{
            aCoder.encode(rating, forKey: "rating")
        }
        if referralCode != nil{
            aCoder.encode(referralCode, forKey: "referral_code")
        }
        if resetToken != nil{
            aCoder.encode(resetToken, forKey: "reset_token")
        }
        if resetTokenDate != nil{
            aCoder.encode(resetTokenDate, forKey: "reset_token_date")
        }
        if resume != nil{
            aCoder.encode(resume, forKey: "resume")
        }
        if reviewStatus != nil{
            aCoder.encode(reviewStatus, forKey: "review_status")
        }
        if reviewStatusCount != nil{
            aCoder.encode(reviewStatusCount, forKey: "review_status_count")
        }
        if sendNotification != nil{
            aCoder.encode(sendNotification, forKey: "send_notification")
        }
        if serviceArea != nil{
            aCoder.encode(serviceArea, forKey: "service_area")
        }
        if serviceCategory != nil{
            aCoder.encode(serviceCategory, forKey: "service_category")
        }
        if serviceDescription != nil{
            aCoder.encode(serviceDescription, forKey: "service_description")
        }
        if ssnNumber != nil{
            aCoder.encode(ssnNumber, forKey: "ssn_number")
        }
        if state != nil{
            aCoder.encode(state, forKey: "state")
        }
        if stateId != nil{
            aCoder.encode(stateId, forKey: "state_id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
        if taxId != nil{
            aCoder.encode(taxId, forKey: "tax_id")
        }
        if totalReview != nil{
            aCoder.encode(totalReview, forKey: "total_review")
        }
        if unreadNotification != nil{
            aCoder.encode(unreadNotification, forKey: "unread_notification")
        }
        if upcomingJob != nil{
            aCoder.encode(upcomingJob, forKey: "upcoming_job")
        }
        if userChatId != nil{
            aCoder.encode(userChatId, forKey: "user_chat_id")
        }
        if userId != nil{
            aCoder.encode(userId, forKey: "user_id")
        }
        if userType != nil{
            aCoder.encode(userType, forKey: "user_type")
        }
        if verifiedFreelancer != nil{
            aCoder.encode(verifiedFreelancer, forKey: "verified_freelancer")
        }
        if walletAmount != nil{
            aCoder.encode(walletAmount, forKey: "wallet_amount")
        }
        if zipCode != nil{
            aCoder.encode(zipCode, forKey: "zip_code")
        }
    }
}
class ModelServiceCategory : NSObject, NSCoding{

    var categoryId : String!
    var categoryName : String!
    var document : String!
    var id : String!
    var status : String!


    /**
     * Instantiate the instance using the passed dictionary values to set the properties values
     */
    init(fromDictionary dictionary: [String:Any]){
        categoryId = dictionary["category_id"] as? String
        categoryName = dictionary["category_name"] as? String
        document = dictionary["document"] as? String
        id = dictionary["id"] as? String
        status = dictionary["status"] as? String
    }

    /**
     * Returns all the available property values in the form of [String:Any] object where the key is the approperiate json key and the value is the value of the corresponding property
     */
    func toDictionary() -> [String:Any]
    {
        var dictionary = [String:Any]()
        if categoryId != nil{
            dictionary["category_id"] = categoryId
        }
        if categoryName != nil{
            dictionary["category_name"] = categoryName
        }
        if document != nil{
            dictionary["document"] = document
        }
        if id != nil{
            dictionary["id"] = id
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
        categoryId = aDecoder.decodeObject(forKey: "category_id") as? String
        categoryName = aDecoder.decodeObject(forKey: "category_name") as? String
        document = aDecoder.decodeObject(forKey: "document") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        status = aDecoder.decodeObject(forKey: "status") as? String
    }

    /**
     * NSCoding required method.
     * Encodes mode properties into the decoder
     */
    @objc func encode(with aCoder: NSCoder)
    {
        if categoryId != nil{
            aCoder.encode(categoryId, forKey: "category_id")
        }
        if categoryName != nil{
            aCoder.encode(categoryName, forKey: "category_name")
        }
        if document != nil{
            aCoder.encode(document, forKey: "document")
        }
        if id != nil{
            aCoder.encode(id, forKey: "id")
        }
        if status != nil{
            aCoder.encode(status, forKey: "status")
        }
    }
}
