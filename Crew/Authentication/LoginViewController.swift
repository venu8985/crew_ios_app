//
//  LoginViewController.swift
//  Crew
//
//  Created by Rajeev on 04/03/21.
//

import UIKit
import Alamofire
import ObjectMapper
import IQKeyboardManagerSwift

class LoginViewController: UIViewController {
    
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var acceptLabel: UILabel!
    @IBOutlet weak var mobileNumberView: UIView!
    @IBOutlet weak var passwordView: UIView!
    @IBOutlet weak var mobileNumberTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var forgotPasswordButton : UIButton!
    @IBOutlet weak var languageButton : UIButton!

    
    var isTick = false
    var isPassword = false
    
    @IBOutlet weak var signInWithButton: UIButton!
    @IBOutlet weak var acceptLabelGap: NSLayoutConstraint!
    
    var dial_code = "966"
    enum AuthType : String{
        case OTP = "OTP"
        case Password = "Password"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        mobileNumberView.semanticContentAttribute = .unspecified
        
        let globeImage = UIImage(named: "globe")
            //?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        languageButton.setImage(globeImage, for: .normal)

        let downImage = UIImage(named: "drop_down")
            //?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        countryCodeButton.setImage(downImage, for: .normal)
        countryCodeButton.setTitle(" +\(dial_code)  ", for: .normal)
        countryCodeButton.semanticContentAttribute = .forceRightToLeft

        NotificationCenter.default.addObserver(self, selector: #selector(self.suspendAuthenticationAction), name: Notification.dismissAuth, object: nil)

        let tickImage = UIImage(named: "untick")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFill)
        tickButton.setImage(tickImage, for: .normal)
        
        
        
        let acceptString: NSMutableAttributedString = NSMutableAttributedString(string: NSLocalizedString("I accept the T&C and Privacy Policy of Crew", comment: ""))
        let tcAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                            NSAttributedString.Key.foregroundColor: UIColor.red]
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            acceptString.addAttributes(tcAttributes, range: NSMakeRange(10, 11))
        }else{
            acceptString.addAttributes(tcAttributes, range: NSMakeRange(13, 4))
        }

        let privacyAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                                 NSAttributedString.Key.foregroundColor: UIColor.red]
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            acceptString.addAttributes(privacyAttributes, range: NSMakeRange(23, 12))
        }else{
            acceptString.addAttributes(privacyAttributes, range: NSMakeRange(21, 14))
        }
        
        acceptLabel.attributedText = acceptString
        acceptLabel.isUserInteractionEnabled = true
        acceptLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:))))
        
        passwordView.isHidden = true
        forgotPasswordButton.isHidden = true
        signInWithButton.setTitle(NSLocalizedString("Sign in with Password", comment: ""), for: .normal)
        
        
        
    }
    
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            languageButton.setTitle("English  ", for: .normal)
            passwordTextfield.textAlignment = .right
        }else{
            languageButton.setTitle("العربية", for: .normal)
            passwordTextfield.textAlignment = .left
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    @objc func tapLabel(gesture: UITapGestureRecognizer) {
        let text = NSLocalizedString("I accept the T&C and Privacy Policy of Crew", comment: "")
        
        let termsRange = (text as NSString).range(of: NSLocalizedString("T&C", comment: ""))
        // comment for now
        let privacyRange = (text as NSString).range(of: NSLocalizedString("Privacy Policy", comment: ""))
        
        if gesture.didTapAttributedTextInLabel(label: acceptLabel, inRange: termsRange) {
            //Tapped terms
            
            let vc = LegalViewController()
            vc.isPrivacy = false
            self.present(vc, animated: true, completion: nil)
            
        } else if gesture.didTapAttributedTextInLabel(label: acceptLabel, inRange: privacyRange) {
            //Tapped privacy
            let vc = LegalViewController()
            vc.isPrivacy = true
            self.present(vc, animated: true, completion: nil)
            
        } else {
            //Tapped none
        }
    }
    
    @IBAction func languageButtonAction(_ sender:UIButton){

        if UserDefaults.standard.value(forKey: "Language") as? String == "en"{
            Bundle.setLanguage("ar")
            UserDefaults.standard.setValue("ar", forKey: "Language")
            languageButton.setTitle("العربية", for: .normal)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft

        }else{
            Bundle.setLanguage("en")
            UserDefaults.standard.setValue("en", forKey: "Language")
            languageButton.setTitle("English", for: .normal)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
        AppDelegate.shared.window?.rootViewController = VC
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Done", comment: "")
        let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig

      }
    
    
    @IBAction func submitAction(_ sender : UIButton){
        
        if mobileNumberTextfield.text!.count<9 || mobileNumberTextfield.text!.count>14 {
            Banner().displayValidationError(string: NSLocalizedString("Please enter valid mobile number", comment: ""))
        }
        else if isPassword && passwordTextfield.text?.count == 0{
            Banner().displayValidationError(string: NSLocalizedString("Please enter password", comment: ""))
        }
        else if isPassword && passwordTextfield.text!.count < 6{
            Banner().displayValidationError(string: NSLocalizedString("Password must be minimum 6 characters", comment: ""))
        }
        else if !isTick{
            Banner().displayValidationError(string: NSLocalizedString("Please accept T&C and Privacy policy", comment: ""))
        }else {
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "login_mode" : isPassword ? AuthType.Password.rawValue : AuthType.OTP.rawValue,
                "dial_code" : dial_code,
                "mobile" : mobileNumberTextfield.text ?? "",
                "password" : isPassword ? passwordTextfield.text ?? "" : ""
            ]
            
            WebServices.postRequest(url: Url.login, params: parameters, viewController: self) { success,data  in
                do {
                    let decoder = JSONDecoder()
                                        
                    if success{
                        
                        if self.isPassword{
                            let response = try decoder.decode(LoginWithPassord.self, from: data)
                            UserDefaults.standard.setValue(response.data?.access_token, forKey: "token")
                            
                            
                            if let profileData = response.data?.data{
                                UserDetailsCrud().saveProfile(profile: profileData) { _ in
                                    //profile details updated in coredata
                                    Profile.shared.details = profileData
                                    
                                }
                            }
                           
                            DispatchQueue.main.async {
//                                NotificationCenter.default.post(name: Notification.dashboard, object: nil)

                                self.suspendAuthenticationAction(UIButton())
                            }
                        }else{
                            let otpResponse = try decoder.decode(Login.self, from: data)
                            
                            DispatchQueue.main.async {
                                
                                let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                                let vc : OTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                                vc.mobileNumber = self.mobileNumberTextfield.text
                                vc.token = otpResponse.data?.token ?? ""
                                vc.id = otpResponse.data?.id ?? 0
                                vc.dialCode = self.dial_code
                                vc.isForgotPassword = false
                                self.navigationController?.pushViewController(vc, animated: true)
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            Banner().displayValidationError(string: NSLocalizedString("Invalid Mobile number or password", comment: ""))
                        }
                    }
                    
                } catch let error {
                    DispatchQueue.main.async {
                        
                        Banner().displayValidationError(string: NSLocalizedString("Invalid Mobile number or password", comment: ""))
                        print(error)
                    }
                }
            }
        }
        
    }
    
    @IBAction func ForgotViewController(_ sender:Any){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ForgotViewController = storyboard.instantiateViewController(withIdentifier: "ForgotViewController") as! ForgotViewController
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func textfieldDidChange(_ sender: UITextField) {
        
        guard let mobileNumber = sender.text else { return }
        
        if mobileNumber.count<9 || mobileNumberTextfield.text!.count>14 {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = Color.liteGray
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }else{
            submitButton.isUserInteractionEnabled = true
            submitButton.backgroundColor = Color.red
            submitButton.setTitleColor(UIColor.white, for: .normal)
        }
                
    }
    @IBAction func suspendAuthenticationAction(_ sender: Any) {
        
        NotificationCenter.default.post(name: Notification.dashboard, object: nil)
        NotificationCenter.default.post(name: Notification.profile, object: nil)
        Profile.shared.details = nil
        //Deleting all previous records
        UserDetailsCrud().clearDatabase()
    
        //Fetching profile details to shared instance
        UserDetailsCrud().fetchProfiles(completion: { profileDetails in
            Profile.shared.details = profileDetails
        })
        
        UserDefaults.standard.setValue("Yes", forKey: "isExistingUser")
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    @IBAction func tickAction(_ sender: Any) {
        
        if isTick{
            let tickImage = UIImage(named: "untick")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            tickButton.setImage(tickImage, for: .normal)
        }else{
            let tickImage = UIImage(named: "tick")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            tickButton.setImage(tickImage, for: .normal)
        }
        isTick = !isTick
        
    }
    
    @IBAction func signInWithAction(_ sender: Any) {
        
        isPassword = !isPassword
        
        if isPassword{
            signInWithButton.setTitle(NSLocalizedString("Sign in with SMS", comment: ""), for: .normal)
            passwordView.isHidden = false
            forgotPasswordButton.isHidden = false
            acceptLabelGap.constant = 66
        }
        else{
            signInWithButton.setTitle(NSLocalizedString("Sign in with Password", comment: ""), for: .normal)
            passwordView.isHidden = true
            forgotPasswordButton.isHidden = true
            acceptLabelGap.constant = 16
        }
        
    }
    
    @IBAction func countryCodeAction(_ sender: Any) {
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country code", comment: "")
        ccVC.countryCodeDelegate = self
        self.present(ccVC, animated: true, completion: nil)
        
    }
    
    
}


@objc protocol countryCodeProtocol {
    
   @objc optional func selectedCountryCode(ccCode : String)
   @objc optional func selectedCountry(countryName : String, countryId : Int)
   @objc optional func selectedCity(cityName : String, cityId : Int)
   @objc optional func selectedNationality(nationality : String, id : Int)

}


extension LoginViewController : countryCodeProtocol{
   @objc func selectedCountryCode(ccCode: String) {
        countryCodeButton.setTitle("+\(ccCode)   ", for: .normal)
        dial_code = ccCode
    }
}
