//
//  WebserviceUrl.swift
//  ShibariStudy
//
//  Created by mac on 15/04/19.
//  Copyright © 2019 mac. All rights reserved.

import Foundation
import UIKit

// Loca Base Url
//var BASE_URL = "http://192.168.2.141/munka/app/"
//var img_BASE_URL = "http://192.168.2.141/munka/"
 
// Client Base Url
//var BASE_URL = "http://munka.technopium.com/app/"
//var img_BASE_URL = "http://munka.technopium.com/"

//var BASE_URL = "https://keshavinfotechdemo2.com/keshav/KG2/andrePmunka/app/"
//var chat_img_BASE_URL = "http://admin.munkainc.com:3000/"


// Client Live Base Url...#DR after testing uncomment code
var BASE_URL = "https://admin.munkainc.com/app/"//.... #DR live Url
var img_BASE_URL = "https://admin.munkainc.com/"//....#DR Live Url
var chat_img_BASE_URL = "http://admin.munkainc.com:3000/"//......#DR Live Url




//var chat_img_BASE_URL = "http://192.168.2.193:8080/"



// Client Base Url Of image Url
//let ImageSubcartegoryDetailURL = "http://24x7webtesting.com/mycar/uploads/product_defult_images/"
//var chat_img_BASE_URL = "http://24x7webtesting.com/mycar/uploads/product_defult_images/"

var MNLoginAPI = BASE_URL + "login"
let MNSignUpAPI = BASE_URL + "signup"
let MNCountryAPI = BASE_URL + "countries"
let MNStateAPI = BASE_URL + "states"
let MNCitiesAPI = BASE_URL + "cities"
let MNForgotPasswordAPI = BASE_URL + "forgot_password"
let MNAccountVarificationAPI = BASE_URL + "account_verification"
let MNResetPasswordAPI = BASE_URL + "reset_password"
let MNServiceCategoryAPI = BASE_URL + "service_categories"
let MNServiceJobShiftAPI = BASE_URL + "get_job_shift"

let MNGetProfileAPI = BASE_URL + "get_user_profile"
let MNGProfileChangePasswordAPI = BASE_URL + "/change_password"
let MNReviewListAPI = BASE_URL + "review_list"
let MNPinverificationAPI = BASE_URL + "pin_verification"
let MNPIndividualHomeAPI = BASE_URL + "job_list"
let MNPIndividualSearchApiHomeAPI = BASE_URL + "search_job"
let MNPEliteEmployeeAPI = BASE_URL + "elite_employee_list"
let MNPJobPostAPI = BASE_URL + "create_job"
let MNPJobDeleteAPI = BASE_URL + "delete_job"
let MNPJobDetailsAPI = BASE_URL + "job_detail"
let MNWalletHistoryAPI = BASE_URL + "wallet_history"
let MNForgotPinAPI = BASE_URL + "forgot_pin"
let MNResendOtpAPI = BASE_URL + "resent_verification_code"
let MNFavoritesAPI = BASE_URL + "favourite"
let MNJobApplyAPI = BASE_URL + "job_apply"
let MNJobRequestListAPI = BASE_URL + "job_request_list"
let MNJobRequestActionAPI = BASE_URL + "job_request_action"
let MNContractAPI = BASE_URL + "add_contract"
let MNJobDetailAPI = BASE_URL + "job_detail"
let MNAdmincommisionAPI = BASE_URL + "admin_commission"
let MNRechargeWalletAPI = BASE_URL + "recharge_wallet"
let MNContractlistAPI = BASE_URL + "contract_list"
let MNSendJobOTPAPI = BASE_URL + "send_job_otp"
let MNPaymentInfoAPI = BASE_URL + "payment_info"
let MNClaimreasonAPI = BASE_URL + "claim_reason_list"
let MNAddClaimAPI = BASE_URL + "add_claim"
let MNContractActionAPI = BASE_URL + "contract_action"
let MNContractDetailAPI = BASE_URL + "contract_detail"
let MNStartEndJobAPI = BASE_URL + "start_end_job"
let MNAddReviewRatingAPI = BASE_URL + "add_review_rating"
let MNAddServiceAPI = BASE_URL + "add_service_category"
let MNMakePaymentAPI = BASE_URL + "make_payment"

let MNGetServiceCategoryListAPIAPI = BASE_URL + "get_service_category_list"
let MNgetBraintreeDataAPI = BASE_URL + "get_braintree_data"

//
let deleteservicecategoryAPI = BASE_URL + "delete_service_category"
let editServiceAPI = BASE_URL + "edit_service_category"


//MARK:- CHAT API's
let MNGetUserChatListAPI = chat_img_BASE_URL + "chat_list"
let MNArchiveUserChatAPI = chat_img_BASE_URL + "chat_archive"
let MNDeleteUserChatFromListAPI = chat_img_BASE_URL + "chat_delete"
let MNGetUserChatHistoryListAPI = chat_img_BASE_URL + "chat_histroy"
let MNChatFileUploadAPI = chat_img_BASE_URL + "file_upload"


// Individual Progress API
let MNIndividualProgressJobListAPI = BASE_URL + "job_list"
let MNIndividualProgressDetailJobListAPI = BASE_URL + "assign_job_detail"
let MNIndividualPaymentDetailsAPI = BASE_URL + "payment_info"
// Individual Fetch Request list of wallet on
let MNIndividualWalletRequestListAPI = BASE_URL + "withdraw_request_list"
let MNIndividualAddWithdrawequestAPI = BASE_URL + "add_withdraw_request"
let MNIndividualOfferlistAPI = BASE_URL + "offers_list"
let MNIndividualApplyOfferAPI = BASE_URL + "apply_offers"
let MNIndividualOfferTermsCondtinsAPI = BASE_URL + "terms_and_conditions2"
//let MNIndividualOfferTermsCondtinsAPI = BASE_URL + "terms_and_conditions"
let MNPrivacyPolicyAPI = BASE_URL + "privacy_policy2"
//let MNPrivacyPolicyAPI = BASE_URL + "privacy_policy"
let MNFAQAPI = BASE_URL + "faq_list"
let MNContactAPI = BASE_URL + "contact_us"
let MNNotificationAPI = BASE_URL + "notification_list"
let MNSaveStripeCustomerIdAPI = BASE_URL + "saveStripeCustomerId"
let MNCreateStripeIntentAPI = BASE_URL + "createStripeIntent"

let MNGetCalenderAPI = BASE_URL + "get_calender"
let MNGetCalenderBydateAPI = BASE_URL + "get_calender_by_date"
let MNGetFreelauncerEarningAPI = BASE_URL + "freelancer_earning"
let MNGetFavoritesJobsAPI = BASE_URL + "favourite_list"
let MNGetOffertemsConditiomsAPI = BASE_URL + "offer_term_condition"
let MNGetChangeAccessPinAPI = BASE_URL + "change_access_pin"
let MNGetNotificationSettingAPI = BASE_URL + "notification_setting"
let MNGetGraphAPI = BASE_URL + "reports"
let MNGetUpdateProfileAPI = BASE_URL + "profile_update"
let MNGetPrinterAPI = BASE_URL + "print_contract"
let MNGetEditJobAPI = BASE_URL + "edit_job"
let MNLogoutAPI = BASE_URL + "logout"

let MNDeleteAccountAPI = BASE_URL + "delete_user_account"
let MNChangeMobileorEmailAPI = BASE_URL + "change_phone_email"
