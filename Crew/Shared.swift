//
//  Shared.swift
//  Crew
//
//  Created by Rajeev on 23/03/21.
//

import Foundation

class Profile{

    static let shared = Profile()
    var details : ProfileData?
    
}

class Categories{

    static let shared = Categories()
    var list : [Category]?
    
}

class CreateContract{

    static let shared = CreateContract()
    var charges             : String!
    var chargesUnit         : String!
    var dateRangeArray      : [[String]]!
    var totalAmount         : Int!
    var provider_id         : Int!
    var provider_profile_id : Int!
    var project_id          : Int!

}

class FilterOptions{
    
    static let shared = FilterOptions()
    var selectedCategoryId : Int!
    var subCategoriesArray : [Children]!
    var rating : Double!
    var countryId : Int!
    var countryName : String!
    var cities : [City]!
    var filters = NSMutableDictionary()


}
