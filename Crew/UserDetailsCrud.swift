//
//  UserDetailsCrud.swift
//  Crew
//
//  Created by Rajeev on 26/03/21.
//

import Foundation
import CoreData
import UIKit

class UserDetailsCrud {
    
    
    private var context: NSManagedObjectContext?
    
    private func getManagedObjectContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let managedContext = (appDelegate?.persistentContainer.viewContext)!
        return managedContext
    }
    
    public func saveProfile(profile:ProfileData, completion :@escaping ((Bool) -> Void)) {
        //Get the managed context context from AppDelegate
        
        if(context == nil) {
            context = self.getManagedObjectContext()
        }
        
        let recordObj = NSEntityDescription.insertNewObject(forEntityName: "ProfileDetails", into: self.context!)
        
        recordObj.setValue(profile.cr_file,             forKey: "cr_file")
        recordObj.setValue(profile.cr_number,           forKey: "cr_number")
        recordObj.setValue(profile.created_at,          forKey: "created_at")
        recordObj.setValue(profile.dial_code,           forKey: "dial_code")
        recordObj.setValue(profile.email,               forKey: "email")
        recordObj.setValue(profile.id,                  forKey: "id")
        recordObj.setValue(profile.is_agency,           forKey: "is_agency")
        recordObj.setValue(profile.is_company,          forKey: "is_company")
        recordObj.setValue(profile.is_returner,         forKey: "is_returner")
        recordObj.setValue(profile.job_cancelled,       forKey: "job_cancelled")
        recordObj.setValue(profile.job_completed,       forKey: "job_completed")
        recordObj.setValue(profile.job_received,        forKey: "job_received")
        recordObj.setValue(profile.job_rewarded,        forKey: "job_rewarded")
        recordObj.setValue(profile.mobile,              forKey: "mobile")
        recordObj.setValue(profile.name,                forKey: "name")
        recordObj.setValue(profile.profile_image,       forKey: "profile_image")
        recordObj.setValue(profile.profile_status,      forKey: "profile_status")
        recordObj.setValue(profile.registration_fees,   forKey: "registration_fees")
        recordObj.setValue(profile.signature_file,      forKey: "signature_file")
        recordObj.setValue(profile.wallet_amount,       forKey: "wallet_amount")
        recordObj.setValue(profile.expired_at,          forKey: "expired_at")
        recordObj.setValue(profile.city_id,             forKey: "city_id")
        recordObj.setValue(profile.country_id,          forKey: "country_id")
        recordObj.setValue(profile.nationality_id,      forKey: "nationality_id")
        recordObj.setValue(profile.id_card_image,       forKey: "id_card_image")
        recordObj.setValue(profile.nationality_name,    forKey: "nationality_name")
        recordObj.setValue(profile.country_name,         forKey: "country_name")
        recordObj.setValue(profile.city_name,    forKey: "city_name")
        recordObj.setValue(profile.activate_trial,    forKey: "activate_trial")

        do{
            try self.context!.save()
            completion(true)
        }
        catch let error as NSError
        {
            print("Could not create the new record! \(error), \(error.userInfo)")
            completion(false)
        }
  
    }
    
    public func fetchProfiles( completion :@escaping ((ProfileData) -> Void)) {
        //Get the managed context context from AppDelegate
        
        if(context == nil) {
            context = self.getManagedObjectContext()
        }
        
        let notesEntity = NSEntityDescription.entity(forEntityName: "ProfileDetails", in: context!)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileDetails")
        fetchRequest.entity = notesEntity
        
        do
               {
                let result = try context!.fetch(fetchRequest)
                if(result.count > 0)
                {
                    //                    for i in 0..<result.count
                    //                    {
                    let savedProfile = result.last as! ProfileDetails
                    
                    let profileData = ProfileData(id: Int(savedProfile.id),
                                                  profile_image: savedProfile.profile_image,
                                                  profile_status: savedProfile.profile_status,
                                                  name: savedProfile.name,
                                                  email: savedProfile.email,
                                                  dial_code: savedProfile.dial_code,
                                                  mobile: savedProfile.mobile,
                                                  city_id: Int(savedProfile.city_id),
                                                  country_id: Int(savedProfile.country_id),
                                                  nationality_id: Int(savedProfile.nationality_id),
                                                  id_card_image: savedProfile.id_card,
                                                  is_returner: Int(savedProfile.is_returner),
                                                  cr_number: savedProfile.cr_number,
                                                  cr_file: savedProfile.cr_file,
                                                  signature_file: savedProfile.signature_file,
                                                  created_at: savedProfile.created_at,
                                                  is_agency: savedProfile.is_agency,
                                                  is_company: savedProfile.is_company,
                                                  job_cancelled: Int(savedProfile.job_cancelled),
                                                  job_completed: Int(savedProfile.job_completed),
                                                  job_received: Int(savedProfile.job_received),
                                                  job_rewarded: Int(savedProfile.job_rewarded),
                                                  payment_status: savedProfile.payment_status,
                                                  wallet_amount: savedProfile.wallet_amount,
                                                  registration_fees: savedProfile.registration_fees,
                                                  expired_at: savedProfile.expired_at,
                                                  city_name : savedProfile.city_name,
                                                  country_name: savedProfile.country_name,
                                                  nationality_name:  savedProfile.nationality_name,
                                                  supports: nil, activate_trial: Int(savedProfile.activate_trial))
                        
                        
                        
                        
                        
                        
                        
                    
                    
                    
//                    recordObj.setValue(profile.city_id,             forKey: "city_id")
//                    recordObj.setValue(profile.country_id,          forKey: "country_id")
//                    recordObj.setValue(profile.nationality_id,      forKey: "nationality_id")
//                    recordObj.setValue(profile.id_card_image,       forKey: "id_card_image")
                    
                    completion(profileData)
                    
                    //                    }
                }
                
               }
        catch let error as NSError{
            print("result not found!\(error),\(error.userInfo)")
        }
        
        
    }
    
    
    public func clearDatabase(){
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: "ProfileDetails"))
        do {
            try managedContext.execute(DelAllReqVar)
        }
        catch {
            print(error)
        }
    }
}
