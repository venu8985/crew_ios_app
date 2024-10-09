//
//  WebServices.swift
//  Crew
//
//  Created by Rajeev on 15/03/21.
//

import Foundation
import Alamofire

class WebServices {
    
    static func postRequest(url : String, params : [String:Any], viewController : UIViewController , completion : @escaping (Bool,Data) -> Void){
        
//        showProgressHUD(title: "", viewController: viewController)
        
        
        if !(NetworkState().isInternetAvailable) {
            Banner().displayValidationError(string: NSLocalizedString("Please check interent connection", comment: ""))

        }
        
        GGProgress.shared.show(with: "")
        
        let token = UserDefaults.standard.value(forKey: "token") as? NSString ?? ""
        
        let headers : HTTPHeaders = ["Authorization"    : "Bearer \(token)",
                                     "Content-Type"     : "application/json",
                                     "X-Requested-With" : "XMLHttpRequest"]
        debugPrint(url)
        debugPrint(headers)
        debugPrint(params)
        AF.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {  (response) in
                
                DispatchQueue.main.async {
                    GGProgress.shared.hide()
                }
                
                print(response)
                if response.response?.statusCode == 200{
                    completion(true,response.data ?? Data() )
                }
                
                else if response.response?.statusCode == 401{
                    
//                    DispatchQueue.main.async {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
//                        vc.modalPresentationStyle = .fullScreen
//                        viewController.present(vc, animated: true, completion: nil)
//                    }
                }
                else if response.response?.statusCode == 410{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                    vc.modalPresentationStyle = .overFullScreen
                    AppDelegate.shared.window?.rootViewController?.present(vc, animated: true)
                }
                else if response.response?.statusCode == 422{
                    do {
                        if let data = response.data{
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                if let jsonDict = json.value(forKey: "errors") as? NSDictionary{
                                    if let key = jsonDict.allKeys.first as? String{
                                        if let errorArray = jsonDict.value(forKey: key) as? NSArray{
                                            if errorArray.count>0{
                                                if let error = errorArray[0] as? String{
                                                    Banner().displayValidationError(string: error)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch let error {
                        Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                        print(error)
                    }
                    
                }
                else{
                    completion(false,response.data ?? Data())
                }
            }
        
    }
    static func getRequest(url : String, params : [String:Any], viewController : UIViewController , completion : @escaping (Bool,Data) -> Void){
        
//        showProgressHUD(title: "", viewController: viewController)
        
        
        if !(NetworkState().isInternetAvailable) {
            Banner().displayValidationError(string: NSLocalizedString("Please check interent connection", comment: ""))

        }
        
        GGProgress.shared.show(with: "")
        
        let token = UserDefaults.standard.value(forKey: "token") as? NSString ?? ""
        
        let headers : HTTPHeaders = ["Authorization"    : "Bearer \(token)",
                                     "Content-Type"     : "application/json",
                                     "X-Requested-With" : "XMLHttpRequest"]
        
        AF.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
            .responseJSON {  (response) in
                
                DispatchQueue.main.async {
                    GGProgress.shared.hide()
                }
                
                print(response)
                if response.response?.statusCode == 200{
                    completion(true,response.data ?? Data() )
                }
                
                else if response.response?.statusCode == 401{
                    
//                    DispatchQueue.main.async {
//                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//                        let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
//                        vc.modalPresentationStyle = .fullScreen
//                        viewController.present(vc, animated: true, completion: nil)
//                    }
                }
                else if response.response?.statusCode == 410{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                    vc.modalPresentationStyle = .overFullScreen
                    AppDelegate.shared.window?.rootViewController?.present(vc, animated: true)
                }
                else if response.response?.statusCode == 422{
                    do {
                        if let data = response.data{
                            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                                if let jsonDict = json.value(forKey: "errors") as? NSDictionary{
                                    if let key = jsonDict.allKeys.first as? String{
                                        if let errorArray = jsonDict.value(forKey: key) as? NSArray{
                                            if errorArray.count>0{
                                                if let error = errorArray[0] as? String{
                                                    Banner().displayValidationError(string: error)
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } catch let error {
                        Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                        print(error)
                    }
                    
                }
                else{
                    completion(false,response.data ?? Data())
                }
            }
        
    }
    static func deleteRequest(url : String, params : [String:Any], viewController : UIViewController , completion : @escaping (Bool,Data) -> Void){
        
        GGProgress.shared.show(with: "Deleting...")

        let token = UserDefaults.standard.value(forKey: "token") as? NSString ?? ""
        
        let headers : HTTPHeaders = ["Authorization" : "Bearer \(token)",
                                     "Content-Type": "application/json"]
        
        AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {  (response) in
                
                DispatchQueue.main.async {
                    GGProgress.shared.hide()
                }
                
                print(response)
                if response.response?.statusCode == 200{
                    completion(true,response.data ?? Data() )
                }else{
                    completion(false,response.data ?? Data())
                }
                
            }
        
    }
    
    
//    class func showProgressHUD(title: String, viewController : UIViewController){
//            let hud = MBProgressHUD.showAdded(to: viewController.view, animated: true)
//            hud.label.text = title
////            viewController.view.addSubview(hud)
//    }
//
//    class func dismissGlobalHUD(viewController : UIViewController) -> Void{
//
//        DispatchQueue.main.async {
//            MBProgressHUD.hide(for: viewController.view, animated: true)
//        }
//
//    }
    
}

struct NetworkState {

    var isInternetAvailable:Bool
    {
        return NetworkReachabilityManager()!.isReachable
    }
}
