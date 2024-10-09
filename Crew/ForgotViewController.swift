//
//  ForgotViewController.swift
//  Crew
//
//  Created by Rajeev on 28/04/21.
//

import UIKit

class ForgotViewController: UIViewController {

    @IBOutlet weak var infoLabel : UILabel!
    @IBOutlet weak var mobileNumberTextfield : UITextField!
    var dial_code = "966"
    @IBOutlet weak var countryCodeButton: UIButton!
    @IBOutlet weak var submitButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBarItems()
        
        let downImage = UIImage(named: "drop_down")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        countryCodeButton.setImage(downImage, for: .normal)
        countryCodeButton.setTitle(" +\(dial_code)  ", for: .normal)
        countryCodeButton.semanticContentAttribute = .forceRightToLeft
        submitButton.backgroundColor = Color.liteGray

        
        let stringValue = NSLocalizedString("Please enter your mobile number to recieve verification code", comment: "")
        let attrString = NSMutableAttributedString(string: stringValue)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 0 // change line spacing between paragraph like 36 or 48
        style.minimumLineHeight = 20 // change line spacing between each line like 30 or 40
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSRange(location: 0, length: stringValue.count))
        infoLabel.attributedText = attrString
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        self.navigationController?.navigationBar.shadowImage = nil
        self.navigationController?.navigationBar.isTranslucent = false
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
    @IBAction func countryCodeAction(_ sender: Any) {
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country code", comment: "")
        ccVC.countryCodeDelegate = self
        self.present(ccVC, animated: true, completion: nil)
        
    }
    
    
    @IBAction func textfieldDidChange(_ sender: UITextField) {
        
        guard let mobileNumber = sender.text else { return }
        
        if mobileNumber.count<9 || mobileNumber.count>14 {
            submitButton.isUserInteractionEnabled = false
            submitButton.backgroundColor = Color.liteGray
            submitButton.setTitleColor(UIColor.gray, for: .normal)
        }else{
            submitButton.isUserInteractionEnabled = true
            submitButton.backgroundColor = Color.red
            submitButton.setTitleColor(UIColor.white, for: .normal)
        }
                
    }
    
    @IBAction func submitAction(_ sender:Any){
        
        
        
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "dial_code" : dial_code,
            "mobile" : mobileNumberTextfield.text ?? "",
        ]
        
        WebServices.postRequest(url: Url.forgotPassword, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                
                if success{
                    let response = try decoder.decode(ForgotPassword.self, from: data)
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : OTPViewController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
                    vc.mobileNumber = self.mobileNumberTextfield.text
                    vc.token = response.data?.token ?? ""
                    vc.id = response.data?.id ?? 0
                    vc.dialCode = self.dial_code
                    vc.isForgotPassword = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                
            } catch let error {
                DispatchQueue.main.async {
                    print(error)
                }
            }
        }
    }
}

extension ForgotViewController : countryCodeProtocol{
    
    @objc func selectedCountryCode(ccCode: String) {
         countryCodeButton.setTitle("+\(ccCode)   ", for: .normal)
         dial_code = ccCode
     }
    
}
