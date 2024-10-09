//
//  AboutUsViewController.swift
//  Crew
//
//  Created by Rajeev on 24/03/21.
//

import UIKit

class AboutUsViewController: UIViewController {
    
    var textview : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textview = UITextView()
        textview.frame = self.view.bounds
        textview.inputView = UIView()
        self.view.addSubview(textview)
        
    
        getAboutUs()
        
        
        self.navigationBarItems()
    }
    
    
    func navigationBarItems() {
        
            self.title = NSLocalizedString("About us", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.setImage(UIImage(named: "back-R"), for: .normal)
        }else{
            backButton.setImage(UIImage(named: "back"), for: .normal)
        }
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
        backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);
        }else{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        }
        
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    func getAboutUs(){
        
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios"
            
        ]
        
        WebServices.postRequest(url: Url.aboutUs, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AboutUs.self, from: data)
                
                if success{
                    DispatchQueue.main.async {
                        self.textview.attributedText = response.data?.about_us?.htmlToAttributedString
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
        
        
    }
    
    
    func getTermsAndConditions(){


        let parameters: [String: Any] = [

            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios"

        ]

        WebServices.postRequest(url: Url.termsAndCondtions, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let tcData = try decoder.decode(TermsAndCondtions.self, from: data)

                if success{
                    DispatchQueue.main.async {
                        self.textview.attributedText = tcData.data?.terms_conditions?.htmlToAttributedString
                    }
                }

            } catch let error {
                print(error)
            }
        }



    }
    
    
    

}
