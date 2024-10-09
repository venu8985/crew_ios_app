//
//  OTPViewController.swift
//  Crew
//
//  Created by Rajeev on 09/03/21.
//

import UIKit
import OTPFieldView

class OTPViewController: UIViewController {

    
    @IBOutlet var otpTextFieldView: OTPFieldView!
    @IBOutlet var resendButton: UIButton!
    @IBOutlet var timerLabel : UILabel!
    @IBOutlet var resendLabel : UILabel!
    @IBOutlet var mobileNumberLabel : UILabel!

    var isForgotPassword : Bool!
    var timer : Timer!
    var interval = 60
    var token:String!
    var id:Int!
    var otpString : String!
    var mobileNumber : String!
    var dialCode : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.mobileNumberLabel.text = "+\(dialCode ?? "") - \(mobileNumber ?? "")"
        
        self.navigationBarItems()
        resendButton.isHidden = true
        self.timerLabel.isHidden = false
        self.resendLabel.isHidden = true

        self.otpTextFieldView.fieldsCount = 4
        self.otpTextFieldView.fieldBorderWidth = 1.0
        self.otpTextFieldView.defaultBorderColor = Color.liteGray
        self.otpTextFieldView.filledBorderColor = Color.liteBlack
        self.otpTextFieldView.cursorColor = UIColor.gray
        self.otpTextFieldView.displayType = .roundedCorner
        self.otpTextFieldView.fieldSize = 60
        self.otpTextFieldView.separatorSpace = 08
        self.otpTextFieldView.shouldAllowIntermediateEditing = false
        self.otpTextFieldView.delegate = self
        self.otpTextFieldView.initializeUI()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { _ in
            
            if self.interval == 0{
                self.resendButton.isHidden = false
                self.timerLabel.isHidden = false
                self.resendLabel.isHidden = false
                
            }else{
                self.interval -= 1
                
                self.hmsFrom(seconds: self.interval) { hours, minutes, seconds in
                    
                    let minutes = self.getStringFrom(seconds: minutes)
                    let seconds = self.getStringFrom(seconds: seconds)
                    self.timerLabel.text = "\(minutes):\(seconds)"
                }
            }
        })
        
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Mobile Verification", comment: "")
        
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
    
    @IBAction func resendButtonAction(_ sender: Any){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hash_token" : token ?? "",
            "id" : id ?? "",
        ]
        
        WebServices.postRequest(url: Url.otpResend, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let otpResponse = try decoder.decode(OTPResend.self, from: data)
                
                DispatchQueue.main.async {
                    
                    if success{
                        
                        self.id = otpResponse.data?.id
                        self.token = otpResponse.data?.token
                        
                        self.interval = 60
                        self.resendButton.isHidden = true
                        self.timerLabel.isHidden = false
                        self.resendLabel.isHidden = true
                        Banner().displaySuccess(string: otpResponse.message ?? NSLocalizedString("Success", comment: ""))
                        

                    }else{
                        
                        Banner().displayValidationError(string: NSLocalizedString("Invalid input", comment: ""))
                    }
                }
                
            } catch let error {
//                Banner().displayValidationError(string: NSLocalizedString("Invalid input", comment: ""))
                print(error)
            }
        }
        
    }

}

extension OTPViewController: OTPFieldViewDelegate {
    func hasEnteredAllOTP(hasEnteredAll hasEntered: Bool) -> Bool {
        print("Has entered all OTP? \(hasEntered)")
        
        if hasEntered{
            
            self.validateOTP()
            
        }
        
        return false
    }
    
    func shouldBecomeFirstResponderForOTP(otpTextFieldIndex index: Int) -> Bool {
        return true
    }
    
    func enteredOTP(otp otpString: String) {
        self.otpString = otpString
        print("OTPString: \(otpString)")
    }
    
    func hmsFrom(seconds: Int, completion: @escaping (_ hours: Int, _ minutes: Int, _ seconds: Int)->()) {

            completion(seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)

    }

    func getStringFrom(seconds: Int) -> String {

        return seconds < 10 ? "0\(seconds)" : "\(seconds)"
    }
    
    func validateOTP(){
               
        if isForgotPassword{
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "hash_token" : token ?? "",
                "id" : id ?? "",
                "otp" : otpString ?? "",
                "fcm_id" : UserDefaults.standard.value(forKey: FCM.token) ?? ""
            ]
            
            WebServices.postRequest(url: Url.forgotOTP, params: parameters, viewController: self) { success,data  in
                do {
                    let decoder = JSONDecoder()
                    let otpResponse = try decoder.decode(ForgotPassword.self, from: data)
                    
                    DispatchQueue.main.async {
                        if success{
                            let vc = ResetPasswordViewController()
                            vc.token = otpResponse.data?.token ?? ""
                            vc.id = otpResponse.data?.id ?? 0
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    }
                    
                } catch let error {
                    //                Banner().displayValidationError(string: NSLocalizedString("Invalid input", comment: ""))
                    print(error)
                }
            }
            
        }else {
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "hash_token" : token ?? "",
                "id" : id ?? "",
                "otp" : otpString ?? "",
                "fcm_id" : UserDefaults.standard.value(forKey: FCM.token) ?? ""
            ]
            
            WebServices.postRequest(url: Url.otpValidation, params: parameters, viewController: self) { success,data  in
                do {
                    let decoder = JSONDecoder()
                    let otpResponse = try decoder.decode(OTP.self, from: data)
                    
                    DispatchQueue.main.async {
                        
                        if success{
                            
                            //Bearer token
                            UserDefaults.standard.setValue(otpResponse.data?.access_token, forKey: "token")
                            
                            if let profileData = otpResponse.data?.data{
                                //Deleting all previous records
                                UserDetailsCrud().clearDatabase()
                                UserDetailsCrud().saveProfile(profile: profileData) { _ in
                                    //profile details updated in coredata
                                    Profile.shared.details = profileData
                                }
                                
                                if profileData.name != nil{
                                    self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
                                    NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                                    NotificationCenter.default.post(name: Notification.profile, object: nil)
                                    UserDefaults.standard.setValue("Yes", forKey: "isExistingUser")                                   
                                    
                                    //Fetching profile details to shared instance
                                    UserDetailsCrud().fetchProfiles(completion: { profileDetails in
                                        Profile.shared.details = profileDetails
                                    })
                                }
                                
                                else{
                                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                    let vc : WhoAreYouViewController = storyboard.instantiateViewController(withIdentifier: "WhoAreYouViewController") as! WhoAreYouViewController
                                    vc.mobileNumberString = self.mobileNumber
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                            }
                            
                        }else{
                            Banner().displayValidationError(string: NSLocalizedString("Invalid OTP", comment: ""))
                        }
                    }
                    
                } catch let error {
                    print(error)
                }
            }
            
        }
        
    }
            
}
