//
//  ProfileViewController.swift
//  Crew
//
//  Created by Rajeev on 22/02/21.
//

import UIKit
import IQKeyboardManagerSwift

class ProfileViewController: UIViewController {
    
    var menuItemsArray = [String]()
    var menuIconsArray = [String]()
    
    var profileImageView : UIImageView!
    var nameLabel : UILabel!
    var tableView : UITableView!
    var profileButton : UIButton!
    var topView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hidesBottomBarWhenPushed = true


        
        topView = UIView()
        topView.backgroundColor = Color.liteBlack
        self.view.addSubview(topView)
        
        topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view)
            make.height.equalTo(160)
        }
        
        profileImageView = UIImageView()
        profileImageView.clipsToBounds = true
        profileImageView.contentMode = .scaleAspectFill
        topView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.top.equalTo(topView).offset(50)
            make.leading.equalTo(topView).offset(25)
        }
        profileImageView.layer.borderWidth = 5.0
        profileImageView.layer.cornerRadius = 40
        profileImageView.layer.borderColor = UIColor.gray.withAlphaComponent(0.75).cgColor
        
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 20)
        nameLabel.textColor = UIColor.white
        topView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView).offset(20)
            make.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        profileButton = UIButton()
     
        profileButton.setTitleColor(Color.gold, for: .normal)
        profileButton.addTarget(self, action: #selector(self.viewProfileAction), for: .touchUpInside)
        profileButton.semanticContentAttribute = .forceRightToLeft
        topView.addSubview(profileButton)
        
        profileButton.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(05)
        }
        
        
        
        //Tableveiw
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(topView.snp.bottom)
            make.bottom.equalToSuperview()
        }
        
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.tabBarController?.tabBar.isHidden = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.tableView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.top.equalTo(self.topView.snp.bottom)
                make.bottom.equalToSuperview()
            }
        }

    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.barTintColor = .white
        let profilePicurl = Url.userProfile + (Profile.shared.details?.profile_image ?? "")
        profileImageView.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        nameLabel.text = Profile.shared.details?.name ?? ""
        
        if Profile.shared.details == nil{
            
            menuItemsArray = [NSLocalizedString("Share App", comment: ""),
                              NSLocalizedString("Support", comment: ""),
                              NSLocalizedString("Terms of service", comment: ""),
                              NSLocalizedString("Privacy Policy", comment: ""),
                              NSLocalizedString("About us", comment: ""),
                              NSLocalizedString("Language", comment: "")  ]
            menuIconsArray = ["share_menu","support","terms","privacy","about_us","globe_menu"]
            
        }else {
            if Profile.shared.details?.is_agency=="Yes"{
                
                menuItemsArray = [NSLocalizedString("Wallet", comment: ""),
                                  NSLocalizedString("Saved", comment: ""),
                                  NSLocalizedString("Requests", comment: ""),
                                  NSLocalizedString("Saved Contracts", comment: ""),
                                  NSLocalizedString("Notifications", comment: ""),
                                  NSLocalizedString("Share App", comment: ""),
                                  NSLocalizedString("Support", comment: ""),
                                  NSLocalizedString("Terms of service", comment: ""),
                                  NSLocalizedString("Privacy Policy", comment: ""),
                                  NSLocalizedString("Change password", comment: ""),
                                  NSLocalizedString("About us", comment: ""),
                                  NSLocalizedString("Language", comment: "") ,
                                  NSLocalizedString("Logout", comment: "")]
                menuIconsArray = ["total_amount-1","fav_menu","requests","saved_contract","notification_2","share_menu","support","terms","privacy","chnage_password","about_us","globe_menu","logout"]
                
            }else {
                menuItemsArray = [
                                  NSLocalizedString("Saved", comment: ""),
                                  NSLocalizedString("Saved Contracts", comment: ""),
                                  NSLocalizedString("Notifications", comment: ""),
                                  NSLocalizedString("Share App", comment: ""),
                                  NSLocalizedString("Support", comment: ""),
                                  NSLocalizedString("Terms of service", comment: ""),
                                  NSLocalizedString("Privacy Policy", comment: ""),
                                  NSLocalizedString("Change password", comment: ""),
                                  NSLocalizedString("About us", comment: ""),
                                  NSLocalizedString("Language", comment: ""),
                                  NSLocalizedString("Logout", comment: "")]
                menuIconsArray = ["fav_menu","saved_contract","notification_2","share_menu","support","terms","privacy","chnage_password","about_us","globe_menu","logout"]
            }
        }
        if Profile.shared.details == nil{
            profileButton.setTitle(NSLocalizedString(" Login  ", comment: ""), for: .normal)
            profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            profileButton.setImage(UIImage(named: ""), for: .normal)
        }else{
            profileButton.setTitle(NSLocalizedString("Go to profile  ", comment: ""), for: .normal)
            profileButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
                        
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                profileButton.setImage(UIImage(named: "yellow_next-R"), for: .normal)
                profileButton.semanticContentAttribute = .forceLeftToRight
            }else{
                profileButton.setImage(UIImage(named: "yellow_next"), for: .normal)
                profileButton.semanticContentAttribute = .forceRightToLeft

            }
            
            
//            profileButton.semanticContentAttribute = .rightToLeft
                //UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
                //.rightToLeft ? .forceLeftToRight : .forceRightToLeft
            
        }
        tableView.reloadData()
        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
        self.tableView.contentInset = adjustForTabbarInsets
        self.tableView.scrollIndicatorInsets = adjustForTabbarInsets
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
        //        self.tabBarController?.tabBar.isHidden = true
//        self.navigationController?.navigationBar.barStyle = .default
    }
    
    @objc func viewProfileAction(){
        if Profile.shared.details == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            self.tabBarController?.tabBar.isHidden = true
            let vc = ViewProfileViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    //MARK: Logout api request
    func logout(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        
        WebServices.postRequest(url: Url.logout, params: parameters, viewController: self) { success,data  in
            Profile.shared.details = nil
            UserDefaults.standard.removeObject(forKey: "isExistingUser")
            let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
            AppDelegate.shared.window?.rootViewController = VC
//            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Done", comment: "")
            let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
            IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig
        }
    }
    
}

extension ProfileViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return menuItemsArray.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.textLabel?.text = menuItemsArray[indexPath.row]
        cell?.textLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        
        let iconString = menuIconsArray[indexPath.row]
        let icon = UIImage(named: iconString)//?.sd_resizedImage(with: CGSize(width: 22, height: 22), scaleMode: .aspectFit)
        if let iconImage = icon?.imageFlippedForRightToLeftLayoutDirection(){
            cell?.imageView?.image = iconImage
        }
        cell?.imageView?.clipsToBounds = true
        
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if menuItemsArray[indexPath.row] == NSLocalizedString("Terms of service", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = LegalViewController()
            vc.isPrivacy = false
            self.navigationController?.pushViewController(vc, animated: true)
        }
        if menuItemsArray[indexPath.row] == NSLocalizedString("Language", comment: ""){
            self.languageChange()
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Privacy Policy", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = LegalViewController()
            vc.isPrivacy = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Change password", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = ChangePasswordViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Logout", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            UserDefaults.standard.removeObject(forKey: "isExistingUser")
            self.logout()
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Share App", comment: ""){
            
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("About us", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = AboutUsViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Support", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = SupportViewController()
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Notifications", comment: ""){
            if Profile.shared.details?.profile_status != "Verified"{
                checkUserVerification()
            }else{
                self.tabBarController?.tabBar.isHidden = true
                let vc = NotificationsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Saved", comment: ""){
            self.tabBarController?.tabBar.isHidden = true

            let vc = FavouriteViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Requests", comment: ""){
            if Profile.shared.details?.profile_status != "Verified"{
                checkUserVerification()
            }else{
                self.tabBarController?.tabBar.isHidden = true
                let vc = RequestsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Payments", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = PaymentsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Saved Contracts", comment: ""){
            if Profile.shared.details?.profile_status != "Verified"{
                checkUserVerification()
            }else{
                self.tabBarController?.tabBar.isHidden = true
                let vc = MyContractsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        else if menuItemsArray[indexPath.row] == NSLocalizedString("Wallet", comment: ""){
            self.tabBarController?.tabBar.isHidden = true
            let vc = UIStoryboard.instantiateViewController(withViewClass: WalletViewController.self)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    func languageChange(){

        if UserDefaults.standard.value(forKey: "Language") as? String == "en"{
            Bundle.setLanguage("ar")
            UserDefaults.standard.setValue("ar", forKey: "Language")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }else{
            Bundle.setLanguage("en")
            UserDefaults.standard.setValue("en", forKey: "Language")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
        AppDelegate.shared.window?.rootViewController = VC
//        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = NSLocalizedString("Done", comment: "")
        let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig

      }
    
    func checkUserVerification(){
//        self.tabBarController?.tabBar.isHidden = true
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ReviewPopupVC = storyboard.instantiateViewController(withIdentifier: "ReviewPopupVC") as! ReviewPopupVC
//                            vc.profileStatus = profileData.profile_status
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
//                            self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}
