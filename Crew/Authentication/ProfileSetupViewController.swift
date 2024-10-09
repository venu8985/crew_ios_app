//
//  ProfileSetupViewController.swift
//  Crew
//
//  Created by Rajeev on 09/03/21.
//

import UIKit
import AWSS3
import AWSCore
import MobileCoreServices
import SafariServices
import SkyFloatingLabelTextField
import IQKeyboardManagerSwift

class ProfileSetupViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,SignatureDelegate, UIDocumentPickerDelegate {

    var profileImageView          : UIImageView!
    var signatureButton           : UIButton!
    var mobileTextfield           : TitleTextfield!
    var fullNameTextfield         : TitleTextfield!
    var emailTextfield            : TitleTextfield!
    var nationalityTextfield      : TitleTextfield!
    var countryTextfield          : TitleTextfield!
    var cityTextfield             : TitleTextfield!
    var nationalityIDTextfield    : TitleTextfield!
    var passwordTextfield         : TitleTextfield!
    var confirmPasswordTextfield  : TitleTextfield!
    var crnTextfield              : TitleTextfield!
    var idAttachmentBGView        : UIView!
    var idAttachmentLabel         : UILabel!
    var attachmentLabel           : UILabel!
    var attachmentBGView          : UIView!
    var attachmentImageView       : UIImageView!
    var idAttachmentImageView     : UIImageView!
    var mobileNumberString        : String!
    var imagePicker               : UIImagePickerController!
    var isMediaAgency             : Bool!
    var viewPasswrod1Button       : UIButton!
    var viewPasswrod2Button       : UIButton!
    var nationalityDropDown       : UIButton!
    var countryDropDown           : UIButton!
    var cityDropDown           : UIButton!
    var hidePasswords : Bool!
    //CDN variables
    var profileImageCDNString : String!
    var userSignatureCDNString : String!
    var crnAttachmentCDNString : String!
    var idAttachmentCDNString : String!
    
    var countryID     : Int!
    var cityID        : Int!
    var nationalityID : Int!
    var isPhotoId : Bool!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1150)
        
        
        profileImageView = UIImageView()
        profileImageView.image = UIImage(named: "add_profile")
        scrollView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(120)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(10)
        }
        
        let profileLabel = UILabel()
        profileLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        profileLabel.text = NSLocalizedString("Add Profile Image", comment: "")
        scrollView.addSubview(profileLabel)
        
        profileLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(profileImageView.snp.bottom).offset(10)
        }
        
 
        
        
        
        // Mobile number UI
        let mobileBGView = UIView()
        scrollView.addSubview(mobileBGView)

        mobileBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(profileLabel.snp.bottom).offset(40)
            make.height.equalTo(50)
        }

        mobileBGView.layer.borderColor = Color.liteGray.cgColor
        mobileBGView.layer.borderWidth = 0.5
        mobileBGView.layer.cornerRadius = 10.0
        mobileBGView.clipsToBounds = true

        let mobileImageView = UIImageView()
        mobileImageView.image = UIImage(named: "mobile")
        mobileImageView.contentMode = .scaleAspectFit
        mobileBGView.addSubview(mobileImageView)

        mobileImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        mobileTextfield = TitleTextfield()
        mobileTextfield.text = mobileNumberString
        mobileTextfield.autocapitalizationType = .none
        mobileTextfield.placeholder = NSLocalizedString("Mobile Number", comment: "")
        mobileTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        mobileTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        mobileBGView.addSubview(mobileTextfield)

        mobileTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(35)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        mobileTextfield.layer.borderWidth = 0
        mobileTextfield.inputView = UIView()
        mobileTextfield.isUserInteractionEnabled = false
        
        let mandatoryLabel = UILabel()
        mandatoryLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        mandatoryLabel.text = NSLocalizedString("All fields are mandatory", comment: "")
        mandatoryLabel.textColor = Color.red
        scrollView.addSubview(mandatoryLabel)
        
        mandatoryLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(mobileBGView)
            make.bottom.equalTo(mobileBGView.snp.top).offset(-5)
        }
       
        // Full name UI
        let fullNameBGView = UIView()
        scrollView.addSubview(fullNameBGView)

        fullNameBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(mobileBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        fullNameBGView.layer.borderColor = Color.liteGray.cgColor
        fullNameBGView.layer.borderWidth = 0.5
        fullNameBGView.layer.cornerRadius = 10.0
        fullNameBGView.clipsToBounds = true

        let fullNameImageView = UIImageView()
        fullNameImageView.image = UIImage(named: "name")
        fullNameImageView.contentMode = .scaleAspectFit
        fullNameBGView.addSubview(fullNameImageView)

        fullNameImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        fullNameTextfield = TitleTextfield()
        fullNameTextfield.autocapitalizationType = .none
        fullNameTextfield.placeholder = NSLocalizedString("Full Name", comment: "")
        fullNameTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        fullNameTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        fullNameBGView.addSubview(fullNameTextfield)
        
        fullNameTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        fullNameTextfield.layer.borderWidth = 0
        
       
        // Email address UI
        let emailBGView = UIView()
        scrollView.addSubview(emailBGView)

        emailBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(fullNameBGView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        emailBGView.layer.borderColor = Color.liteGray.cgColor
        emailBGView.layer.borderWidth = 0.5
        emailBGView.layer.cornerRadius = 10.0
        emailBGView.clipsToBounds = true

        let emailImageView = UIImageView()
        emailImageView.image = UIImage(named: "email")
        emailImageView.contentMode = .scaleAspectFit
        emailBGView.addSubview(emailImageView)

        emailImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(25)
        }

        emailTextfield = TitleTextfield()
        emailTextfield.keyboardType = .emailAddress
        emailTextfield.autocapitalizationType = .none
        emailTextfield.placeholder = NSLocalizedString("Email address", comment: "")
        emailTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        emailTextfield.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        emailBGView.addSubview(emailTextfield)
        
        emailTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        emailTextfield.layer.borderWidth = 0
        
        
        
        // Password UI
        let passwordBGView = UIView()
        scrollView.addSubview(passwordBGView)

        passwordBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(emailBGView.snp.bottom).offset(10)
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
        
        let eye2Image = UIImage(named: "eye_black")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
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
        scrollView.addSubview(confirmPasswordBGView)

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
        
        if hidePasswords{
            passwordBGView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view).inset(20)
                make.top.equalTo(emailBGView.snp.bottom).offset(10)
                make.height.equalTo(0)
            }
            
            confirmPasswordBGView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view).inset(20)
                make.top.equalTo(emailBGView.snp.bottom).offset(10)
                make.height.equalTo(0)
            }

        }
        
        
        //Country UI
        
        let countryBGView = UIView()
        scrollView.addSubview(countryBGView)

        countryBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(confirmPasswordBGView.snp.bottom).offset(10)
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

        
        countryDropDown = UIButton()
//        nationalityDropDown.addTarget(self, action: #selector(viewPasswrodButtonAction), for: .touchUpInside)
        countryDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        countryDropDown.contentMode = .scaleAspectFit
        countryBGView.addSubview(countryDropDown)
        
        countryDropDown.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(countryBGView)
            make.width.equalTo(40)
        }
        
        
        //City UI
        
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
        
        
        cityTextfield.isUserInteractionEnabled = true
        cityTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openCities)))

        
        cityDropDown = UIButton()
//        nationalityDropDown.addTarget(self, action: #selector(viewPasswrodButtonAction), for: .touchUpInside)
        cityDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        cityDropDown.contentMode = .scaleAspectFit
        cityBGView.addSubview(cityDropDown)
        
        cityDropDown.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(countryBGView)
            make.width.equalTo(40)
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
        
        nationalityTextfield.isUserInteractionEnabled = true
        nationalityTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openNationality)))

        
        
        nationalityDropDown = UIButton()
//        nationalityDropDown.addTarget(self, action: #selector(viewPasswrodButtonAction), for: .touchUpInside)
        nationalityDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        nationalityDropDown.contentMode = .scaleAspectFit
        nationalityBGView.addSubview(nationalityDropDown)
        
        nationalityDropDown.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(nationalityBGView)
            make.width.equalTo(40)
        }
        //Nationality UI
        
        let nationalityIDBGView = UIView()
        scrollView.addSubview(nationalityIDBGView)

        nationalityIDBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(nationalityBGView.snp.bottom).offset(10)
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
        
        
        nationalityDropDown = UIButton()
//        nationalityDropDown.addTarget(self, action: #selector(viewPasswrodButtonAction), for: .touchUpInside)
        nationalityDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        nationalityDropDown.contentMode = .scaleAspectFit
        nationalityBGView.addSubview(nationalityDropDown)
        
        nationalityDropDown.snp.makeConstraints { (make) in
            make.trailing.top.bottom.equalTo(nationalityBGView)
            make.width.equalTo(40)
        }
        
        
        // Attachment UI
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
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5    ) {
            
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = Color.liteGray.cgColor
            yourViewBorder.lineDashPattern = [6, 2]
            yourViewBorder.frame = self.idAttachmentBGView.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.idAttachmentBGView.bounds).cgPath
            self.idAttachmentBGView.layer.addSublayer(yourViewBorder)
        }
        
        idAttachmentLabel = UILabel()//ID Card Photo
        idAttachmentLabel.text = NSLocalizedString("ID Card Photo", comment: "")
        idAttachmentLabel.textColor = Color.liteGray
        idAttachmentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        idAttachmentBGView.addSubview(idAttachmentLabel)
        
        idAttachmentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(idAttachmentImageView.snp.trailing).offset(20)
            make.trailing.equalTo(idAttachmentBGView).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        let idAttachmentInfoLabel = UILabel()
        idAttachmentInfoLabel.text = NSLocalizedString("You can upload JPEG,PNG and PDF files", comment: "")
        idAttachmentInfoLabel.textColor = Color.liteBlack
        idAttachmentInfoLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        scrollView.addSubview(idAttachmentInfoLabel)
        
        idAttachmentInfoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(idAttachmentBGView).offset(05)
            make.trailing.equalTo(idAttachmentBGView)
            make.top.equalTo(idAttachmentBGView.snp.bottom).offset(05)
        }
        
        
        
        // CRN UI
        let crnBGView = UIView()
        scrollView.addSubview(crnBGView)

        crnBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(idAttachmentInfoLabel.snp.bottom).offset(10)
            make.height.equalTo(50)
        }

        crnBGView.layer.borderColor = Color.liteGray.cgColor
        crnBGView.layer.borderWidth = 0.5
        crnBGView.layer.cornerRadius = 10.0
        crnBGView.clipsToBounds = true

        let crnImageView = UIImageView()
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
        crnBGView.addSubview(crnTextfield)
        
        crnTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        crnTextfield.layer.borderWidth = 0
        
        // Attachment UI
        attachmentBGView = UIView()
        scrollView.addSubview(attachmentBGView)
        
        attachmentBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(crnBGView.snp.bottom).offset(10)
            make.height.equalTo(40)
        }

        
        attachmentImageView = UIImageView()
        attachmentImageView.image = UIImage(named: "attachment")
        attachmentImageView.contentMode = .scaleAspectFit
        attachmentBGView.addSubview(attachmentImageView)

        attachmentImageView.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(20)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5    ) {
            
            let yourViewBorder = CAShapeLayer()
            yourViewBorder.strokeColor = Color.liteGray.cgColor
            yourViewBorder.lineDashPattern = [6, 2]
            yourViewBorder.frame = self.attachmentBGView.bounds
            yourViewBorder.fillColor = nil
            yourViewBorder.path = UIBezierPath(rect: self.attachmentBGView.bounds).cgPath
            self.attachmentBGView.layer.addSublayer(yourViewBorder)
        }
        
        attachmentLabel = UILabel()
        attachmentLabel.text = NSLocalizedString("Registration attachment", comment: "")
        attachmentLabel.textColor = Color.liteGray
        attachmentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        attachmentBGView.addSubview(attachmentLabel)
        
        attachmentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(attachmentImageView.snp.trailing).offset(20)
            make.trailing.equalTo(attachmentBGView).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        let attachmentInfoLabel = UILabel()
        attachmentInfoLabel.text = NSLocalizedString("You can upload JPEG,PNG and PDF files", comment: "")
        attachmentInfoLabel.textColor = Color.liteBlack
        attachmentInfoLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        scrollView.addSubview(attachmentInfoLabel)
        
        attachmentInfoLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(attachmentBGView).offset(05)
            make.trailing.equalTo(attachmentBGView)
            make.top.equalTo(attachmentBGView.snp.bottom).offset(05)
        }
        
        
        signatureButton = UIButton()
        signatureButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14)!
        signatureButton.setTitle(NSLocalizedString("Signature here", comment: ""), for: .normal)
        signatureButton.setTitleColor(UIColor.lightGray, for: .normal)
        signatureButton.addTarget(self, action: #selector(self.signatureAction), for: .touchUpInside)
        scrollView.addSubview(signatureButton)
        
        signatureButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(attachmentInfoLabel.snp.bottom).offset(20)
            make.height.equalTo(140)
        }
        
        signatureButton.layer.borderColor = Color.liteGray.cgColor
        signatureButton.layer.borderWidth = 0.5
        signatureButton.layer.cornerRadius = 10.0
        signatureButton.clipsToBounds = true
        
    
        let confirmButton = UIButton()
        confirmButton.setTitle(NSLocalizedString("Save Profile", comment: ""), for: .normal)
        confirmButton.backgroundColor = Color.red
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        confirmButton.addTarget(self, action: #selector(self.setupAction), for: .touchUpInside)
        scrollView.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.top.equalTo(signatureButton.snp.bottom).offset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
        }
        
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.clipsToBounds = true
        
       
        attachmentAaction()
        idAttachmentAaction()
        imagePickerAction()
        navigationBarItems()
        
         
    }
    
    @objc func viewPasswrodButtonAction(_ sender: UIButton){
        
        if sender.tag == 1{
            passwordTextfield.isSecureTextEntry = !passwordTextfield.isSecureTextEntry
            
            if passwordTextfield.isSecureTextEntry {
                let eye2Image = UIImage(named: "eye_black")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
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

    
    @objc func openCountries(){
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country", comment: "")
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
    
    //MARK: registration attachment
    
    func attachmentAaction(){
        
        attachmentLabel.isUserInteractionEnabled = true
        attachmentBGView.isUserInteractionEnabled = true
        attachmentImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.documentPicker(_:)))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.documentPicker(_:)))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.documentPicker(_:)))

        attachmentLabel.addGestureRecognizer(tap)
        attachmentBGView.addGestureRecognizer(tap1)
        attachmentImageView.addGestureRecognizer(tap2)

    }
    
    func idAttachmentAaction(){
        
        idAttachmentLabel.isUserInteractionEnabled = true
        idAttachmentImageView.isUserInteractionEnabled = true
        idAttachmentBGView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))
        let tap1 = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))
        let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.showActionSheet))

        idAttachmentLabel.addGestureRecognizer(tap)
        idAttachmentImageView.addGestureRecognizer(tap1)
        idAttachmentBGView.addGestureRecognizer(tap2)

    }
    
    //MARK : Document picker
    
   @objc func showActionSheet() {
        isPhotoId = true
       let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
       let camera = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { (action) -> Void in
//          self.camera()
        self.openCamera()
       })
       let gallery = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: .default, handler: { (action) -> Void in
//          self.photoLibrary()
        self.openGallary()
       })
       
       let file = UIAlertAction(title: NSLocalizedString("File", comment: ""), style: .default, handler: { (action) -> Void in
//          self.file()
        self.documentPickerId()
       })
       let cancel = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil)
       actionSheet.addAction(camera)
       actionSheet.addAction(gallery)
        actionSheet.addAction(file)
       actionSheet.addAction(cancel)
       present(actionSheet, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @objc func documentPickerId() {
        isPhotoId = true

        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    @objc func documentPicker(_ sender: UITapGestureRecognizer? = nil) {
        isPhotoId = false

        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText),String(kUTTypeContent),String(kUTTypeItem),String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        self.present(documentPicker, animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        print(urls[0])
        
        let urlString = urls[0].absoluteString

        let extType = urlString.components(separatedBy: ".").last ?? ""
        let mimeType = urlString.mimeType()
        
        do {
            let fileData = try Data(contentsOf: urls[0])
            print("pathString:= \(AWSBucket.uploadCRN)")
            uploadFile(awsBucket: AWSBucket.uploadCRN, fileData: fileData, mimeType: mimeType, ext: extType) { (response, file) in
                DispatchQueue.main.async {
                    
                    if self.isPhotoId{
                        self.idAttachmentCDNString = file
                        self.idAttachmentLabel.text = file
                        self.idAttachmentLabel.textColor = .black
                    }
                    else{
                        self.crnAttachmentCDNString = file
                        self.attachmentLabel.text = file
                        self.attachmentLabel.textColor = .black
                    }
                    
                }
            }
        }catch let error{
            
            print("error \(error.localizedDescription)")
            
        }
        
    }
    
    //MARK: image picker
    func imagePickerAction(){
        profileImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.imagePicker(_:)))
        profileImageView.addGestureRecognizer(tap)
    }
    
    @objc func imagePicker(_ sender: UITapGestureRecognizer? = nil) {
        // handling code
        isPhotoId = false
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Choose option to upload picture", comment: "") , preferredStyle: UIAlertController.Style.actionSheet) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let gallertyAction = UIAlertAction(title: NSLocalizedString("Gallery", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("Gallery")
            self.openGallary()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let cameraAction = UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            print("Camera")
            self.openCamera()
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
     
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
    
    func openGallary()
    {
        imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            
            if isPhotoId{
                idAttachmentImageView.image = pickedImage
            }else{
                profileImageView.image = pickedImage
            }
            profileImageView.contentMode = .scaleAspectFill
            
            profileImageView.layer.cornerRadius = 65
            profileImageView.clipsToBounds = true
            
            let pathString = isPhotoId ? AWSBucket.id_card : AWSBucket.uploadUser
            print("pathString:= \(pathString)")
            let imageData = pickedImage.compress(to: 300)

            uploadFile(awsBucket: pathString, fileData: imageData, mimeType: "image/jpg", ext: "jpg") { (response, image) in
                
                if self.isPhotoId{
                    DispatchQueue.main.async {
                        self.idAttachmentCDNString = image
                        self.idAttachmentLabel.text = image
                        self.idAttachmentLabel.textColor = .black
                    }
                }
                else{
                    self.profileImageCDNString = image
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
         print("keyname = \(keyname)")
           
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
        
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Setup Your Profile", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
        backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        
        if (self.navigationController?.viewControllers.count ?? 0)>2{
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                backButton.setImage(UIImage(named: "back-R"), for: .normal)
            }else{
                backButton.setImage(UIImage(named: "back"), for: .normal)
            }
            backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        }
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
    
    @IBAction func setupAction(_ sender:Any){
        
        
        if fullNameTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please enter your full name", comment: ""))
        }
        else if emailTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please enter your email address", comment: ""))
        }
        else if !isValidEmail(emailTextfield.text ?? ""){
            errorBanner(error: NSLocalizedString("Please enter valid email address", comment: ""))
        }
        else if !hidePasswords && passwordTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please enter your password", comment: ""))
        }
        else if !hidePasswords && (passwordTextfield.text ?? "").count<6{
            errorBanner(error: NSLocalizedString("Password should not be less than six characters", comment: ""))
        }
        else if !hidePasswords && (passwordTextfield.text != confirmPasswordTextfield.text){
            errorBanner(error: NSLocalizedString("Password and confirm password does not match", comment: ""))
        }
        else if countryTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please select your country", comment: ""))
        }
        else if cityTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please select your city", comment: ""))
        }
        else if nationalityTextfield.text == nil{
            errorBanner(error: NSLocalizedString("Please select your nationality", comment: ""))
        }
        else if nationalityID == nil{
            errorBanner(error: NSLocalizedString("Please enter your nationality ID", comment: ""))
        }
        else if idAttachmentCDNString == nil{
            errorBanner(error: NSLocalizedString("Please upload your nationality id", comment: ""))
        }
        else if crnTextfield.text == ""{
            errorBanner(error: NSLocalizedString("Please enter your CR Number", comment: ""))
        }
        else if crnAttachmentCDNString == nil{
            errorBanner(error: NSLocalizedString("Please attach CRN document", comment: ""))
        }
        else if userSignatureCDNString == nil{
            errorBanner(error: NSLocalizedString("Please update your signature", comment: ""))
        }
        else
        {
            completeProfile()
        }
        
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    
    func completeProfile(){

        if hidePasswords{
            
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "name" : fullNameTextfield.text ?? "",
                "email" : emailTextfield.text ?? "",
                "cr_number" : crnTextfield.text ?? "",
                "cr_file" : crnAttachmentCDNString ?? "",
                "profile_image" : profileImageCDNString ?? "",
                "signature_file" : userSignatureCDNString ?? "",
                "id_number" : nationalityIDTextfield.text ?? "",
                "id_card_image":idAttachmentLabel.text ?? "",
                "nationality_id" : nationalityID ?? 0,
                "country_id" : countryID ?? 0,
                "city_id" : cityID ?? 0
                
            ]
            
            WebServices.postRequest(url: Url.completeProfileWithoutPassword, params: parameters, viewController: self) { success,data  in
                do {
                    let decoder = JSONDecoder()
                    let getProfile = try decoder.decode(CompleteProfile.self, from: data)
                    
                    if success{
                        UserDefaults.standard.removeObject(forKey: "ProfileType")

                        UserDefaults.standard.setValue(getProfile.data?.supports?.email_address, forKey: "email_address")
                        UserDefaults.standard.setValue(getProfile.data?.supports?.mobile, forKey: "mobile")
                  
                        if let profileData = getProfile.data{
                            UserDetailsCrud().saveProfile(profile: profileData) { _ in
                                print("profile details updated in coredata")
                                Profile.shared.details = profileData
                            }
                        }
                        UserDefaults.standard.setValue("Yes", forKey: "isExistingUser")
                        let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
                        AppDelegate.shared.window?.rootViewController = VC
                        let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
                        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig
                    }
                    
                } catch let error {
                    print(error)
                }
            }
        }else{
            
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "name" : fullNameTextfield.text ?? "",
                "email" : emailTextfield.text ?? "",
                "password" : passwordTextfield.text ?? "",
                "confirm_password" : confirmPasswordTextfield.text ?? "",
                "cr_number" : crnTextfield.text ?? "",
                "cr_file" : crnAttachmentCDNString ?? "",
                "profile_image" : profileImageCDNString ?? "",
                "signature_file" : userSignatureCDNString ?? "",
                "id_number" : nationalityIDTextfield.text ?? "",
                "id_card_image":idAttachmentLabel.text ?? "",
                "nationality_id" : nationalityID ?? 0,
                "country_id" : countryID ?? 0,
                "city_id" : cityID ?? 0
                
            ]
            
            WebServices.postRequest(url: Url.completeProfile, params: parameters, viewController: self) { success,data  in
                do {
                    let decoder = JSONDecoder()
                    let getProfile = try decoder.decode(CompleteProfile.self, from: data)
                    
                    if success{
                        print("profile data")
                        UserDefaults.standard.removeObject(forKey: "ProfileType")

                        if let profileData = getProfile.data{
                            UserDetailsCrud().saveProfile(profile: profileData) { _ in
                                print("profile details updated in coredata")
                                Profile.shared.details = profileData
                            }
                        }
                        UserDefaults.standard.setValue("Yes", forKey: "isExistingUser")
                        let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
                        AppDelegate.shared.window?.rootViewController = VC
                        let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
                        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig
                    }
                    
                } catch let error {
                    print(error)
                }
            }
        }


    }
    
    func errorBanner(error:String){
        Banner().displayValidationError(string: error)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
 
    //MARK: Uploading signature
    
    @IBAction func signatureAction(_ sender:Any){
        
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : SignatureViewController = storyboard.instantiateViewController(withIdentifier: "SignatureViewController") as! SignatureViewController
        vc.delegate = self
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: {
          vc.presentationController?.presentedView?.gestureRecognizers?[0].isEnabled = false
            
        })
        
    }    
    func userSignature(image: CGImage) {
        let image:UIImage = UIImage.init(cgImage: image)
        signatureButton.setBackgroundImage(image, for: .normal)

        let imageData = image.jpegData(compressionQuality: 1.0) ?? Data()
        uploadFile(awsBucket: AWSBucket.uploadSignature, fileData: imageData, mimeType: "image/jpg", ext: "jpg") { (response, image) in
            self.userSignatureCDNString = image
        }
        signatureButton.setTitle("", for: .normal)
        signatureButton.imageView?.contentMode = .scaleAspectFit
        signatureButton.layoutIfNeeded()
        signatureButton.subviews.first?.contentMode = .scaleAspectFit

    }
}


protocol SignatureDelegate {
    func userSignature(image:CGImage)
}


extension ProfileSetupViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
    }
}

class TitleTextfield: SkyFloatTextfield{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autocapitalizationType = .none
        self.titleFont = UIFont.systemFont(ofSize: 10.0)
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.backgroundColor = .white
        self.selectedTitleColor = UIColor.lightGray
        self.titleColor = UIColor.lightGray
        self.textColor = UIColor.black
        self.lineHeight = 0
        self.selectedLineHeight = 0
        self.titleFormatter = { $0 }
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10.0
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class SkyFloatTextfield: SkyFloatingLabelTextField {

    private let leftPadding = CGFloat(0)
    private let rightPadding = CGFloat(10)
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        
        if editing {
            return CGRect(x: leftPadding, y: 5, width: bounds.size.width, height: titleHeight())
        }
        
        return CGRect(x: leftPadding, y: titleHeight(), width: bounds.size.width, height: titleHeight())
    }
    
}

extension ProfileSetupViewController : countryCodeProtocol{
    
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
