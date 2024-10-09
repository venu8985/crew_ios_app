//
//  AddorRemoveFavourite.swift
//  Crew
//
//  Created by Rajeev on 11/04/21.
//

import Foundation

class AddorRemoveFavourite {
        
    
    static func removeProfileFromFavourites(provider_id : Int,provider_profile_id : Int , vc :UIViewController, completion : @escaping (Bool) -> Void) {
        
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "provider_id" : provider_id,
            "provider_profile_id" : provider_profile_id
        ]
        
        WebServices.deleteRequest(url: Url.removeFavourite, params: parameters, viewController: vc) { success,data  in
            if success {
                completion(true)
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
        }
    }
    
    
    static func addProfileToFavourites(provider_id : Int,provider_profile_id : Int , vc :UIViewController, completion : @escaping (Bool) -> Void) {
        
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "provider_id" : provider_id,
            "provider_profile_id" : provider_profile_id
        ]
        
        WebServices.postRequest(url: Url.addToFavourite, params: parameters, viewController: vc) { success,data  in
            if success {
                completion(true)
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
        }
    }
    
    
    
    
}
