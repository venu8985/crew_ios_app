//
//  ResetPasswordViewController.swift
//  Crew
//
//  Created by Rajeev on 28/04/21.
//

import UIKit

class ResetPasswordViewController: UIViewController {

    var passwordTextfield : TitleTextfield!
    var confirmPasswordTextfield : TitleTextfield!
    
    var viewPasswrod1Button : UIButton!
    var viewPasswrod2Button : UIButton!
    
    var token : String!
    var id : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarItems()
        self.view.backgroundColor = .white
        // Password UI
        let passwordBGView = UIView()
        self.view.addSubview(passwordBGView)

        passwordBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(self.view).offset(10)
            make.height.equalTo(50)
        }

        passwordBGView.layer.borderColor = Color.liteGray.cgColor
        passwordBGView.layer.borderWidth = 0.5
        passwordBGView.layer.cornerRadius = 10.0
        passwordBGView.clipsToBounds = true

        let passwordImageView = UIImageView()
        passwordImageView.image = UIImage(named: "password")
        passwordImageView.contentMode = .scaleAspectFit
        passwordBGView.addSubview(passwordImageView)

        passwordImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        passwordTextfield = TitleTextfield()
        passwordTextfield.autocapitalizationType = .none
        passwordTextfield.placeholder = NSLocalizedString("Password", comment: "")
        passwordTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        passwordTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        passwordTextfield.isSecureTextEntry = true
        passwordBGView.addSubview(passwordTextfield)
        
        passwordTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        passwordTextfield.layer.borderWidth = 0
        
        let eye2Image = UIImage(named: "eye_black")
            //.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        viewPasswrod1Button = UIButton()
        viewPasswrod1Button.tag = 1
        viewPasswrod1Button.addTarget(self, action: #selector(viewPasswrodButtonAction), for: .touchUpInside)
        viewPasswrod1Button.setImage(eye2Image, for: .normal)
        viewPasswrod1Button.contentMode = .scaleAspectFit
        passwordBGView.addSubview(viewPasswrod1Button)
        
        viewPasswrod1Button.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(passwordBGView)
            make.width.equalTo(40)
        }
        
        // Password UI
        let confirmPasswordBGView = UIView()
        self.view.addSubview(confirmPasswordBGView)

        confirmPasswordBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(passwordBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        confirmPasswordBGView.layer.borderColor = Color.liteGray.cgColor
        confirmPasswordBGView.layer.borderWidth = 0.5
        confirmPasswordBGView.layer.cornerRadius = 10.0
        confirmPasswordBGView.clipsToBounds = true

        let confirmPasswordImageView = UIImageView()
        confirmPasswordImageView.image = UIImage(named: "password")
        confirmPasswordImageView.contentMode = .scaleAspectFit
        confirmPasswordBGView.addSubview(confirmPasswordImageView)

        confirmPasswordImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        confirmPasswordTextfield = TitleTextfield()
        confirmPasswordTextfield.isSecureTextEntry = true
        confirmPasswordTextfield.autocapitalizationType = .none
        confirmPasswordTextfield.placeholder = NSLocalizedString("Confirm Password", comment: "")
        confirmPasswordTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        confirmPasswordTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        confirmPasswordBGView.addSubview(confirmPasswordTextfield)
        
        confirmPasswordTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        confirmPasswordTextfield.layer.borderWidth = 0
        
        viewPasswrod2Button = UIButton()
        viewPasswrod2Button.tag = 2
        viewPasswrod2Button.addTarget(self, action: #selector(viewPasswrodButtonAction), for: .touchUpInside)
        viewPasswrod2Button.setImage(eye2Image, for: .normal)
        viewPasswrod2Button.contentMode = .scaleAspectFit
        confirmPasswordBGView.addSubview(viewPasswrod2Button)
        
        viewPasswrod2Button.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(confirmPasswordBGView)
            make.width.equalTo(40)
        }
        
        
        
        let confirmButton = UIButton()
        confirmButton.setTitle(NSLocalizedString("Update Password", comment: ""), for: .normal)
        confirmButton.backgroundColor = Color.red
        confirmButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        confirmButton.addTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
        self.view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.top.equalTo(confirmPasswordBGView.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
        }
        
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.clipsToBounds = true
        
    }
       
    @objc func confirmButtonAction(){
        if passwordTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please enter your password", comment: ""))
        }
        else if (passwordTextfield.text ?? "").count<6{
            errorBanner(error: NSLocalizedString("Password should not be less than six characters", comment: ""))
        }
        else if passwordTextfield.text != confirmPasswordTextfield.text{
            errorBanner(error: NSLocalizedString("Password and confirm password does not match", comment: ""))
        }else{
            changePassword()
        }
    }
    
    func changePassword(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "password" : passwordTextfield.text ?? "",
            "confirm_password" : confirmPasswordTextfield.text ?? "",
            "fcm_id" : UserDefaults.standard.value(forKey: FCM.token) ?? "",
            "hash_token" : token ?? "",
            "id" : id ?? ""
        ]
        
        WebServices.postRequest(url: Url.newPassword, params: parameters, viewController: self) { success,data  in
            if success{
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(NewPassword.self, from: data)
                    
                    if response.data?.data?.password == nil{
                        Banner().displaySuccess(string: NSLocalizedString("Password changed successfully", comment: ""))
                        self.navigationController?.popToRootViewController(animated: true)
                    }else{
                        UserDefaults.standard.setValue(response.data?.access_token, forKey: "token")
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc : ProfileSetupViewController = storyboard.instantiateViewController(withIdentifier: "ProfileSetupViewController") as! ProfileSetupViewController
                        vc.mobileNumberString = response.data?.data?.mobile
                        vc.isMediaAgency = (response.data?.data?.is_agency=="agency" ? true : false)
                        vc.hidePasswords = true
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }
                }catch let error{
                    print("\(error.localizedDescription)")
                }
                
                

            }
            
        }
        
    }
    
    func errorBanner(error:String){
        Banner().displayValidationError(string: error)
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Update Password", comment: "")
        
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
//        self.navigationController?.popViewController(animated: true)
        
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: ForgotViewController.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    
    @objc func viewPasswrodButtonAction(_ sender: UIButton){
        
        if sender.tag == 1{
            passwordTextfield.isSecureTextEntry = !passwordTextfield.isSecureTextEntry
            
            if passwordTextfield.isSecureTextEntry {
                let eye2Image = UIImage(named: "eye_black")
                    //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                viewPasswrod1Button.setImage(eye2Image, for: .normal)
            }else{
                let eye2Image = UIImage(named: "hide")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                viewPasswrod1Button.setImage(eye2Image, for: .normal)
            }
            
            
        }else{
            confirmPasswordTextfield.isSecureTextEntry = !confirmPasswordTextfield.isSecureTextEntry
            
            if confirmPasswordTextfield.isSecureTextEntry {
                let eye2Image = UIImage(named: "eye_black")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                viewPasswrod2Button.setImage(eye2Image, for: .normal)
            }else{
                let eye2Image = UIImage(named: "hide")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                viewPasswrod2Button.setImage(eye2Image, for: .normal)
            }
        }
        
    }

}
