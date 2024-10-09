//
//  LegalViewController.swift
//  Crew
//
//  Created by Rajeev on 16/03/21.
//

import UIKit

class LegalViewController: UIViewController {

    var isPrivacy : Bool!
    var textview : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        textview = UITextView()
        textview.frame = self.view.bounds
        textview.inputView = UIView()
        self.view.addSubview(textview)
        
        
       if isPrivacy{
            getPravicyPolicy()
        }else{
            getTermsAndConditions()
        }
        
        
        self.navigationBarItems()
    }
    
    
    func navigationBarItems() {
        
        
        
        if isPrivacy{
            self.title = NSLocalizedString("Privacy Policy", comment: "")
        }else{
            self.title = NSLocalizedString("Terms of service", comment: "")
        }
        
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
    
    func getPravicyPolicy(){
        
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios"
            
        ]
        
        WebServices.postRequest(url: Url.privacyPolicy, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let ppData = try decoder.decode(PrivacyPolicy.self, from: data)
                
                if success{
                    
                    DispatchQueue.main.async {
                        self.textview.attributedText = ppData.data?.privacy_policy?.htmlToAttributedString
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


extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}

