//
//  ChangePasswordViewController.swift
//  Crew
//
//  Created by Rajeev on 22/03/21.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    
    var oldPasswordTextfield : UITextField!
    var newpasswordTextfield : UITextField!
    var confirmPasswordTextfield : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let passwordImage = UIImage(named: "password")//?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        let imageView = UIImageView();
        imageView.frame = CGRect(x: 0, y: 10, width: 25, height: 25)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        let image = passwordImage
        imageView.image = image;
        
        
        oldPasswordTextfield = UITextField()
        oldPasswordTextfield.placeholder = NSLocalizedString("Current Password", comment: "")
        oldPasswordTextfield.backgroundColor = .white
        oldPasswordTextfield.isSecureTextEntry = true
        oldPasswordTextfield.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(oldPasswordTextfield)
        
        oldPasswordTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(25)
            make.height.equalTo(44)
        }
        oldPasswordTextfield.layer.borderWidth = 0.5
        oldPasswordTextfield.layer.borderColor = UIColor.lightGray.cgColor
        oldPasswordTextfield.layer.cornerRadius = 5.0
        oldPasswordTextfield.clipsToBounds = true
        
        // Adding imageview on left
        oldPasswordTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: oldPasswordTextfield.frame.height))
        oldPasswordTextfield.addSubview(imageView)
        oldPasswordTextfield.leftView?.backgroundColor = .cyan
        oldPasswordTextfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        oldPasswordTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: oldPasswordTextfield.frame.height))
        oldPasswordTextfield.rightViewMode = .always
        
        
        let newImageView = UIImageView();
        newImageView.frame = CGRect(x: 0, y: 10, width: 25, height: 25)
        newImageView.image = image;
        
        newpasswordTextfield = UITextField()
        newpasswordTextfield.placeholder = NSLocalizedString("New Password", comment: "")
        newpasswordTextfield.backgroundColor = .white
        newpasswordTextfield.isSecureTextEntry = true
        newpasswordTextfield.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(newpasswordTextfield)
        
        newpasswordTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(oldPasswordTextfield.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        newpasswordTextfield.layer.borderWidth = 0.5
        newpasswordTextfield.layer.borderColor = UIColor.lightGray.cgColor
        newpasswordTextfield.layer.cornerRadius = 5.0
        newpasswordTextfield.clipsToBounds = true
        
        // Adding imageview on left
        newpasswordTextfield.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 30, height: oldPasswordTextfield.frame.height))
        newpasswordTextfield.addSubview(newImageView)
        newpasswordTextfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        newpasswordTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: newpasswordTextfield.frame.height))
        newpasswordTextfield.rightViewMode = .always
        
        
        
        let cnfImageView = UIImageView();
        cnfImageView.frame = CGRect(x: 0, y: 10, width: 25, height: 25)
        cnfImageView.image = image;
        
        confirmPasswordTextfield = UITextField()
        confirmPasswordTextfield.placeholder = NSLocalizedString("Confirm Password", comment: "")
        confirmPasswordTextfield.backgroundColor = .white
        confirmPasswordTextfield.isSecureTextEntry = true
        confirmPasswordTextfield.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(confirmPasswordTextfield)
        
        confirmPasswordTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(newpasswordTextfield.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        confirmPasswordTextfield.layer.borderWidth = 0.5
        confirmPasswordTextfield.layer.borderColor = UIColor.lightGray.cgColor
        confirmPasswordTextfield.layer.cornerRadius = 5.0
        confirmPasswordTextfield.clipsToBounds = true
        
        
        // Adding imageview on left
        confirmPasswordTextfield.leftView =  UIView(frame: CGRect(x: 0, y: 0, width: 30, height: oldPasswordTextfield.frame.height))
        confirmPasswordTextfield.addSubview(cnfImageView)
        confirmPasswordTextfield.leftViewMode = .always
        
        // Create a padding view for padding on right
        confirmPasswordTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: confirmPasswordTextfield.frame.height))
        confirmPasswordTextfield.rightViewMode = .always
        
        
        let submitButton = UIButton()
        submitButton.setTitle(NSLocalizedString("Change Password", comment: ""), for: .normal)
        submitButton.backgroundColor = Color.red
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        submitButton.addTarget(self, action: #selector(self.submitButtonAction), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(confirmPasswordTextfield.snp.bottom).offset(30)
        }
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        
        
        
        navigationBarItems()
        
    }
    
    @objc func submitButtonAction(){
        
        if oldPasswordTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Current password is required", comment: ""))
        }else if newpasswordTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("New password is required", comment: ""))
        }else if confirmPasswordTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Confirm password is required", comment: ""))
        }
        else if newpasswordTextfield.text != confirmPasswordTextfield.text{
            Banner().displayValidationError(string: NSLocalizedString("Password do not match", comment: ""))
        }
        else if newpasswordTextfield.text!.count<6{
            Banner().displayValidationError(string: NSLocalizedString("Password must be not less than 6 characters", comment: ""))
        }else{
            self.changePassword()
        }
        
    }
    
    func changePassword(){
        
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "password" : newpasswordTextfield.text ?? "",
            "confirm_password" : confirmPasswordTextfield.text ?? "",
            "old_password" : oldPasswordTextfield.text ?? ""
            
        ]
        
        WebServices.postRequest(url: Url.changePassword, params: parameters, viewController: self) { success,data  in
            
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Password changed successfully", comment: ""))
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        
    }
    
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        
//        self.navigationController?.navigationBar.isTranslucent = true
//        
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
    }
    
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Change Password", comment: "")
        
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
    
    
}
