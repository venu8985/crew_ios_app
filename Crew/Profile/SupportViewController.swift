//
//  SupportViewController.swift
//  Crew
//
//  Created by Rajeev on 22/03/21.
//

import UIKit

class SupportViewController: UIViewController {

    var nameTextfield : UITextField!
    var mobileTextfield : UITextField!
    var emailTextfield : UITextField!
    var countryCodeButton : UIButton!
    var dial_code = "966"
    var descriptionTextview : UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBarItems()
            
        nameTextfield = UITextField()
        nameTextfield.placeholder = NSLocalizedString("Name", comment: "")
        nameTextfield.backgroundColor = .white
        nameTextfield.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(nameTextfield)
        
        nameTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(25)
            make.height.equalTo(44)
        }
   
        
        if let myImage = UIImage(named: "name"){
            nameTextfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.black)
        }
        
        
        //Mobile textfield ui
        
        // Customising left view on left
            
        let mobileView = UIView()
        self.view.addSubview(mobileView)
            
        mobileView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(nameTextfield.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        
        mobileView.layer.borderWidth = 0.5
        mobileView.layer.borderColor = UIColor.lightGray.cgColor
        mobileView.layer.cornerRadius = 5.0
        mobileView.clipsToBounds = true
        
        
        
        let mobileLeftView =  UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 44))
        let downArrowImage = UIImage(named: "drop_down")?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        countryCodeButton = UIButton()
        countryCodeButton.frame = CGRect(x: 0, y: 0, width: 75, height: 44)
        countryCodeButton.setTitle(" + 966 ", for: .normal)
        countryCodeButton.setTitleColor(UIColor.black, for: .normal)
        countryCodeButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        countryCodeButton.setImage(downArrowImage, for: .normal)
        countryCodeButton.semanticContentAttribute = .forceRightToLeft
        countryCodeButton.addTarget(self, action: #selector(self.countryCodeButtonAction), for: .touchUpInside)
        mobileLeftView.addSubview(countryCodeButton)
     

        
        let lineView = UIView()
        lineView.frame = CGRect(x: 76, y: 0, width: 0.5, height: 44)
        lineView.backgroundColor = Color.gray
        mobileLeftView.addSubview(lineView)
        mobileView.addSubview(mobileLeftView)
        
        
        let mobileImage = UIImage(named: "mobile")?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        let mobileImageView = UIImageView();
        mobileImageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        mobileImageView.clipsToBounds = true
        mobileImageView.contentMode = .scaleAspectFit
        mobileImageView.image = mobileImage;
        
        //        emailField.leftView = imageView;
        
        mobileTextfield = UITextField()
        mobileTextfield.placeholder = NSLocalizedString("Mobile Number", comment: "")
        mobileTextfield.backgroundColor = .white
        mobileTextfield.keyboardType = .numberPad
        mobileTextfield.font = UIFont.systemFont(ofSize: 14.0)
        mobileView.addSubview(mobileTextfield)
        
        mobileTextfield.snp.makeConstraints { (make) in
            make.left.equalTo(mobileLeftView.snp.right)
            make.right.equalTo(mobileView)
            make.top.equalTo(mobileView)
            make.height.equalTo(44)
        }
          
//        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            mobileTextfield.rightView = mobileImageView
//            mobileTextfield.rightViewMode = .always
//
//            // Create a padding view for padding on right
//            mobileTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: mobileTextfield.frame.height))
//            mobileTextfield.leftViewMode = .always
//        }else{
            mobileTextfield.leftView = mobileImageView
            mobileTextfield.leftViewMode = .always
            
            // Create a padding view for padding on right
            mobileTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: mobileTextfield.frame.height))
            mobileTextfield.rightViewMode = .always
//        }
        

        

        
        
        //Email textfield
        emailTextfield = UITextField()
        emailTextfield.placeholder = NSLocalizedString("Email address", comment: "")
        emailTextfield.backgroundColor = .white
        emailTextfield.keyboardType = .emailAddress
        emailTextfield.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(emailTextfield)
        
        emailTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(mobileView.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
  

        if let myImage = UIImage(named: "email"){
            emailTextfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.black)
        }
 
        
        descriptionTextview = UITextView()
        descriptionTextview.delegate = self
        descriptionTextview.isScrollEnabled = false
        descriptionTextview.text = NSLocalizedString("Your comment", comment: "")
        descriptionTextview.textColor = UIColor.lightGray
        descriptionTextview.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(nameTextfield)
            make.top.equalTo(emailTextfield.snp.bottom).offset(10)
            make.height.greaterThanOrEqualTo(100)
            make.height.lessThanOrEqualTo(300)
        }
        descriptionTextview.layer.borderWidth = 1.0
        descriptionTextview.layer.borderColor = Color.liteGray.cgColor
        descriptionTextview.layer.cornerRadius = 5.0
        descriptionTextview.clipsToBounds = true
        
        
        
        
        let submitButton = UIButton()
        submitButton.setTitle(NSLocalizedString("Submit", comment: ""), for: .normal)
        submitButton.backgroundColor = Color.red
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        submitButton.addTarget(self, action: #selector(self.submitButtonAction), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(descriptionTextview.snp.bottom).offset(30)
        }
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        
        
        if Profile.shared.details != nil{
            
            mobileTextfield.text = Profile.shared.details?.mobile
            nameTextfield.text = Profile.shared.details?.name
            if let ccCode = Profile.shared.details?.dial_code{
                countryCodeButton.setTitle("+\(ccCode)   ", for: .normal)
            }
            emailTextfield.text = Profile.shared.details?.email
            
        }
        
    }
        
    @objc func submitButtonAction(){
        
        if nameTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Name can not be empty", comment: ""))
        }
        else if mobileTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Mobile Number can not be empty", comment: ""))
        }
        else if emailTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Email address can not be empty", comment: ""))
        }
        else if !isValidEmail(emailTextfield.text ?? ""){
            Banner().displayValidationError(string: NSLocalizedString("Please enter valid email address", comment: ""))

        }
        else if descriptionTextview.text == NSLocalizedString("Your comment", comment: ""){
            Banner().displayValidationError(string: NSLocalizedString("Your comment can not be empty", comment: ""))
        }
        else {
            self.supportRequest()
        }
        
    }
    
    func supportRequest(){
        
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "name" : nameTextfield.text ?? "",
            "dial_code" : dial_code,
            "mobile" : mobileTextfield.text ?? "",
            "email" : emailTextfield.text ?? "",
            "message" : descriptionTextview.text ?? ""
        ]
        
        WebServices.postRequest(url: Url.support, params: parameters, viewController: self) { success,data  in
            
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Request successfully submitted", comment: ""))
                self.navigationController?.popViewController(animated: true)
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))

            }
            
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Support", comment: "")
        
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
    
    @objc func countryCodeButtonAction(){
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country code", comment: "")
        ccVC.countryCodeDelegate = self
        self.present(ccVC, animated: true, completion: nil)
        
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}

extension SupportViewController : countryCodeProtocol{
    func selectedCountryCode(ccCode: String) {
        countryCodeButton.setTitle("+\(ccCode)   ", for: .normal)
        dial_code = ccCode
    }
}

extension SupportViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Your comment", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
}



extension UITextField {

enum Direction {
    case Left
    case Right
}

// add image to textfield
func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor){
    let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    mainView.layer.cornerRadius = 5

    let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 45))
    view.backgroundColor = .white
    mainView.addSubview(view)

    let imageView = UIImageView(image: image)
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
    view.addSubview(imageView)

    let seperatorView = UIView()
    seperatorView.backgroundColor = colorSeparator
    mainView.addSubview(seperatorView)

    if(Direction.Left == direction){ // image left
        seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: 45)
        self.leftViewMode = .always
        self.leftView = mainView
    } else { // image right
        seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: 45)
        self.rightViewMode = .always
        self.rightView = mainView
    }

    self.layer.borderColor = Color.liteGray.cgColor
    self.layer.borderWidth = CGFloat(1)
    self.layer.cornerRadius = 5
}

}
