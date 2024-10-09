//
//  Constants.swift
//  Crew
//
//  Created by Rajeev on 04/03/21.
//

import Foundation
import UIKit


let placeHolderImage       = UIImage(named: "user_placeholder")
let bannerPlaceholderImage = UIImage(named: "BannerPlaceholder")

struct Color {
    static let red              = UIColor(hexString: "D70225")
    static let liteGray         = UIColor(hexString: "DDDDDD")
    static let gray             = UIColor(hexString: "999999")
    static let green            = UIColor(hexString: "13B161")
    static let liteYellow       = UIColor(hexString: "FBF6DF")
    static let liteBlack        = UIColor(hexString: "28323C")
    static let liteWhite        = UIColor(hexString: "F1F1F7")
    static let litePink         = UIColor(hexString: "F5F2F8")
    static let gold             = UIColor(hexString: "F4BC42")
    static let litePurple       = UIColor(hexString: "E6E9F8")
}

struct Notification {
    static let dashboard           = NSNotification.Name(rawValue: "UpdateDashboard")
    static let fetchProfiles       = NSNotification.Name(rawValue: "UpdateDashboard")
    static let profile             = NSNotification.Name(rawValue: "getProfile")
    static let notification        = NSNotification.Name(rawValue: "NotificationRecieved")
    static let logout              = NSNotification.Name(rawValue: "Logout")
    static let dismissAuth         = NSNotification.Name(rawValue: "DismissAuthentication")
    static let agencyRequests      = NSNotification.Name(rawValue: "Logout")
    static let verified            = NSNotification.Name(rawValue: "Verified")
    static let rejected            = NSNotification.Name(rawValue: "Rejected")
    static let updateProject       = NSNotification.Name(rawValue: "updateProject")
    static let deepLink            = NSNotification.Name(rawValue: "deepLink")


}

struct AWS {
    static let AWS_ACCESS_KEY_ID     = "AWS_ACCESS_KEY_ID"
    static let AWS_SECRET_ACCESS_KEY = "AWS_SECRET_ACCESS_KEY"
    static let AWS_BUCKET            = "AWS_BUCKET"
    static let AWS_URL               = "AWS_URL"
}

struct AWSBucket {
    static let uploadUser            = "uploads/users"
    static let uploadCRN             = "uploads/crn_files"
    static let uploadSignature       = "uploads/signatures"
    static let proposals             = "uploads/proposals"
    static let id_card               = "uploads/id_cards"

}

struct Url {
        
    #if DEBUG
        static let baseUrl = "https://development.htf.sa/crew"
    #else
        static let baseUrl = "https://crew-sa.com"
    #endif
    static let appstoreUrl = "https://apps.apple.com/us/developer/htf-here-the-future/id1414499395"
    
    static let cdnUrl = "http://crew.sa.s3.amazonaws.com"
    

    // app settings
    static let appInternalSettings              =      baseUrl + "/api/v1/internal/settings"
    static let appSettings              =      baseUrl + "/api/v1/app/settings"
    
    //CDN
    static let userProfile              =      cdnUrl + "/uploads/users/"
    static let crnFile                  =      cdnUrl + "/uploads/crn_files/"
    static let banner                   =      cdnUrl + "/uploads/banners/"
    static let gallery                  =      cdnUrl + "/uploads/gallery/"
    static let categories               =      cdnUrl + "/uploads/categories/"
    static let providers                =      cdnUrl + "/uploads/providers/"
    static let proposal                 =      cdnUrl + "/uploads/proposals/"
    static let countryFlag              =      cdnUrl + "/uploads/country_flags/"
    static let id_cards                 =      cdnUrl + "/uploads/id_cards/"
    
    // Authentication
    static let login                    =      baseUrl + "/api/v1/login"
    static let contryCodes              =      baseUrl + "/api/v1/country"
    static let nationalities            =      baseUrl + "/api/v1/nationality"
    static let cities                   =      baseUrl + "/api/v1/city"
    static let otpValidation            =      baseUrl + "/api/v1/verify/otp"
    static let forgotOTP                =      baseUrl + "/api/v1/verify/forgot/password/otp"
    static let otpResend                =      baseUrl + "/api/v1/resend/otp"
    static let termsAndCondtions        =      baseUrl + "/api/v1/terms-conditions"
    static let privacyPolicy            =      baseUrl + "/api/v1/privacy-policy"
    static let completeProfile          =      baseUrl + "/api/v1/complete/profile"
    static let forgotPassword           =      baseUrl + "/api/v1/forgot/password"
    static let newPassword              =      baseUrl + "/api/v1/update/new/password"
    static let completeProfileWithoutPassword = baseUrl + "/api/v1/complete/profile/without/password"
    
    // Notifications
    static let getNotifications         =      baseUrl + "/api/v1/notifications"
    static let clearNotifications       =      baseUrl + "/api/v1/delete/notification"

    
    // Profile Menu
    static let logout                   =      baseUrl + "/api/v1/logout"
    static let changePassword           =      baseUrl + "/api/v1/change/password"
    static let support                  =      baseUrl + "/api/v1/submit/feedback"
    static let getProfile               =      baseUrl + "/api/v1/get/profile"
    static let updateProfileType        =      baseUrl + "/api/v1/update/profile/type"
    static let updateProfile            =      baseUrl + "/api/v1/update/profile"
    static let updateDeleteProfileImage =      baseUrl + "/api/v1/update/profile/image"
    static let aboutUs                  =      baseUrl + "/api/v1/about-us"


    // Dashboard
    static let dashboard                =      baseUrl + "/api/v1/dashboard"

    //Feature profiles (View all profiles)
    static let featuredProfiles         =      baseUrl + "/api/v1/featured/profiles"
    static let filters                  =      baseUrl + "/api/v1/provider/profile/filters"
    
    //Category Profiles
    static let categoryProfiles         =      baseUrl + "/api/v1/provider/profiles"
    
    //Create Project
    static let createProject            =      baseUrl + "/api/v1/create/project"
    
    //Update project
    static let updateProject            =      baseUrl + "/api/v1/update/project"

    
    // Projects list
    static let projectList              =      baseUrl + "/api/v1/my/project/listings"
    static let projectDetails           =      baseUrl + "/api/v1/my/project/details"
    static let award                    =      baseUrl + "/api/v1/award/project"
    static let cancelProject            =      baseUrl + "/api/v1/cancel/my/project"
    static let completeProject          =      baseUrl + "/api/v1/complete/my/project"

    
    //Provider profile details
    static let providerProfileDetails   =      baseUrl + "/api/v1/provider/profile/details"
    
    //Create contract
    static let hireResource             =      baseUrl + "/api/v1/hire/resource"
    
    // My contracts
    static let myContracts              =      baseUrl + "/api/v1/my/contract/listings"
    
    
    //Payment : Hyper pay
    static let payment                  =      baseUrl + "/api/v1/generate/subscription/checkout"
    static let status                   =      baseUrl + "/api/v1/verify/subscription/payment/status"
    
   
    //Payment : Provider milestone
    static let resourceDetails          =      baseUrl + "/api/v1/resource/details"
    static let releasePayment           =      baseUrl + "/api/v1/milestone/payment/released"
    static let jobDone                  =      baseUrl + "/api/v1/hire/resource/make/job/done"
    static let submitReview             =      baseUrl + "/api/v1/submit/review"

    //Shooting plan
    static let createShootingPlan       =       baseUrl + "/api/v1/create/shooting/plan"
    static let updateShootingPlan       =       baseUrl + "/api/v1/update/shooting/plan"
    static let shootingPlans            =       baseUrl + "/api/v1/my/shooting/plans"

    //Favourite Profile
    static let favouriteProfiles        =       baseUrl + "/api/v1/favorite/provider/listings"
    static let removeFavourite          =       baseUrl + "/api/v1/remove/provider/from/favorite"
    static let addToFavourite           =       baseUrl + "/api/v1/add/provider/to/favorite"

    
    //Agency
    static let agencyList               =       baseUrl + "/api/v1/agency/listings"
    static let hireAgency               =       baseUrl + "/api/v1/hire/agency"
    static let agencyRequests           =       baseUrl + "/api/v1/hire/agency/requests"
    static let awardRequests            =       baseUrl + "/api/v1/hire/agency/awarded/requests"
    static let requestDetails           =       baseUrl + "/api/v1/hire/agency/request/details"
    static let createProposal           =       baseUrl + "/api/v1/create/proposal"
    static let rejectProposal           =       baseUrl + "/api/v1/hire/agency/reject/request"
    static let payproposal                 =       baseUrl + "/api/v1/pay/proposal"
    
    //Company
    static let createContract           =       baseUrl + "/api/v1/create/contract"
    static let rejectContract           =       baseUrl + "/api/v1/reject/contract"
    static let acceptContract           =       baseUrl + "/api/v1/accept/contract"

    //Audtion
    static let inviteAudition           =       baseUrl + "/api/v1/invite/for/audition"

    //payment
    static let paymentsList             =       baseUrl + "/api/v1/payment/history"
    
    //FCM
    static let updateFCMToken           =       baseUrl + "/api/v1/update/fcm/token"
    static let activatetrial           =       baseUrl + "/api/v1/activate/trial"
    
    //Payment Url scheme
    static let scheme = "TeFe-Information.Crew"

}
    
struct FCM {
    static let token = "fcmToken"
}

