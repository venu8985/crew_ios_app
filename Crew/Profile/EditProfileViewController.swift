//
//  SetupProfileViewController.swift
//  Crew
//
//  Created by Rajeev on 23/03/21.
//

import UIKit
import AWSS3
import AWSCore
class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var imagePicker : UIImagePickerController!
    var profileImageView : UIImageView!
    var fullNameTextfield : UITextField!
    var emailAddressTextfield : UITextField!
    var countryTextfield : TitleTextfield!
    var cityTextfield : TitleTextfield!
    var nationalityTextfield : TitleTextfield!
    var nationalityIDTextfield : TitleTextfield!
    var crnTextfield : TitleTextfield!
    var crnImageView : UIImageView!
    var idAttachmentBGView : UIView!
    var idAttachmentImageView : UIImageView!
    var idAttachmentLabel : UILabel!
    var uploadType:String!
    
    var countryID     : Int!
    var cityID        : Int!
    var nationalityID : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        
        nationalityID = Profile.shared.details?.nationality_id
        countryID = Profile.shared.details?.country_id
        cityID = Profile.shared.details?.city_id
        navigationBarItems()
        
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        
        
        
        
        let profilePicurl = Url.userProfile + (Profile.shared.details?.profile_image ?? "")
        profileImageView = UIImageView()
        profileImageView.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        profileImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(scrollView).offset(25)
            make.width.height.equalTo(120)
        }
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        
        
        let cameraImageView = UIImageView()
        cameraImageView.image = UIImage(named: "camera")
        cameraImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(cameraImageView)
        
        cameraImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(-25)
            make.top.equalTo(profileImageView).offset(75)
            make.width.height.equalTo(40)
        }
        
        cameraImageView.layer.cornerRadius = 20
        cameraImageView.clipsToBounds = true
        scrollView.bringSubviewToFront(cameraImageView)

        
        cameraImageView.isUserInteractionEnabled = true
        cameraImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(imagePickerAction)))
        profileImageView.isUserInteractionEnabled = true
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(imagePickerAction)))

        
        let deleteImageLabel = UILabel()
        deleteImageLabel.text = NSLocalizedString("Delete Profile Image", comment: "")
        deleteImageLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        deleteImageLabel.textAlignment = .center
        scrollView.addSubview(deleteImageLabel)
        
        deleteImageLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
        deleteImageLabel.isUserInteractionEnabled = true
        deleteImageLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(deleteProfileImage)))

        
        
        let mobileTextfield = UITextField()
        mobileTextfield.placeholder = NSLocalizedString("Mobile Number", comment: "")
        mobileTextfield.backgroundColor = .white
        mobileTextfield.text = Profile.shared.details?.mobile
        mobileTextfield.isUserInteractionEnabled = false
        mobileTextfield.keyboardType = .emailAddress
        mobileTextfield.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(mobileTextfield)
        
        mobileTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(deleteImageLabel.snp.bottom).offset(20)
            make.height.equalTo(44)
        }
        if let myImage = UIImage(named: "mobile"){
            mobileTextfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.black)
        }
        
        fullNameTextfield = UITextField()
        fullNameTextfield.placeholder = NSLocalizedString("Full Name", comment: "")
        fullNameTextfield.text = Profile.shared.details?.name
        fullNameTextfield.backgroundColor = .white
        fullNameTextfield.keyboardType = .emailAddress
        fullNameTextfield.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(fullNameTextfield)
        
        fullNameTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(mobileTextfield.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        if let myImage = UIImage(named: "name"){
            fullNameTextfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.black)
        }
 

        
        emailAddressTextfield = UITextField()
        emailAddressTextfield.placeholder = NSLocalizedString("Email address", comment: "")
        emailAddressTextfield.text = Profile.shared.details?.email
        emailAddressTextfield.backgroundColor = .white
        emailAddressTextfield.keyboardType = .emailAddress
        emailAddressTextfield.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(emailAddressTextfield)
        
        emailAddressTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(fullNameTextfield.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        if let myImage = UIImage(named: "email"){
            emailAddressTextfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.clear, colorBorder: UIColor.black)
        }
        
        
        let countryBGView = UIView()
        scrollView.addSubview(countryBGView)

        countryBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(emailAddressTextfield.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        countryBGView.layer.borderColor = Color.liteGray.cgColor
        countryBGView.layer.borderWidth = 0.5
        countryBGView.layer.cornerRadius = 10.0
        countryBGView.clipsToBounds = true
        
        
        let countryImageView = UIImageView()
        countryImageView.image = UIImage(named: "country")
        countryImageView.contentMode = .scaleAspectFit
        countryBGView.addSubview(countryImageView)

        countryImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        countryTextfield = TitleTextfield()
        countryTextfield.keyboardType = .emailAddress
        countryTextfield.autocapitalizationType = .none
        countryTextfield.placeholder = NSLocalizedString("Country", comment: "")
        countryTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        countryTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        countryTextfield.text = Profile.shared.details?.country_name
        countryTextfield.inputView = UIView()
        countryBGView.addSubview(countryTextfield)
        
        countryTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        countryTextfield.layer.borderWidth = 0
        countryTextfield.isUserInteractionEnabled = true
        countryTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openCountries)))
        
        let countryDropDown = UIButton()
        countryDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        countryDropDown.contentMode = .scaleAspectFit
        countryBGView.addSubview(countryDropDown)
        
        countryDropDown.snp.makeConstraints { (make) in
            make.trailing.equalTo(countryBGView).offset(-5)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        
        let cityBGView = UIView()
        scrollView.addSubview(cityBGView)

        cityBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(countryBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        cityBGView.layer.borderColor = Color.liteGray.cgColor
        cityBGView.layer.borderWidth = 0.5
        cityBGView.layer.cornerRadius = 10.0
        cityBGView.clipsToBounds = true
        
        let cityImageView = UIImageView()
        cityImageView.image = UIImage(named: "city")
        cityImageView.contentMode = .scaleAspectFit
        cityBGView.addSubview(cityImageView)

        cityImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        cityTextfield = TitleTextfield()
        cityTextfield.keyboardType = .emailAddress
        cityTextfield.autocapitalizationType = .none
        cityTextfield.text = Profile.shared.details?.city_name
        cityTextfield.placeholder = NSLocalizedString("City", comment: "")
        cityTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        cityTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        cityTextfield.inputView = UIView()
        cityBGView.addSubview(cityTextfield)
        
        cityTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        cityTextfield.layer.borderWidth = 0
        cityTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openCities)))

        let cityDropDown = UIButton()
        cityDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        cityDropDown.contentMode = .scaleAspectFit
        cityBGView.addSubview(cityDropDown)
        
        cityDropDown.snp.makeConstraints { (make) in
            make.trailing.equalTo(countryBGView).offset(-5)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        
        //Nationality UI
        
        let nationalityBGView = UIView()
        scrollView.addSubview(nationalityBGView)

        nationalityBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(cityBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        nationalityBGView.layer.borderColor = Color.liteGray.cgColor
        nationalityBGView.layer.borderWidth = 0.5
        nationalityBGView.layer.cornerRadius = 10.0
        nationalityBGView.clipsToBounds = true
        
        let nationalityImageView = UIImageView()
        nationalityImageView.image = UIImage(named: "nationality")
        nationalityImageView.contentMode = .scaleAspectFit
        nationalityBGView.addSubview(nationalityImageView)

        nationalityImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }
        
        nationalityTextfield = TitleTextfield()
        nationalityTextfield.keyboardType = .emailAddress
        nationalityTextfield.autocapitalizationType = .none
        nationalityTextfield.text = Profile.shared.details?.nationality_name
        nationalityTextfield.placeholder = NSLocalizedString("Nationality", comment: "")
        nationalityTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        nationalityTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        nationalityTextfield.inputView = UIView()
        nationalityBGView.addSubview(nationalityTextfield)
        
        nationalityTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-50)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        nationalityTextfield.layer.borderWidth = 0
        nationalityTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openNationality)))

        
        let nationalityDropDown = UIButton()
        nationalityDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        nationalityDropDown.contentMode = .scaleAspectFit
        nationalityBGView.addSubview(nationalityDropDown)
        
        nationalityDropDown.snp.makeConstraints { (make) in
            make.trailing.equalTo(countryBGView).offset(-5)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        // CRN UI
        let crnBGView = UIView()
        scrollView.addSubview(crnBGView)

        crnBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(nationalityBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        crnBGView.layer.borderColor = Color.liteGray.cgColor
        crnBGView.layer.borderWidth = 0.5
        crnBGView.layer.cornerRadius = 10.0
        crnBGView.clipsToBounds = true

        crnImageView = UIImageView()
        crnImageView.image = UIImage(named: "Registration_no")
        crnImageView.contentMode = .scaleAspectFit
        crnBGView.addSubview(crnImageView)

        crnImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        crnTextfield = TitleTextfield()
        crnTextfield.autocapitalizationType = .none
        crnTextfield.placeholder = NSLocalizedString("Commercial Registration Number", comment: "")
        crnTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        crnTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        crnTextfield.text = Profile.shared.details?.cr_number
        crnBGView.addSubview(crnTextfield)
        
        crnTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        crnTextfield.layer.borderWidth = 0
        
        //ID number
        //Nationality UI
        
        let nationalityIDBGView = UIView()
        scrollView.addSubview(nationalityIDBGView)

        nationalityIDBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(crnBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        nationalityIDBGView.layer.borderColor = Color.liteGray.cgColor
        nationalityIDBGView.layer.borderWidth = 0.5
        nationalityIDBGView.layer.cornerRadius = 10.0
        nationalityIDBGView.clipsToBounds = true

        let nationalityIDImageView = UIImageView()
        nationalityIDImageView.image = UIImage(named: "national_id")
        nationalityIDImageView.contentMode = .scaleAspectFit
        nationalityIDBGView.addSubview(nationalityIDImageView)

        nationalityIDImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        nationalityIDTextfield = TitleTextfield()
        nationalityIDTextfield.keyboardType = .emailAddress
        nationalityIDTextfield.autocapitalizationType = .none
        nationalityIDTextfield.text = String(Int(Profile.shared.details?.nationality_id ?? 0))
        nationalityIDTextfield.placeholder = NSLocalizedString("ID Number", comment: "")
        nationalityIDTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        nationalityIDTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        nationalityIDBGView.addSubview(nationalityIDTextfield)

        nationalityIDTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        nationalityIDTextfield.layer.borderWidth = 0
        

        //ID attachment
        idAttachmentBGView = UIView()
        scrollView.addSubview(idAttachmentBGView)
        
        idAttachmentBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(nationalityIDBGView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }
        
        idAttachmentImageView = UIImageView()
        idAttachmentImageView.image = UIImage(named: "camera_image")
        idAttachmentImageView.contentMode = .scaleAspectFit
        idAttachmentBGView.addSubview(idAttachmentImageView)

        idAttachmentImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
        }
       
        idAttachmentLabel = UILabel()
        idAttachmentLabel.text = NSLocalizedString("ID Photo Attachment", comment: "")
        idAttachmentLabel.textColor = Color.liteGray
        idAttachmentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        idAttachmentBGView.addSubview(idAttachmentLabel)
        
        idAttachmentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(idAttachmentImageView.snp.trailing).offset(20)
            make.trailing.equalTo(idAttachmentBGView).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        let idurl = Url.id_cards + (Profile.shared.details?.id_card_image ?? "")
        idAttachmentImageView.sd_setImage(with: URL(string: idurl), placeholderImage: UIImage(named: "camera_image"), options: [], progress: nil, completed: nil)
        idAttachmentLabel.text = Profile.shared.details?.id_card_image ?? ""
        idAttachmentLabel.textColor = Color.liteBlack
        
        idAttachmentLabel.isUserInteractionEnabled = true
        idAttachmentBGView.isUserInteractionEnabled = true
        idAttachmentImageView.isUserInteractionEnabled = true
        idAttachmentLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(showIdOptions)))
        idAttachmentBGView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(showIdOptions)))
        idAttachmentImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(showIdOptions)))

        
        let saveButton = UIButton()
        saveButton.setTitle(NSLocalizedString("Save Profile", comment: ""), for: .normal)
        saveButton.backgroundColor = Color.red
        saveButton.setTitleColor(Color.liteWhite, for: .normal)
        saveButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Black", size: 14)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        self.view.addSubview(saveButton)

        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(idAttachmentBGView.snp.bottom).offset(20)
        }

        saveButton.layer.cornerRadius = 5.0
        saveButton.clipsToBounds = true
        
    }
    
    @objc func showIdOptions(){
        
        // handling code
        uploadType = "ID-Card"
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Choose option to upload ID card", comment: "") , preferredStyle: UIAlertController.Style.actionSheet) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let gallertyAction = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.openGallary()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.openCamera()
        }
        
        alertController.addAction(gallertyAction)
        alertController.addAction(cameraAction)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Edit Profile", comment: "")
        
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


    
    //MARK: image picker
    @objc func imagePickerAction() {
        // handling code
        uploadType = "ProfilePic"
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Choose option to upload picture", comment: "") , preferredStyle: UIAlertController.Style.actionSheet) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let gallertyAction = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.openGallary()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.openCamera()
        }
        
        alertController.addAction(gallertyAction)
        alertController.addAction(cameraAction)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    @objc func openCountries(){
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country", comment: "")//"Search country"
        ccVC.countryCodeDelegate = self
        self.navigationController?.pushViewController(ccVC, animated: true)
    }
    @objc func openCities(){
        
        if self.countryID == nil{
            Banner().displayValidationError(string: NSLocalizedString("Please select country to proceed", comment: ""))
            return
        }
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search city", comment: "")
        ccVC.countryCodeDelegate = self
        ccVC.countryId = self.countryID
        self.navigationController?.pushViewController(ccVC, animated: true)

    }
    @objc func openNationality(){
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Nationality", comment: "")//"Search country"
        ccVC.countryCodeDelegate = self
        self.navigationController?.pushViewController(ccVC, animated: true)
    }
    
    func openGallary(){
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            DispatchQueue.main.async {
                
                if self.uploadType == "ProfilePic"{
                    self.profileImageView.image = pickedImage
                    self.profileImageView.contentMode = .scaleAspectFill
                }else{
                    self.idAttachmentImageView.image = pickedImage
                    self.idAttachmentLabel.contentMode = .scaleAspectFill
                }
                
                
            }
            
            if self.uploadType == "ProfilePic"{
                let imageData = pickedImage.compress(to: 300)
                uploadFile(awsBucket: AWSBucket.uploadUser, fileData: imageData, mimeType: "image/jpg", ext: "jpg") { (response, image) in
                    
                    DispatchQueue.main.async {
                        self.updateProfileImage(profilePic: image)
                    }
                }
            }else{
                let imageData = pickedImage.compress(to: 300)
                uploadFile(awsBucket: AWSBucket.id_card, fileData: imageData, mimeType: "image/jpg", ext: "jpg") { (response, image) in
                    
                    DispatchQueue.main.async {
                        self.idAttachmentLabel.text = image
                    }
                }
            }
               
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    //MARK: uploading image to aws
    
    func uploadFile(awsBucket:String,fileData: Data, mimeType : String, ext : String, completion: @escaping(String, String) -> Void) {
        
        GGProgress.shared.show(with: "Uploading...")

        
        let imgName = AppDelegate.randomString(length: 12) + ".\(ext)"
        
        let keyname = "\(awsBucket)/" +  imgName

           let fileManager = FileManager.default
           let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("\(imgName)")
          // let imageData = image.jpegData(compressionQuality: 0)
           fileManager.createFile(atPath: path as String, contents: fileData, attributes: nil)
           
           let fileUrl = NSURL(fileURLWithPath: path)
           
           let uploadRequest = AWSS3TransferManagerUploadRequest()!
           uploadRequest.body = fileUrl as URL
           uploadRequest.key = keyname
           uploadRequest.bucket = UserDefaults.standard.value(forKey: AWS.AWS_BUCKET) as? String ?? ""
           uploadRequest.contentType = mimeType
           uploadRequest.acl = .publicRead
           
           let transferManager = AWSS3TransferManager.default()
           transferManager.upload(uploadRequest).continueWith(block: { (task: AWSTask) -> Any? in
               if let error = task.error {
                debugPrint("Upload failed with error: (\(error.localizedDescription))")
               }
              
               if task.result != nil {
                   let url = AWSS3.default().configuration.endpoint.url
                   let publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                DispatchQueue.main.async {
                    GGProgress.shared.hide()
                }

                   completion("\(publicURL!)", imgName)
               }
               return nil
           })
       }
    
    
    @objc func updateProfileImage(profilePic : String){
        
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "profile_image" : profilePic
        ]
        
        self.updateDeleteProfileImageAPI(params: parameters)
    }
    
    @objc func deleteProfileImage(){
        
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        profileImageView.image = placeHolderImage
        self.updateDeleteProfileImageAPI(params: parameters)
    }
    
    
    func updateDeleteProfileImageAPI(params:[String:Any]){
        
        WebServices.postRequest(url: Url.updateDeleteProfileImage, params: params, viewController: self) { success,data  in
            
            if success{
                do {
                    let decoder = JSONDecoder()
                    let profileResponse = try decoder.decode(CompleteProfile.self, from: data)
                    if let profileData = profileResponse.data{
                        UserDetailsCrud().saveProfile(profile: profileData) { _ in
                            Profile.shared.details = profileData
                        }
                    }
                    Banner().displaySuccess(string: NSLocalizedString("Profile updated successfully", comment: ""))
                   // self.navigationController?.popViewController(animated: true)
                }catch let error {
                    print("error \(error.localizedDescription)")
                }
            }
            else {
                Banner().displaySuccess(string: NSLocalizedString("Profile Picture could not upload, Please try again later", comment: ""))
            }
            
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    //MARK: update profile
    
    @objc func saveButtonAction(){
        
        if fullNameTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please enter your email address", comment: ""))
            return
        }
        if !isValidEmail(emailAddressTextfield.text ?? ""){
            errorBanner(error: NSLocalizedString("Please enter valid email address", comment: ""))
            return
        }
        
        
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "name" : fullNameTextfield.text ?? "",
            "email" : emailAddressTextfield.text ?? "",
            "id_number": nationalityIDTextfield.text ?? "",
            "id_card_image": idAttachmentLabel.text ?? "",
            "nationality_id" : nationalityID ?? 0,
            "country_id" : countryID ?? 0,
            "city_id" : cityID ?? 0
        ]
        
        WebServices.postRequest(url: Url.updateProfile, params: parameters, viewController: self) { success,data  in
            
            if success{
                
                do {
                    let decoder = JSONDecoder()
                    let profileResponse = try decoder.decode(CompleteProfile.self, from: data)
                    if let profileData = profileResponse.data{
                        
                        Profile.shared.details = profileData

                        UserDetailsCrud().saveProfile(profile: profileData) { _ in
                            Profile.shared.details = profileData
                        }
                    }
                    Banner().displaySuccess(string: NSLocalizedString("Profile updated successfully", comment: ""))
                    self.navigationController?.popViewController(animated: true)
                }catch let error {
                    print("error \(error.localizedDescription)")
                }
                
            }
        }
                
    }
    
    func errorBanner(error:String){
        Banner().displayValidationError(string: error)
    }
    
    
}

extension UIImage {

func resized(withPercentage percentage: CGFloat) -> UIImage? {
    let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
    UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
    defer { UIGraphicsEndImageContext() }
    draw(in: CGRect(origin: .zero, size: canvasSize))
    return UIGraphicsGetImageFromCurrentImageContext()
}

func resizedTo200KB() -> UIImage? {
    guard let imageData = self.pngData() else { return nil }

    var resizingImage = self
    var imageSizeKB = Double(imageData.count) / 9000.0 // ! Or devide for 1024 if you need KB but not kB

    while imageSizeKB > 1000 { // ! Or use 1024 if you need KB but not kB
        guard let resizedImage = resizingImage.resized(withPercentage: 0.9),
              let imageData = resizedImage.pngData()
            else { return nil }

        resizingImage = resizedImage
        imageSizeKB = Double(imageData.count) / 9000.0 // ! Or devide for 1024 if you need KB but not kB
    }

    return resizingImage
}
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }

    func compress(to kb: Int, allowedMargin: CGFloat = 0.2) -> Data {
        let bytes = kb * 1024
        var compression: CGFloat = 1.0
        let step: CGFloat = 0.05
        var holderImage = self
        var complete = false
        while(!complete) {
            if let data = holderImage.jpegData(compressionQuality: 1.0) {
                let ratio = data.count / bytes
                if data.count < Int(CGFloat(bytes) * (1 + allowedMargin)) {
                    complete = true
                    return data
                } else {
                    let multiplier:CGFloat = CGFloat((ratio / 5) + 1)
                    compression -= (step * multiplier)
                }
            }
            
            guard let newImage = holderImage.resized(withPercentage: compression) else { break }
            holderImage = newImage
        }
        return Data()
    }
}


extension EditProfileViewController : countryCodeProtocol{
    
    @objc func selectedCountry(countryName : String, countryId : Int){
        self.countryTextfield.text = countryName
        self.countryID = countryId
        
        cityTextfield.text = nil
        self.cityID = nil
    }
    
    
    @objc func selectedCity(cityName: String, cityId: Int) {
        cityTextfield.text = cityName
        self.cityID = cityId
    }

    @objc func selectedNationality(nationality: String, id: Int) {
        nationalityTextfield.text = nationality
        self.nationalityID = id
    }
    
}
