//
//  CrewModel.swift
//  Crew
//
//  Created by Rajeev on 15/03/21.
//

import Foundation
import ObjectMapper



//MARK: Nationalities

struct Nationalities : Codable{
    let message : String?
    let data : [Nationality]?
}

struct Nationality : Codable {
    var id : Int?
    var nationality_name: String?
}

//MARK: Country codes

struct CountryCodes : Codable {
    let message : String?
    let data : [CountryInfo]?
}

struct CountryInfo : Codable {
    
    let id : Int?
    let name : String?
    let dial_code : String?
    let alpha_2 : String?
    let flag : String?
//    let cities : [Cities]

}

//struct Cities : Codable{
//    let id : Int!
//    var name : String!
//}

//MARK: cities list

struct Cities : Codable {
    let message : String?
    let data : [City]?
}

struct City : Codable {
    
    let id : Int?
    let name : String?
    let country_id : Int?
}


//MARK: Agency list

struct AgencyList : Codable {
    var message : String = ""
    let data : AgencyData?
}
struct AgencyData : Codable {
    let total : Int?
    let current_page : Int?
    let last_page : Int?
    let first_page_url : String?
    let nextPageURL : String?
    let prevPageURL : String?
    let last_page_url : String?
    let from : Int?
    let perPage : Int?
    let path : String?
    let data : [Agency]?
}
struct Agency : Codable {
    var id : Int?
    var name : String?
    var profile_image : String?
    var hiredAgency : HiredAgency?
}

struct HiredAgency : Codable{
    var id : Int = 0
    var status : String = ""
}

//MARK: Forgotpassword
struct ForgotPassword : Codable {
    let message : String?
    let data : LoginData?
}

struct ForgotPasswordData : Codable{
    
    let id : Int?
    let token : String?
}

//MARK: New Password
struct NewPassword : Codable {
    let message : String?
    let data : NewPasswordData?
}

struct NewPasswordData : Codable{
    let access_token : String
    let data : PasswordData?
}

struct PasswordData : Codable{

    let cr_file : String?
    let cr_number : String?
    let created_at : String?
    let dial_code : String?
    let email : String?
    let expired_at : String?
    let id : Int?
    let is_agency : String?
    let is_company : String?
    let mobile : String?
    let name : String?
    let password : String?
    let payment_status : String?
    let profile_image : String?
    let profile_status : String?
    let registration_fees : String?
}

//MARK: login
struct Login : Codable {
    let message : String?
    let data : LoginData?
}

struct LoginData : Codable{
    
    let id : Int?
    let token : String?
}


struct LoginWithPassord : Codable {
    let message : String?
    let data : UserData?
    let errors : Errors?
}

struct Errors : Codable{
    let error : [String]?
}


struct UserData : Codable{
    let access_token : String?
    let data : ProfileData?
}


//MARK: OTP
struct OTP : Codable {
    let message : String?
    let data : OTPData?
}

struct OTPData : Codable{
    let access_token : String?
    let data : ProfileData?
}


struct OTPResend : Codable {
    let message : String?
    let data : OTPResendData?
}

struct OTPResendData : Codable{
    let id : Int?
    let token : String?
}



//MARK: T&C and Privacy poicy

struct PrivacyPolicy : Codable {
    let message : String?
    let data : PPData?
}

struct PPData : Codable{
    let privacy_policy : String?
}

struct TermsAndCondtions : Codable {
    let message : String?
    let data : TCData?
}

struct TCData : Codable{
    let terms_conditions : String?
}


//MARK: CDN

struct AppSettings : Codable {
    
    let message : String?
    let data : CDN
}

struct CDN : Codable{
    
    let AWS_ACCESS_KEY_ID : String?
    let AWS_SECRET_ACCESS_KEY : String?
    let AWS_DEFAULT_REGION : String?
    let AWS_BUCKET : String?
    let AWS_URL : String?
}

//MARK: Filters

struct Filter : Codable {
    
    let message : String?
    let data : FilterData
}

struct FilterData : Codable{
    
    let minPrice : String?
    let maxPrice : String?
    let country  : [CountryData]?
    let categories : [CategoryData]
}

struct CountryData : Codable{
    let id        : Int?
    let name      : String?
    let dial_code : String?
    let alpha_2   : String?
    let flag      : String?
//    let cities : [Cities]

    
}
struct CategoryData : Codable{
    let id : Int?
    let name : String?
    let image : String?
    let is_talent : String?
    let max_selection_allowed : Int?
    let children : [Children]?
}

struct Children : Codable{
    let id : Int?
    let name : String?
}
//MARK: Resource details

struct ResourceDetails : Codable {
    let message : String?
    let data : ResourceData
}

struct ResourceData : Codable{
    
    let id : Int?
    let provider_id : Int?
    let provider_profile_id : Int?
    let location : String?
    let latitude : Double?
    let longitude : Double?
    let days : Int?
    let total_amount : String?
    let paid_amount : String?
    let remaining_amount : String?
    let status : String?
    let created_at : String?
    let name : String?
    let profile_image : String?
    let main_category : String?
    let child_category : String?
    let rating : String?
    let feedback : String?
    let provider_review_id : Int?
    let charges : String?
    let charges_unit : String?
    let child_category_id : Int?
    let slots : [Slot]
    let contracts : ResourceContracts
    let milestones : [Milestone]
}

struct Slot : Codable{
    let id : Int?
    let start_at : String?
    let end_at : String?
    let days : Int?
}

struct ResourceContracts : Codable{
    let id : Int?
    let start_at : String?
    let end_at : String?
    let days : Int?
    let contract_number : String?
    let contract_name : String?
    let contract_description : String?
    let agency_signature : String?
    let provider_signature : String?
    let status : String?
    let pdf_file : String?
    let created_at : String?
}

struct Milestone : Codable{
    let id : Int?
    let title : String?
    let description : String?
    let milestone_date : String?
    let milestone_amount : String?
    let status : String?
    let paid_at : String?
    let pdf_file : String?
    let created_at : String?
}





//MARK: Notifications

struct Notifications : Codable{
    
    let message : String?
    let data : [NotificationDetails]
    
}

struct NotificationDetails : Codable{
    
    let id : Int?
//    let is_read : Int?
//    let read_at : String?
//    let notify_type : String?
    let title : String?
    let description : String?
    let created_at : String?
    let notify_type : String?
    let value       : String?
    
}

struct DeleteNotifications : Codable{
    
    let message : String?
    
}


//MARK: Complete profile

struct CompleteProfile : Codable{
    
    let message : String?
    let data : ProfileData?
}
struct ProfileData : Codable{
    
    let id : Int?
    let profile_image :  String?
    let profile_status : String?
    let name : String?
    let email : String?
    let dial_code : String?
    let mobile : String?
    let city_id : Int?
    let country_id : Int?
    let nationality_id : Int?
    let id_card_image : String?
    let is_returner : Int?
    let cr_number : String?
    let cr_file : String?
    let signature_file : String?
    let created_at : String?
    let is_agency : String?
    let is_company : String?
    let job_cancelled : Int?
    let job_completed : Int?
    let job_received : Int?
    let job_rewarded : Int?
    let payment_status : String?
    let wallet_amount : String?
    let registration_fees : String?
    var expired_at : String?
    let city_name : String?
    let country_name: String?
    let nationality_name : String?
    let supports : Support?
    let activate_trial: Int?
}

struct Support : Codable {
    let email_address : String?
    let mobile : String?
    
}

//MARK: About us

struct AboutUs : Codable {
    let message : String?
    let data : AboutUsData?
}

struct AboutUsData : Codable{
    let about_us : String?
}



//MARK: About us

struct Payment : Codable {
    let message : String?
    let data : Checkout?
}

struct Checkout : Codable{
    let id : String?
}


struct Status : Codable{
    
    let messsage : String?
    let data : PaymentDetails?
    
}
struct PaymentDetails : Codable {
    let id : Int?
    let profile_image : String?
    let name : String?
    let email : String?
    let dial_code : String?
    let mobile : String?
    let is_returner : Int?
    let cr_number : Int?
    let cr_file : String?
    let signature_file : String?
    let payment_status : String?
    let profile_status : String?
    let created_at : String?
    
}

//MARK: Create Shooting plan

struct CreateShootinPlan : Codable{
    let message : String?
    let data : ShootingPlanData
}

struct ShootingPlanData : Codable{
    let id : Int?
    let project_id: Int?
    let shooting_date: String?
    let location : String?
    let latitude : String?
    let longitude : String?
    let updated_at : String?
    let created_at : String?
}


//MARK: Shooting plans

struct ShootingPlans : Codable{
    let message : String?
    let data : [ShootingPlan]
}

struct ShootingPlan : Codable{
    let id : Int?
    let project_id: Int?
    let shooting_date: String?
    let location : String?
    let latitude : Double?
    let longitude : Double? 
    let created_at : String?
    let resources : [ShootingResource]
}

struct ShootingResource : Codable{
    
    let id : Int?
    let hire_resource_id : Int?
    let provider_profile_id : Int?
    let provider_id : Int?
    let name : String?
    let profile_image : String?
    let main_category : String?
    let child_category : String?
    let reschedule_date : String?
    
}

//MARK: Dashboard

struct Dashboard : Codable{
    let message : String?
    let data : DashboardData
}

struct DashboardData : Codable{
    let agency_proposal_fees:String?
    let version: String?
    let update_description : String?
    let banners: [Banners]?
    let projects : [ProjectsData]?
    let categories : [Category]?
    let featuredProfiles : [FeaturedProfile]?
}

struct Banners: Codable {
    let id: Int?
    let banner_name:String?
    var banner_file: String = ""
}

struct Category: Codable {
    let id : Int?
    var name : String = ""
    var image : String = ""
    let is_talent: String?
    let max_selection_allowed: Int
    let children: [Child]
    
}
struct Child : Codable{
     let id: Int?
     let name: String?
}

struct FeaturedProfile : Codable {
    let id : Int?
    let provider_id : Int?
    let main_category_id : Int?
    let child_category_id : Int?
    let title : String?
    let charges : String?
    let charges_unit : String?
    let rating : String?
    let job_rewarded : Int?
    let job_received : Int?
    let name : String?
    var profile_image : String?
    let main_category : String?
    let is_talent : String?
    let child_category: String?
    var is_favorite: Int?
}

//MARK: Featured profiles

struct MyContracts : Codable{
     let message: String?
     let data: MyContractsData?
}

struct MyContractsData : Codable{
    
    let total : Int?
    let current_page : Int?
    let last_page : Int?
    let first_page_url : String?
    let nextPageURL : String?
    let prevPageURL : String?
    let last_page_url : String?
    let from : Int?
    let perPage : Int?
    let path : String?
    let data : [Contract]?
    
}

struct Contract : Codable{
    
    let id : Int!
    let contract_number : String!
    let contract_name : String!
    let contract_description : String!
    let created_at : String!
}


//MARK: My contracts profiles

struct FeaturedProfiles : Codable{
     let message: String?
     let data: FeaturedProfilesData?
}

struct FeaturedProfilesData : Codable{
    
    let total : Int?
    let current_page : Int?
    let last_page : Int?
    let first_page_url : String?
    let nextPageURL : String?
    let prevPageURL : String?
    let last_page_url : String?
    let from : Int?
    let perPage : Int?
    let path : String?
    let data : [FeaturedProfile]?
    
}

//MARK: Favourite profiles

struct FavouriteProfiles : Codable{
     let message: String?
     let data: FavouriteProfileData?
}

struct FavouriteProfileData : Codable{
    
    let total : Int?
    let current_page : Int?
    let last_page : Int?
    let first_page_url : String?
    let nextPageURL : String?
    let prevPageURL : String?
    let last_page_url : String?
    let from : Int?
    let to : Int?
    let perPage : Int?
    let path : String?
    let data : [FavouriteProfile]?
    
}

struct FavouriteProfile : Codable{
    var id                    :  Int!  
    var provider_id           :  Int!
    var main_category_id      :  Int!
    var child_category_id     :  Int!
    var profile_image         :  String?
    var charges               : String!
    var charges_unit          : String!
    var rating                : String!
    var name                  : String!
    var main_category         : String!
    var child_category        : String!
    var is_talent             : String!
    var is_favorite           : Int!
}


struct PaymentsList : Codable{
     let message: String?
     let data: PaymentsListData?
}

//MARK: Payments list

struct PaymentsListData : Codable{
    var total            : Int?
    var current_page     : Int?
    var last_page        : Int?
    var first_page_url   : String?
    var next_page_url    : String?
    var last_page_url    : String?
    var from             : Int?
    var per_page         : Int?
    var path             : String?
    let data             : [Payments]?
}

struct Payments : Codable{
    var id                      : Int?
    var contract_milestone_id   : String?
    var amount                  : String?
    var is_wallet               : String?
    var currency                : String?
    var status                  : String?
    var payment_mode            : String?
    var checkout_id             : String?
    var transaction_id          : String?
    var transaction_type        : String?
    var created_at              : String?
    var txn_type              : String?
    var payment_type: String?
}

//MARK: Hire resource

struct HireResource : Codable{
     let message: String?
     let data: hireResourcesData?
    let errors : Errors?
}

struct hireResourcesData : Codable{
    var user_id : Int?
    var contracts : ContractData?
}

struct ContractData : Codable{
    let contract_name : String?
    let contract_number : String?
}

//MARK: Hire agency
struct HireAgency : Codable{
     var message: String = ""
     let data: ProjectsListData?
    let errors : Errors?
}
struct HireAgencyData : Codable {
    var user_id       : Int      = 0
    var id            : Int      = 0
    var agency_id     : String = ""
    var project_id    : String = ""
    var status        : String = ""
    var updated_at    : String = ""
    var created_at : String = ""
}


//MARK: Projects list

struct ProjectsList : Codable{
     let message: String?
     let data: ProjectsListData?
}

struct ProjectsListData : Codable{
    
    var total            : Int?
    var current_page     : Int?
    var last_page        : Int?
    var first_page_url   : String?
    var next_page_url    : String?
    var last_page_url    : String?
    var from             : Int?
    var per_page         : Int?
    var path             : String?
    let data             : [ProjectsData]?
    
}


//MARK: Award

struct Award : Codable{
    let message: String?
    let data: AwardData?
}

struct AwardData : Codable{
    var id             : Int!
    var user_id        : Int!
    var proposal_id    : Int!
    var contract_id    : String!
    var agency_id      : Int!
    var project_id     : Int!
    var status         : String!
    var created_at     : String!
    var updated_at     : String!
}

//MARK: Agency Requests

struct AgencyRequests : Codable {
    var message : String = ""
    let data : AgencyRequestsData?
}
struct AgencyRequestsData : Codable {
    
    let total : Int?
    let current_page : Int?
    let last_page : Int?
    let first_page_url : String?
    let nextPageURL : String?
    let prevPageURL : String?
    let last_page_url : String?
    let from : Int?
    let perPage : Int?
    let path : String?
    
    let data : [AgencyRequest]?
    
}
struct AgencyRequest : Codable {
    var id = 0
    var user_id = 0
    var project_id = 0
    var name = ""
    var start_at = ""
    var end_at = ""
    var budget = ""
    var status = ""
    var created_at = ""
    var company_name = ""
    var profile_image : String!
    var country_name = ""
    var city_name = ""
    var project_status = ""
    
    
    
}

//Agency Request Details
struct RequestDetails : Codable {
    var message : String!
    var data : RequestDetailsData
}
struct RequestDetailsData : Codable{
    var id : Int!
    var name : String!
    var agency_id : Int!
    var budget : String!
    var city_name : String!
    var company_name : String!
    var contracts : AgencyContract!
    var country_name : String!
    var created_at : String!
    var description : String!
    var end_at : String!
    var profile_image : String!
    var project_id : Int!
    var project_status : String!
    var start_at : String!
    var status : String!
    var user_id : Int!
    var proposals : Proposal!
}

struct AgencyContract : Codable{
    var id : Int!
    var start_at : String!
    var end_at : String!
    var days : Int!
    var contract_number : String!
    var contract_name : String!
    var contract_description : String!
    var company_signature : String!
    var agency_signature : String!
    var status : String!
    var pdf_file : String!
    var created_at : String!

}


//MARK: Send Proposal

struct ProposalDetails : Codable{
     let message: String?
     let data: ProposalDetailsData?
}

struct ProposalDetailsData : Codable{
    var id             : Int?
    var agency_id      : Int?
    var hire_agency_id : Int?
    var description    : String?
    var proposal_file  : String?
    var updated_at     : String?
    var created_at     : String?
}

//MARK: Projects Details

struct ProjectDetails : Codable{
     let message: String?
     let data: ProjectDetailsData?
}

struct ProjectDetailsData : Codable{
    var id               : Int?
    var country_id       : Int?
    var city_id          : Int!
    var status           : String?
    var name             : String?
    var description      : String?
    var start_at         : String?
    var end_at           : String
    var budget           : String?
    var cost             : String?
    var created_at       : String?
    var country_name     : String?
    var city_name        : String?
    var hireAgency : [HiredAgencies]
    var resources : [ResourcesData]?
    var auditions  : [Audtions]?

}

struct HiredAgencies : Codable{
    
    var id            : Int?
    var agency_id     : Int?
    var status        : String?
    var created_at    : String?
    var name          : String?
    var profile_image : String?
    var proposals : Proposal?
    var contracts : AgencyContract?
}
struct Proposal : Codable{
    var id             : Int?
    var description    : String?
    var proposal_file  : String?
    var created_at     : String?
    var status     :  String?
}

struct ProjectsData : Codable{

    var id         :  Int?
    var name       :  String?
    var start_at   :  String?
    var end_at     :  String?
    var budget     :  String?
    var cost       :  String?
    var status     :  String?
    var created_at :  String?
    let resources  :  [ResourcesData]?
    var hireAgency : [AgencyDetails]?
    var auditions  : [Audtions]?
    
}
struct Audtions : Codable{
    var id                  : Int?
    var provider_id         : Int?
    var provider_profile_id : Int?
    var status              : String?
    var name                : String?
    var child_category      : String?
    var main_category       : String?
    var profile_image       : String?
    
}

struct AgencyDetails : Codable{
    var id             : Int?
    var name           : String?
    var agency_id      : Int?
    var created_at     : String?
    var profile_image  : String?
    var status          : String?
}

struct ResourcesData : Codable{
    
    var id                    :  Int?
    var provider_profile_id   :  Int?
    var name                  :  String?
    var profile_image         :  String?
    var main_category         :  String?
    var child_category        :  String?
    var total_amount          :  String?
    var status                :  String?
}


//MARK: Provider Profile deails

struct ProviderProfileDetails : Codable {
    
    let message : String?
    let data : ProviderProfileData
}

struct ProviderProfileData : Codable{
    
    let id                : Int?
    let provider_id       : Int?
    let main_category_id  : Int?
    let child_category_id : Int?
    let title             : String?
    let description       : String?
    let charges           : String?
    let charges_unit      : String?
    let rating            : String?
    let job_rewarded      : Int?
    let job_received      : Int?
    let total_reviews     : Int?
    let name              : String?
    let profile_image     : String?
    let main_category     : String?
    let is_talent         : String?
    let is_hire           : String?
    let notify_audition   : String?
    let resume_required   : String?
    let child_category    : String?
    let country_name      : String?
    let city_name         : String?
    let resume_file       : String?
    let is_favorite       : Int?
    let achievements      : [ProviderAchievements]?
    let specialities      : [ProviderSpecialities]?
    let gallery           : [ProviderGallery]?
    let reviews           : [Review]?
    let busySlots         : [String]?
}
struct Review : Codable{
    var created_at : String!
    var feedback : String!
//    var id : Int!
    var name : String!
    var profile_image : String!
    var rating : String!
//    var user_id : String!
    
}
struct ProviderAchievements : Codable {
    let id : Int?
    let achievement_name : String?
}
struct ProviderSpecialities : Codable {
    let id : Int?
    let speciality_name : String?
}
struct ProviderGallery : Codable {
    let id          : Int?
    let filename   : String?
    let thumb       : String?
    let mime_type   : String?
    let duration    : String?
    let size        : String?
}


//MARK: Error model

struct APIError : Codable{
    let errors : ErrorData!
    let message : String!
}
struct ErrorData : Codable{
    let error : [String]!
}

