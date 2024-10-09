//
//  ViewProfileViewController.swift
//  Crew
//
//  Created by Rajeev on 23/03/21.
//

import UIKit

class ViewProfileViewController: UIViewController {

    
    var nameLabel : UILabel!
    var profileImageView : UIImageView!
    var emailLabel : UILabel!
    var countryTextfield : TitleTextfield!
    var nationalityTextfield : TitleTextfield!
    var nationalityIDTextfield : TitleTextfield!
    var cityTextfield : TitleTextfield!
    var crnTextfield : TitleTextfield!
    var idAttachmentImageView : UIImageView!
    var idAttachmentBGView : UIView!
    var idAttachmentLabel : UILabel!
    var crnImageView : UIImageView!
    var attachmentLabel : UILabel!
    var attachmentImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBarItems()
                
        let scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
        
        
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(scrollView).offset(25)
            make.width.height.equalTo(120)
        }
        
        profileImageView.layer.cornerRadius = 60
        profileImageView.clipsToBounds = true
        
       
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        nameLabel.textAlignment = .center
        scrollView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(25)
        }
        
                
        let numberLabel = UILabel()
        numberLabel.text = Profile.shared.details?.mobile
        numberLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        numberLabel.textAlignment = .center
        scrollView.addSubview(numberLabel)
        
        numberLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
        
        emailLabel = UILabel()
        emailLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        emailLabel.textAlignment = .center
        scrollView.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(numberLabel.snp.bottom).offset(10)
        }
        
        
        let subscriptionView = UIView()
        subscriptionView.backgroundColor = UIColor(red: 248/255, green: 231/255, blue: 234/255, alpha: 1.0)
        scrollView.addSubview(subscriptionView)
        
        subscriptionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(numberLabel)
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.height.equalTo(60)
        }
        subscriptionView.layer.cornerRadius = 5.0
        subscriptionView.clipsToBounds = true
        
        
        let paymentImageView = UIImageView()
        paymentImageView.image = UIImage(named: "subscription")
        paymentImageView.contentMode = .scaleAspectFit
        subscriptionView.addSubview(paymentImageView)
        
        paymentImageView.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.leading.equalTo(20)
            make.centerY.equalToSuperview()
        }
        

        let renewButton = UIButton()
        renewButton.setTitle("Renew", for: .normal)
        renewButton.backgroundColor = .white
        renewButton.titleLabel?.font = UIFont(name: "Avenir Medium", size: 14)
        renewButton.setTitleColor(.red, for: .normal)
        subscriptionView.addSubview(renewButton)
        
        renewButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(10)
            make.width.equalTo(70)
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
        }
        
        renewButton.layer.cornerRadius = 5.0
        renewButton.clipsToBounds = true
        
        
        let paymentLabel = UILabel()
        paymentLabel.text = NSLocalizedString("Your subscription has been expired", comment: "")
        paymentLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        paymentLabel.numberOfLines = 0
        paymentLabel.textAlignment = .center
        paymentLabel.textColor = Color.red
        subscriptionView.addSubview(paymentLabel)
        
        paymentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(paymentImageView.snp.trailing).offset(10)
            make.trailing.equalTo(renewButton.snp.leading).offset(-10)
            make.centerY.equalToSuperview()
        }
                
        
        let expireDateString = Profile.shared.details?.expired_at
        let todayDate = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let expireDate = dateFormatter.date(from:expireDateString ?? "") ?? todayDate
        
            let isDescending = todayDate.compare(expireDate) == ComparisonResult.orderedDescending
            print("orderedDescending: \(isDescending)")
            
            let isAscending = todayDate.compare(expireDate) == ComparisonResult.orderedAscending
            print("orderedAscending: \(isAscending)")
            
            let isSame = todayDate.compare(expireDate) == ComparisonResult.orderedSame
            print("orderedSame: \(isSame)")
        
        
        if isDescending || isSame{
            subscriptionView.isHidden = false
            renewButton.addTarget(self, action: #selector(self.renewAction), for: .touchUpInside)
        }else{
            subscriptionView.isHidden = true
        }

        subscriptionView.isHidden = true
        //Country UI
    
        let countryBGView = UIView()
        scrollView.addSubview(countryBGView)

        countryBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(subscriptionView.snp.bottom).offset(10)
            make.height.equalTo(50)
        }
        
        if isDescending || isSame{
            countryBGView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view).inset(20)
                make.top.equalTo(subscriptionView.snp.bottom).offset(10)
                make.height.equalTo(50)
            }
        }else{
            countryBGView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view).inset(20)
                make.top.equalTo(emailLabel.snp.bottom).offset(10)
                make.height.equalTo(50)
            }
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
        countryTextfield.text = "------"
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
        cityTextfield.text = "------"
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
        nationalityTextfield.text = "---------"
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
        
        
        let nationalityDropDown = UIButton()
        nationalityDropDown.setImage(UIImage(named: "drop_down"), for: .normal)
        nationalityDropDown.contentMode = .scaleAspectFit
        nationalityBGView.addSubview(nationalityDropDown)
        
        nationalityDropDown.snp.makeConstraints { (make) in
            make.trailing.equalTo(countryBGView).offset(-5)
            make.width.height.equalTo(15)
            make.centerY.equalToSuperview()
        }
        
        
        //ID number
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
        nationalityIDTextfield.inputView = UIView()
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
       
        // CRN UI
        let crnBGView = UIView()
        scrollView.addSubview(crnBGView)

        crnBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(idAttachmentBGView.snp.bottom).offset(10)
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
        crnTextfield.text = "------"
        crnBGView.addSubview(crnTextfield)
        
        crnTextfield.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(40)
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.height.equalTo(45)
        }
        crnTextfield.layer.borderWidth = 0
        
        // Attachment UI
        let attachmentBGView = UIView()
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
            make.leading.equalToSuperview()
            make.centerY.equalToSuperview()
            make.height.width.equalTo(40)
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
        
        
        
        let editButton = UIButton()
        editButton.setTitle(NSLocalizedString("Edit Profile", comment: ""), for: .normal)
        editButton.backgroundColor = Color.liteWhite
        editButton.setTitleColor(Color.liteBlack, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 14)
        editButton.addTarget(self, action: #selector(self.editButtonAction), for: .touchUpInside)
        self.view.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(attachmentBGView.snp.bottom).offset(30)
        }
        
        editButton.layer.cornerRadius = 5.0
        editButton.clipsToBounds = true
        
        //        let paymentLabel = UILabel()
        //        paymentLabel.text = NSLocalizedString("Your subscription has been expired", comment: "")
        //        paymentLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        //        paymentLabel.textAlignment = .center
        //        paymentLabel.textColor = Color.red
        //        subscriptionView.addSubview(paymentLabel)
        //
        //        paymentLabel.snp.makeConstraints { (make) in
        //            make.leading.equalTo(paymentImageView.snp.trailing).offset(10)
        //            make.centerY.equalToSuperview()
        //        }
                
        
        /*
        let attachmentImageView = UIImageView()
        attachmentImageView.image = UIImage(named: "View_Attachement")
        attachmentImageView.contentMode = .scaleAspectFit
        self.view.addSubview(attachmentImageView)

        attachmentImageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(profileImageView)
            make.top.equalTo(lineView.snp.bottom).offset(25)
            make.width.height.equalTo(60)
        }
        
        attachmentImageView.layer.cornerRadius = 30
        attachmentImageView.clipsToBounds = true
        
        
        let viewAttachmentLabel = UILabel()
        viewAttachmentLabel.text = NSLocalizedString("view Attachment", comment: "")
        viewAttachmentLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        viewAttachmentLabel.textAlignment = .center
        viewAttachmentLabel.textColor = Color.red
        self.view.addSubview(viewAttachmentLabel)
        
        viewAttachmentLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(attachmentImageView.snp.bottom).offset(10)
        }
        
        attachmentImageView.isUserInteractionEnabled = true
        viewAttachmentLabel.isUserInteractionEnabled = true
        viewAttachmentLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(viewAttachment)))
        attachmentImageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(viewAttachment)))
       
        
        let registrationNumberTitleLabel = UILabel()
        registrationNumberTitleLabel.text = NSLocalizedString("Registration Number", comment: "")
        registrationNumberTitleLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        registrationNumberTitleLabel.textAlignment = .center
        registrationNumberTitleLabel.textColor = Color.liteBlack
        self.view.addSubview(registrationNumberTitleLabel)
        
        registrationNumberTitleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(viewAttachmentLabel.snp.bottom).offset(25)
        }

        let registrationNumberLabel = UILabel()
        registrationNumberLabel.text = Profile.shared.details?.cr_number
        registrationNumberLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        registrationNumberLabel.textAlignment = .center
        registrationNumberLabel.textColor = Color.liteBlack
        self.view.addSubview(registrationNumberLabel)
        
        registrationNumberLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(registrationNumberTitleLabel.snp.bottom).offset(10)
        }
        
        
        let editButton = UIButton()
        editButton.setTitle(NSLocalizedString("Edit Profile", comment: ""), for: .normal)
        editButton.backgroundColor = Color.liteWhite
        editButton.setTitleColor(Color.liteBlack, for: .normal)
        editButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 14)
        editButton.addTarget(self, action: #selector(self.editButtonAction), for: .touchUpInside)
        self.view.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(registrationNumberLabel.snp.bottom).offset(30)
        }
        
        editButton.layer.cornerRadius = 5.0
        editButton.clipsToBounds = true
        
        
        */
    }
    
    @objc func renewAction(){
        if Profile.shared.details?.payment_status != "Not Applicable"{

            let support = Support(email_address: UserDefaults.standard.value(forKey: "email_address") as? String ?? "", mobile: UserDefaults.standard.value(forKey: "mobile") as? String ?? "")
            
            let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let vc : AgencyPaymentViewController = storyboard.instantiateViewController(withIdentifier: "AgencyPaymentViewController") as! AgencyPaymentViewController
            vc.supprt = support
            vc.amountString = Profile.shared.details?.registration_fees
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
    
    @objc func editButtonAction(){
        
        let vc = EditProfileViewController()
        vc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true
//        print(Profile.shared.details?.id_card_image)
        
        let profilePicurl = Url.userProfile + (Profile.shared.details?.profile_image ?? "")
        DispatchQueue.main.async {
            self.profileImageView.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            self.profileImageView.setupImageViewer()
            
            let idurl = Url.id_cards + (Profile.shared.details?.id_card_image ?? "")
            self.idAttachmentImageView.sd_setImage(with: URL(string: idurl), placeholderImage: UIImage(named: "camera_image"), options: [], progress: nil, completed: nil)
            self.idAttachmentLabel.text = Profile.shared.details?.id_card_image ?? ""
            self.idAttachmentLabel.textColor = Color.liteBlack
            self.idAttachmentImageView.setupImageViewer()
            
            let crnUrl = Url.crnFile + (Profile.shared.details?.cr_file ?? "")
            self.attachmentImageView.sd_setImage(with: URL(string: crnUrl), placeholderImage: UIImage(named: "Registration_no"), options: [], progress: nil, completed: nil)
            self.attachmentLabel.text = Profile.shared.details?.cr_file ?? ""
            self.attachmentLabel.textColor = Color.liteBlack
            self.attachmentImageView.setupImageViewer()
        }
        
        
        nameLabel.text = Profile.shared.details?.name
        emailLabel.text = Profile.shared.details?.email
        nationalityIDTextfield.text =  String(Int(Profile.shared.details?.nationality_id ?? 0))
        nationalityTextfield.text = Profile.shared.details?.nationality_name
        countryTextfield.text = Profile.shared.details?.country_name
        cityTextfield.text = Profile.shared.details?.city_name
        crnTextfield.text = Profile.shared.details?.cr_number
          //  String(Profile.shared.details?.nationality_id)
        
        
    }
    

    func navigationBarItems() {
        
        self.title = NSLocalizedString("Profile", comment: "")
        
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

    @objc func viewAttachment(){
        
        let crnUrl = Url.crnFile + (Profile.shared.details?.cr_file ?? "")        
        let vc = CRNViewController()
        vc.crnURLString = crnUrl
        self.present(vc, animated: true, completion: nil)
        
        
    }
}
