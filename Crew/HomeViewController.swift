//
//  HomeViewController.swift
//  Crew
//
//  Created by Rajeev on 22/02/21.
//

import UIKit
import SDWebImage
import SnapKit


class HomeViewController: UIViewController,UIScrollViewDelegate {
    
    @IBOutlet var searchBar : UISearchBar!
    
    //Banner
    let bannerScrollView = UIScrollView()
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var pageControl : UIPageControl = UIPageControl()
    
    //Profiles
    var profilessCollectionView : UICollectionView!
    var profiles = [FeaturedProfile]()
    
    // Projects
    let projectsScrollView = UIScrollView()
    var projectsFrame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var projectsPageControl : UIPageControl = UIPageControl()
    
    // categories
    var categoriessCollectionView : UICollectionView!
    var categories = [Category]()
    
    // Projects
    
    var ongoinProjectsLabel : UILabel!
    var viewAllProjectsButton : UIButton!
    
    var profilesLabel : UILabel!
    var viewAllProfilesButton : UIButton!
    
    var categoriesLabel : UILabel!
    var viewAllCategoriesButton : UIButton!
    
    var scrollView : UIScrollView!
    
    var imgView : UIImageView!
    var trustView : UIView!
    var titleLabel : UILabel!
    var descriptionLabel : UILabel!
    
    var favIdsArray = [Int]()

    //heights
    var profilessCollectionViewHeight = 168
    var categoriessCollectionViewHeight = 90
    
    
    var projects = [ProjectsData]()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        
    }
        
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //        projectsPageControl.updateDots()
        self.tabBarController?.tabBar.isHidden = false
        
    
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            
            if UserDefaults.standard.value(forKey: "isExistingUser") == nil {
                
                self.tabBarController?.tabBar.isHidden = true
                
                if Profile.shared.details == nil {
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
                else if (Profile.shared.details?.is_agency ?? "") == "No" && (Profile.shared.details?.is_company ?? "") == "No" && UserDefaults.standard.value(forKey: "ProfileType") == nil{
                    
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "WhoAreYouViewController") as! WhoAreYouViewController
                        vc.modalPresentationStyle = .fullScreen
                        vc.mobileNumberString = Profile.shared.details?.mobile
                        self.navigationController?.pushViewController(vc, animated: true)
                }
                else if Profile.shared.details?.is_returner != 1{
                    
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : ProfileSetupViewController = storyboard.instantiateViewController(withIdentifier: "ProfileSetupViewController") as! ProfileSetupViewController
                    vc.mobileNumberString = Profile.shared.details?.mobile
                    
                    if let pType = UserDefaults.standard.value(forKey: "ProfileType") as? String{
                        if pType == "agency"{
                            vc.isMediaAgency = true
                        }else{
                            vc.isMediaAgency = false
                        }
                    }else{
                        vc.isMediaAgency = (Profile.shared.details?.is_agency=="agency" ? true : false)
                    }
                    vc.modalPresentationStyle = .fullScreen
                    vc.hidePasswords = false
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }
        }
        
        scrollView.snp.remakeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-80)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func notificationsAction (_ sender : Any){
        
        if Profile.shared.details == nil{
            let vc = LoginAlertViewController()
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion: nil)
            
        }
        else if Profile.shared.details?.profile_status  != "Verified"{
            checkUserVerification()
        }
        else{
            self.tabBarController?.tabBar.isHidden = true
            let vc = NotificationsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func searchBarAction(){
        self.tabBarController?.selectedIndex = 2
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
   
        
        searchBar.searchTextField.inputView = UIView()
        searchBar.searchTextField.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        searchBar.isUserInteractionEnabled = true
        searchBar.searchTextField.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(searchBarAction)))
        searchBar.searchTextField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        
        
        
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 690)
        scrollView.keyboardDismissMode = .onDrag
        scrollView.keyboardDismissMode = .interactive
        
        scrollView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view)
        }
        scrollView.showsVerticalScrollIndicator = false
        
        self.scrollView.pullToRefreshScroll = {age in
            self.fetchDashboardDetails()
        }
        bannerScrollView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width-20,height: 120)
        bannerScrollView.accessibilityIdentifier = "bannerScrollView"
        bannerScrollView.center.x = self.view.center.x
        bannerScrollView.showsHorizontalScrollIndicator = false
        bannerScrollView.tag = 1
        bannerScrollView.delegate = self
//        bannerScrollView.delegate = self
        bannerScrollView.isPagingEnabled = true
        scrollView.addSubview(bannerScrollView)
        pageControl.addTarget(self, action: #selector(self.changePage(sender:)), for: UIControl.Event.valueChanged)
        pageControl.accessibilityIdentifier = "BannerPageControl"
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            bannerScrollView.transform =  CGAffineTransform(rotationAngle: .pi);
        }
        
        
        // MARK: ongoing Projects
        ongoinProjectsLabel = UILabel()
        ongoinProjectsLabel.text = NSLocalizedString("Ongoing Projects", comment: "")
        ongoinProjectsLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        scrollView.addSubview(ongoinProjectsLabel)
        ongoinProjectsLabel.isHidden = true
        
        
        viewAllProjectsButton = UIButton()
        viewAllProjectsButton.setTitleColor(Color.red, for: .normal)
        viewAllProjectsButton.setTitle(NSLocalizedString("View all projects ", comment: ""), for: .normal)
        viewAllProjectsButton.addTarget(self, action: #selector(self.viewAllProjectsButtonAction), for: .touchUpInside)
        viewAllProjectsButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        var nextImage : UIImage!
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            nextImage = UIImage(named: "nextR")
            //.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            viewAllProjectsButton.semanticContentAttribute = .forceLeftToRight
        }else{
            nextImage = UIImage(named: "next")
                //.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)

            viewAllProjectsButton.semanticContentAttribute = .forceRightToLeft
        }
        viewAllProjectsButton.setImage(nextImage, for: .normal)
        scrollView.addSubview(viewAllProjectsButton)
        viewAllProjectsButton.isHidden = true
        
        
        projectsScrollView.accessibilityIdentifier = "ProjectsScrollView"
        projectsScrollView.tag = 2
        projectsScrollView.delegate = self
        projectsScrollView.backgroundColor = .white
        projectsScrollView.frame = CGRect(x:10, y:180, width:self.view.frame.size.width-20,height: 0)
        projectsScrollView.center.x = self.view.center.x
        projectsScrollView.showsHorizontalScrollIndicator = false
        projectsScrollView.delegate = self
        projectsScrollView.isPagingEnabled = true
        scrollView.addSubview(projectsScrollView)
        
        projectsScrollView.layer.cornerRadius = 5.0
        projectsScrollView.clipsToBounds = true
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            projectsScrollView.transform = CGAffineTransform(rotationAngle: .pi);
        }

        projectsPageControl.accessibilityIdentifier = "ProjectsPageControl"
        projectsPageControl.addTarget(self, action: #selector(self.changeProjectPage(sender:)), for: UIControl.Event.valueChanged)
        
        
        profilesLabel = UILabel()
        profilesLabel.text = NSLocalizedString("Featured Profiles", comment: "")
        profilesLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        scrollView.addSubview(profilesLabel)
        
        
        viewAllProfilesButton = UIButton()
        viewAllProfilesButton.setTitleColor(Color.red, for: .normal)
        viewAllProfilesButton.setTitle(NSLocalizedString("View all profiles ", comment: ""), for: .normal)
        viewAllProfilesButton.addTarget(self, action: #selector(self.viewAllProfilesAction), for: .touchUpInside)
        viewAllProfilesButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            nextImage = UIImage(named: "nextR")
            //.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            viewAllProfilesButton.semanticContentAttribute = .forceLeftToRight
        }else{
            nextImage = UIImage(named: "next")
                //.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            viewAllProfilesButton.semanticContentAttribute = .forceRightToLeft
        }
        
        viewAllProfilesButton.setImage(nextImage, for: .normal)
        scrollView.addSubview(viewAllProfilesButton)
        
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width/2)-20, height: 155)
        profilessCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        profilessCollectionView.dataSource = self
        profilessCollectionView.delegate = self
        profilessCollectionView.tag = 1
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        profilessCollectionView.register(ProfilesCVMiniCell.self, forCellWithReuseIdentifier: "CVCell")
        profilessCollectionView.showsHorizontalScrollIndicator = false
        profilessCollectionView.backgroundColor = UIColor.clear
        layout.scrollDirection = .horizontal
        scrollView.addSubview(profilessCollectionView)
        
        
        
        categoriesLabel = UILabel()
        categoriesLabel.text = NSLocalizedString("Categories", comment: "")
        categoriesLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        scrollView.addSubview(categoriesLabel)
        
        
        viewAllCategoriesButton = UIButton()
        viewAllCategoriesButton.addTarget(self, action: #selector(self.viewAllCategoriesAction), for: .touchUpInside)
        viewAllCategoriesButton.setTitleColor(Color.red, for: .normal)
        viewAllCategoriesButton.setTitle(NSLocalizedString("View all categories ", comment: ""), for: .normal)
        viewAllCategoriesButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
//        let nextImage1 = UIImage(named: "next")?.sd_resizedImage(with: CGSize(width: 08, height: 08), scaleMode: .aspectFit)
        viewAllCategoriesButton.setImage(nextImage, for: .normal)
        viewAllCategoriesButton.semanticContentAttribute = .forceRightToLeft
        scrollView.addSubview(viewAllCategoriesButton)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            nextImage = UIImage(named: "nextR")
            //.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            viewAllCategoriesButton.semanticContentAttribute = .forceLeftToRight
        }else{
            nextImage = UIImage(named: "next")
                //.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            viewAllCategoriesButton.semanticContentAttribute = .forceRightToLeft
        }
        
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.itemSize = CGSize(width: 80, height: 80)
        categoriessCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout1)
        categoriessCollectionView.dataSource = self
        categoriessCollectionView.delegate = self
        categoriessCollectionView.tag = 2
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        categoriessCollectionView.register(CategoriesCVCell.self, forCellWithReuseIdentifier: "CategoriesCVCell")
        categoriessCollectionView.showsHorizontalScrollIndicator = false
        categoriessCollectionView.backgroundColor = UIColor.clear
        layout1.scrollDirection = .horizontal
        scrollView.addSubview(categoriessCollectionView)
        
        
        trustView = UIView()
        trustView.backgroundColor = UIColor(red: 251/255, green: 246/255, blue: 224/255, alpha: 1.0)
        scrollView.addSubview(trustView)
        
        
        imgView = UIImageView()
        imgView.contentMode = .scaleAspectFill
        imgView.image = UIImage(named: "tag")
        trustView.addSubview(imgView)
        
        imgView.layer.cornerRadius = 10.0
        imgView.clipsToBounds = true
        
        
        titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("Get Trusted Professionals", comment: "")
        titleLabel.font = UIFont(name: "Avenir Heavy", size: 17)
        trustView.addSubview(titleLabel)
        
        descriptionLabel = UILabel()
        descriptionLabel.font = UIFont.systemFont(ofSize: 12.0)
        descriptionLabel.text = NSLocalizedString("Professional with highly experienced", comment: "")
        trustView.addSubview(descriptionLabel)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.fetchDashboardDetails), name: Notification.dashboard, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProfileDetails), name: Notification.profile, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notificationReceived), name: Notification.notification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openProfile), name: Notification.deepLink, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkSubscription), name: UIApplication.didBecomeActiveNotification, object: nil)
        if UserDefaults.standard.value(forKey: "isExistingUser") == nil{ return }
        
        updateProfileDetails()
        fetchDashboardDetails()
        
    }
    @objc func checkSubscription(){
        if UserDefaults.standard.value(forKey: "isExistingUser") == nil{ return }
        
        let date = Profile.shared.details?.expired_at ?? ""
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        let expireDate = formatter.date(from: date) ?? Date()
        
        //MARK : Validating payment status
        if Profile.shared.details?.is_company == "Yes"{
            if Profile.shared.details?.payment_status == "Pending" && (Profile.shared.details?.activate_trial ?? 0) == 0{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
                return
            }else if (Profile.shared.details?.activate_trial ?? 0) == 1 && Profile.shared.details?.profile_status == "Verified" && Profile.shared.details?.payment_status == "Pending",expireDate.toAgeDays() <= 0{
                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                vc.modalPresentationStyle = .overFullScreen
                self.present(vc, animated: true)
                return
            }
        }
    }
    
    //MARK: handling deep link to open profile
    @objc func openProfile(notification : NSNotification){
        
        checkSubscription()
        self.tabBarController?.tabBar.isHidden = true
        let profileId = notification.userInfo?["id"] as? String ?? ""
        CreateContract.shared.provider_id = Int(profileId)
        let vc = ProfileDetailsViewController()
        vc.profileId = Int(profileId)
        vc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func notificationReceived(notification: NSNotification){
        
        checkSubscription()
        
        self.tabBarController?.tabBar.isHidden = true

        //bringing home tab to foreground to make an active navigation
        self.tabBarController?.selectedIndex = 0
        
        //removing all view controllers on stack to make navigation from home
        self.navigationController?.popToRootViewController(animated: true)
        
        
        let notifyType = notification.userInfo?["type"] as? String ?? ""
        let notifyid = notification.userInfo?["id"] as? String ?? ""
        self.tabBarController?.tabBar.isHidden = true
        
        
        if NotificationType.HIRE_AGENCY == NotificationType(rawValue: notifyType){
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(notifyid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.PROJECT_AWARDED == NotificationType(rawValue: notifyType){
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(notifyid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.PROPOSAL_SUBMITTED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }

        //Projects
        else if NotificationType.PROJECT_CANCELLED == NotificationType(rawValue: notifyType){
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(notifyid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.PROJECT_AWARDED == NotificationType(rawValue: notifyType){
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(notifyid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.PROJECT_COMPLETED == NotificationType(rawValue: notifyType){
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(notifyid)
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //Hire request
        else if NotificationType.HIRE_REQUEST_ACCEPTED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsAgencyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.HIRE_REQUEST_REJECTED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsAgencyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //Contracts
        else if NotificationType.CONTRACT_ACCEPTED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsAgencyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.CONTRACT_REJECTED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.CONTRACT_RECEIVED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.REQUEST_REJECTED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        //Account
        
        else if NotificationType.VERIFIED == NotificationType(rawValue: notifyType){
            NotificationCenter.default.post(name: Notification.verified, object: nil, userInfo: nil)
       }
        else if NotificationType.REJECTED == NotificationType(rawValue: notifyType){
            NotificationCenter.default.post(name: Notification.rejected, object: nil, userInfo: nil)
        }
        
        //Milestone
        else if NotificationType.MILESTONE_PAYMENT_RECEIVED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsAgencyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.MILESTONE_PAYMENT_RELEASED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.MILESTONE_PAYMENT_REMINDER == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsAgencyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else if NotificationType.MILESTONE_PAYMENT_NOT_RECEIVED == NotificationType(rawValue: notifyType){
            CreateContract.shared.project_id = Int(notifyid)
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func viewAllProjectsButtonAction(){
        self.tabBarController?.selectedIndex = 3
    }
    @objc func viewAllCategoriesAction(){
        self.tabBarController?.selectedIndex = 1
    }
    
    func makeLayout(hideProjects : Bool){
        ongoinProjectsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(bannerScrollView.snp.bottom).offset(40)
        }
        
        viewAllProjectsButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(bannerScrollView)
            make.centerY.equalTo(ongoinProjectsLabel)
        }
        if hideProjects{
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 690)
            
            profilesLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(self.view).offset(10)
                make.top.equalTo(projectsScrollView.snp.bottom)
            }
        }else{
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 800)
            
            profilesLabel.snp.removeConstraints()
            profilesLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(self.view).offset(10)
                make.top.equalTo(projectsScrollView.snp.bottom).offset(35)
            }
        }
        
        viewAllProfilesButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(profilesLabel)
            make.trailing.equalTo(self.view).offset(-10)
        }
        
        if profilessCollectionViewHeight == 0{
            viewAllProfilesButton.isHidden = true
            profilesLabel.isHidden = true
        }
        
        profilessCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(profilessCollectionViewHeight)
            make.top.equalTo(profilesLabel.snp.bottom).offset(05)
        }
        
        categoriesLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(profilessCollectionView.snp.bottom).offset(15)
        }
        
        viewAllCategoriesButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-10)
            make.centerY.equalTo(categoriesLabel)
        }
        
        if categoriessCollectionViewHeight == 0{
            viewAllCategoriesButton.isHidden = true
            categoriesLabel.isHidden = true
        }
        
        categoriessCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).offset(10)
            make.height.equalTo(categoriessCollectionViewHeight)
            make.top.equalTo(categoriesLabel.snp.bottom).offset(05)
        }
        
        trustView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(categoriessCollectionView.snp.bottom).offset(20)
            make.height.equalTo(90)
        }
        
        imgView.snp.makeConstraints { (make) in
            make.leading.equalTo(trustView).inset(10)
            make.centerY.equalTo(trustView)
            make.width.height.equalTo(50)
        }
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(10)
            make.top.equalTo(imgView).inset(5)
        }
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
        }
    }
    
    func checkUserVerification(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ReviewPopupVC = storyboard.instantiateViewController(withIdentifier: "ReviewPopupVC") as! ReviewPopupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    //MARK: Coredata : updating profile details
    @objc func updateProfileDetails(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        
        WebServices.postRequest(url: Url.getProfile, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let profileResponse = try decoder.decode(CompleteProfile.self, from: data)
                if var profileData = profileResponse.data{
                    if profileData.name == nil { return }
                
                    UserDetailsCrud().saveProfile(profile: profileData) { _ in
                        Profile.shared.details = profileData
                        
//                        print(Profile.shared.details?.profile_status)
                                      
                        let date = profileData.expired_at ?? ""
                        let formatter = DateFormatter()
                        formatter.dateStyle = .short
                        formatter.dateFormat = "yyyy-MM-dd"
                        let expireDate = formatter.date(from: date) ?? Date()
                        
                        //MARK : Validating payment status
                        if Profile.shared.details?.is_company == "Yes"{
                            if profileData.payment_status == "Pending" && (Profile.shared.details?.activate_trial ?? 0) == 0{
                                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                            }else if (Profile.shared.details?.activate_trial ?? 0) == 1 && Profile.shared.details?.profile_status == "Verified" && Profile.shared.details?.payment_status == "Pending",expireDate.toAgeDays() <= 0{
                                let vc = UIStoryboard.instantiateViewController(withViewClass: PremiumMembershipViewController.self)
                                vc.modalPresentationStyle = .overFullScreen
                                self.present(vc, animated: true)
                            }
                            else if profileData.profile_status != "Verified"{
                                self.checkUserVerification()
                            }
                        }else{
                            if profileData.profile_status != "Verified"{
                                self.checkUserVerification()
                            }
                        }
                    }
                }                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    
    @objc func fetchDashboardDetails(){
        
        self.favIdsArray.removeAll()
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        scrollView.refreshControl?.beginRefreshing()
        WebServices.postRequest(url: Url.dashboard, params: parameters, viewController: self) { success,data  in
            self.scrollView.refreshControl?.endRefreshing()
            if success{
                do {
                    let decoder = JSONDecoder()
                    let dashboard = try decoder.decode(Dashboard.self, from: data)
                    print("response")
                    UserDefaults.standard.setValue(dashboard.data.agency_proposal_fees, forKey: "agency_proposal_fees")
                    if let appVersionString = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String, let apiVersionString = dashboard.data.version {
                        
                        if let appVersion = Double(appVersionString), let apiVersion = Double(apiVersionString){
                            if appVersion<apiVersion{
                                DispatchQueue.main.async {
                                    let updateVC = UpdateViewController()
                                    updateVC.updateString = dashboard.data.update_description
                                    updateVC.versionString = dashboard.data.version
                                    updateVC.modalPresentationStyle = .fullScreen
                                    self.present(updateVC, animated: true, completion: nil)
                                }
                            }else{
                                print("yeeh, latest version")
                            }
                        }
                    }
                    
                    //Banners
                    if let banners = dashboard.data.banners{
                        if banners.count>0{
                            
                            var bannerImageUrls = [String]()
                            for i in 0..<banners.count{
                                let  bannerName = banners[i].banner_file
                                let bannerUrl = Url.banner + bannerName
                                bannerImageUrls.append(bannerUrl)
                            }
                            
                            self.updateBanners(bannerImageUrls: bannerImageUrls)
                            self.configurePageControl(bannercount: bannerImageUrls.count)
                        }else{
                            
                            self.bannerScrollView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width-20,height: 0)
                            self.projectsScrollView.frame = CGRect(x:15, y:self.bannerScrollView.frame.maxY+60, width:self.view.frame.size.width-20,height: 140)
                            
                        }
                    }
                    
                    //Projects
                    var hideProjects = false
                    if let projectsData = dashboard.data.projects{
                        self.projects = projectsData
                        if projectsData.count>0{
                            self.ongoinProjectsLabel.isHidden = false
                            self.viewAllProjectsButton.isHidden = false
                            self.projectsScrollView.frame = CGRect(x:10, y:190, width:self.view.frame.size.width-20,height: 140)
                            self.updateProjects(projectsData: projectsData)
                            self.projectsPageControl.isHidden = false
                            hideProjects = false
                        }else{
                            self.ongoinProjectsLabel.isHidden = true
                            self.viewAllProjectsButton.isHidden = true
                            self.projectsScrollView.frame = CGRect(x:10, y:190, width:self.view.frame.size.width-20,height: 0)
                            self.projectsPageControl.isHidden = true
                            hideProjects = true
                        }
                    }
                   
                    //Profiles
                    
                    if let profilesData = dashboard.data.featuredProfiles{
                        if profilesData.count>0{
                            self.profiles = profilesData

                            for i in 0..<self.profiles.count{
                                let profile = self.profiles[i]
                                if profile.is_favorite == 1{
                                    self.favIdsArray.append(profile.id!)
                                }
                            }
                            
                            self.profilessCollectionViewHeight = 168
                            self.profilessCollectionView.reloadData()
                        }else{
                            self.profilessCollectionViewHeight = 0
                        }
                    }
                    
                  
                    
                    //Categories
                    
                    if let catsData = dashboard.data.categories{
                        if catsData.count>0{
                            self.categories = catsData
                            Categories.shared.list = self.categories
                            self.categoriessCollectionView.reloadData()
                            self.categoriessCollectionViewHeight = 90
                            
                        }else{
                            self.categoriessCollectionViewHeight = 0
                            
                        }
                    }
                    
                    self.makeLayout(hideProjects: hideProjects)
                     

                    
                }catch let error {
                    print("error \(error.localizedDescription)")
                }
            }else{
                Banner().displayValidationError(string: "Error")
            }
            
        }
        
    }
    
    func updateBanners(bannerImageUrls : [String]){
        
        //removing previously added subviews
        if bannerScrollView.subviews.count>0{
            for i in bannerScrollView.subviews{
                i.removeFromSuperview()
            }
        }
        
        self.bannerScrollView.contentSize = CGSize(width:self.bannerScrollView.frame.size.width * CGFloat(bannerImageUrls.count),height: self.bannerScrollView.frame.size.height)
        for index in 0..<bannerImageUrls.count {
            
            frame.origin.x = self.bannerScrollView.frame.size.width * CGFloat(index)
            frame.size = self.bannerScrollView.frame.size
            
            let bannerUrl = bannerImageUrls[index]
            let imageView = UIImageView(frame: frame)
            imageView.sd_setImage(with: URL(string: bannerUrl), placeholderImage: bannerPlaceholderImage, options: [], progress: nil, completed: nil)
            self.bannerScrollView.addSubview(imageView)
            
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                imageView.transform =  CGAffineTransform(rotationAngle: .pi);
            }
            
            imageView.layer.cornerRadius = 10.0
            imageView.clipsToBounds = true
        }
        
        
    }
    func updateProjects(projectsData : [ProjectsData]){
        
        //removing previously added subviews
        if projectsScrollView.subviews.count>0{
            for i in projectsScrollView.subviews{
                i.removeFromSuperview()
            }
        }
        
        
        var index = 0
        for project in projectsData{
            
            projectsFrame.origin.x = self.projectsScrollView.frame.size.width * CGFloat(index)
            projectsFrame.size = self.projectsScrollView.frame.size
            
            let projectsView = ProjectDetailsView()
            projectsView.frame = CGRect(x: CGFloat(index)*projectsScrollView.frame.size.width, y: 0, width: projectsScrollView.frame.size.width, height: projectsScrollView.frame.size.height)
            
            projectsView.statusButton.setTitle(project.status, for: .normal)
            projectsView.ongoingProjectNameLabel.text = project.name
            let budgetString = project.budget ?? "0"
            let budgetFloat = Float(budgetString)
            let budget = Int(budgetFloat ?? 0)
            projectsView.budgetLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(budget)"
            
            let costString = project.cost ?? "0"
            let costFloat = Float(costString)
            let cost = Int(costFloat ?? 0)
            projectsView.costLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(cost)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.date(from: project.start_at ?? "")
            let endDate = dateFormatter.date(from: project.end_at ?? "")
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = startDate{
                let dateString = dateFormatter.string(from: date)
                projectsView.startLabel.text = dateString
            }
            if let date = endDate{
                let dateString = dateFormatter.string(from: date)
                projectsView.stopLabel.text = dateString
            }
            projectsView.layer.cornerRadius = 10.0
            projectsView.clipsToBounds = true
            
            projectsView.isUserInteractionEnabled = true
            projectsView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(projectsViewAction)))
            
            projectsView.tag = index
            self.projectsScrollView.addSubview(projectsView)
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                projectsView.transform =  CGAffineTransform(rotationAngle: .pi);
            }
            self.projectsScrollView.contentSize = CGSize(width:self.projectsScrollView.frame.size.width * CGFloat(projectsData.count),height: self.projectsScrollView.frame.size.height)
            
            index += 1
        }
        
        
        configureProjectPageControl(count: projectsData.count)
        
    }
    @objc func projectsViewAction(gesture: UITapGestureRecognizer){
        let tag = gesture.view!.tag
        self.tabBarController?.tabBar.isHidden = true
        CreateContract.shared.project_id = projects[tag].id
        if Profile.shared.details?.is_agency=="Yes"{
            let vc = ProjectDetailsAgencyViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = ProjectDetailsViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func viewAllProfilesAction(){
//        self.tabBarController?.tabBar.isHidden = true
        let vc = FeaturedProfilesViewController()
        vc.view.backgroundColor = .white
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    // MARK: banner slider actions
    
    func configurePageControl(bannercount : Int) {
        // The total number of pages that are available is based on how many available colors we have.
        self.pageControl.numberOfPages = bannercount
        self.pageControl.currentPage = 0
        //        self.pageControl.tintColor = UIColor.red
        self.pageControl.pageIndicatorTintColor = UIColor.black
        self.pageControl.currentPageIndicatorTintColor = Color.red
        if #available(iOS 14.0, *) {
            pageControl.preferredIndicatorImage = UIImage(named: "Bar")
        } else {
            // Fallback on earlier versions
        }
        scrollView.addSubview(pageControl)
        pageControl.frame = CGRect(x: 0, y: 110, width: self.view.frame.width/2, height: 40)
        pageControl.center.x = scrollView.center.x
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changePage(sender: AnyObject) -> () {
        let x = CGFloat(pageControl.currentPage) * bannerScrollView.frame.size.width
        bannerScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    
    // MARK: project slider actions
    
    func configureProjectPageControl(count : Int) {
        // The total number of pages that are available is based on how many available colors we have.
        
        //        self.projectsPageControl.frame = CGRect(x: 0, y: 315, width: 160, height: 40)
        self.projectsPageControl.numberOfPages = count//bannerImageUrls.count
        self.projectsPageControl.currentPage = 0
        self.projectsPageControl.pageIndicatorTintColor = UIColor.black
        self.projectsPageControl.currentPageIndicatorTintColor = Color.red
        
        if #available(iOS 14.0, *) {
            projectsPageControl.preferredIndicatorImage = UIImage(named: "Bar")
        } else {
            // Fallback on earlier versions
        }
        
        scrollView.addSubview(projectsPageControl)
        projectsPageControl.isHidden = true
        self.projectsPageControl.frame = CGRect(x: 0, y: 320, width: self.view.frame.size.width/2, height: 40)
        self.projectsPageControl.center.x = scrollView.center.x
        
        
    }
    
    // MARK : TO CHANGE WHILE CLICKING ON PAGE CONTROL
    @objc func changeProjectPage(sender: AnyObject) -> () {
        let x = CGFloat(projectsPageControl.currentPage) * projectsScrollView.frame.size.width
        projectsScrollView.setContentOffset(CGPoint(x:x, y:0), animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView.tag == 1{
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            pageControl.currentPage = Int(pageNumber)
        }
        else if scrollView.tag == 2{
            let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
            projectsPageControl.currentPage = Int(pageNumber)
        }
        
    }
    
    
}

extension HomeViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == self.categoriessCollectionView{
            return 12
        }
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 08
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2{
            if categories.count>4{
                return 4
            }
            return categories.count
        }else{
            if profiles.count>2{
                return 2
            }
            return profiles.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! ProfilesCVMiniCell
            cell.alreadyHired.isHidden = true
            let profile = profiles[indexPath.row]
            
            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            
            let rating = profile.rating ?? "0"
            let jobs   = profile.job_received ?? 0
            cell.ratingButton.setTitle(" \(rating) (\(jobs) \(NSLocalizedString("jobs", comment: "")))", for: .normal)
            
            let mainCategory            = profile.main_category ?? ""
            cell.cateogoryLabel.text    = "\(mainCategory)"
            let childCategory           = profile.child_category ?? ""
            cell.infoLabel.text         = childCategory
            
            let chargesUnit             = profile.charges_unit ?? ""
            let chargesString = profile.charges ?? "0"
            let chargesFloat = Float(chargesString)
            let charges = Int(chargesFloat ?? 0)
            cell.priceLabel.text        = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit)"
            
            if favIdsArray.contains(profile.id!){
                cell.favouriteButton.tag = 1
                cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite_red"), for: .normal)
            }else{
                cell.favouriteButton.tag = 0
                cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite"), for: .normal)
            }
//            cell.favouriteButton.isUserInteractionEnabled = false
            cell.favouriteButton.row = indexPath.item
            cell.favouriteButton.addTarget(self, action: #selector(self.favouriteAction), for: .touchUpInside)
            
            return cell
        }
        else if collectionView.tag == 2{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVCell", for: indexPath) as! CategoriesCVCell
            
            let category = categories[indexPath.row]
            let categoryUrl = Url.categories + category.image
            cell.imageview.sd_setImage(with: URL(string: categoryUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.titleLabel.text = category.name
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 1{
            self.tabBarController?.tabBar.isHidden = true
            let profile = profiles[indexPath.row]
            //Saving providerid in shared class for create contract
            CreateContract.shared.provider_id = profile.provider_id
            CreateContract.shared.provider_profile_id = profile.id
            let vc = ProfileDetailsViewController()
            vc.profileId = profile.id
            vc.view.backgroundColor = .white
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else {
            let category = categories[indexPath.row]
            self.tabBarController?.tabBar.isHidden = true
            let vc = CateogryProfilesViewController()
            vc.category_id = category.id
            vc.titleString = category.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    @objc func favouriteAction(sender:FavButton){
        
        let profile = profiles[sender.row!]
        if favIdsArray.contains(profile.id!){
            favIdsArray.remove(at: favIdsArray.firstIndex(of: profile.id!)!)
        }else{
            favIdsArray.append(profile.id!)
        }
        
        if sender.tag == 1{
            if let row = sender.row {
                if let provider_id = profiles[row].provider_id, let provider_profile_id = profiles[row].id{
                    AddorRemoveFavourite.removeProfileFromFavourites(provider_id: provider_id, provider_profile_id: provider_profile_id, vc: self) { (success) in
                        if success{
                            self.profilessCollectionView.reloadData()
                        }
                    }
                }
            }
        }
        else{
            if let row = sender.row {
                if let provider_id = profiles[row].provider_id, let provider_profile_id = profiles[row].id{
                    AddorRemoveFavourite.addProfileToFavourites(provider_id: provider_id, provider_profile_id: provider_profile_id, vc: self) { (success) in
                        if success{
                            self.profilessCollectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
}



class ProfilesCVCell : UICollectionViewCell{
    
    var bgView : UIView!
    var imageView : UIImageView!
    var nameLabel : UILabel!
    var categoryLabel : UILabel!
    var category1Label : UILabel!

    var priceLabel : UILabel!
    var favouriteButton : FavButton!
    var ratingButton : UIButton!
    var alreadyHired : UIImageView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUI()
    }
    
    
    private func loadUI(){
        
        bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView)
        }
        
        bgView.layer.cornerRadius = 5.0
        bgView.clipsToBounds = true
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 0.5
        
        bgView.layer.shadowColor = UIColor.darkGray.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 6
        
        
        imageView = UIImageView()
        bgView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerY.equalTo(bgView)
            make.width.height.equalTo(70)
            make.leading.equalTo(10)
        }
        
        imageView.layer.cornerRadius = 35.0
        imageView.clipsToBounds = true
        
        
//        nameLabel = UILabel()
//        //        nameLabel.backgroundColor = .green
//        nameLabel.font = UIFont.systemFont(ofSize: 14)
//        bgView.addSubview(nameLabel)
//
//        nameLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(imageView).offset(10)
//            make.leading.equalTo(imageView.snp.trailing).offset(10)
//        }
        
        categoryLabel = UILabel()
        categoryLabel.textColor = .red
        categoryLabel.font = UIFont(name: "AvenirLTStd-Light", size: 08)
        bgView.addSubview(categoryLabel)
        
        categoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        category1Label = UILabel()
        category1Label.textColor = Color.liteBlack
        category1Label.font = UIFont(name: "Avenir Heavy", size: 15)
        bgView.addSubview(category1Label)
        
        category1Label.snp.makeConstraints { (make) in
            make.top.equalTo(categoryLabel.snp.bottom).offset(03)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        bgView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(category1Label.snp.bottom).offset(03)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        priceLabel = UILabel()
        priceLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        bgView.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(03)
            make.leading.equalTo(imageView.snp.trailing).offset(10)
        }
        
        
        
        favouriteButton = FavButton()
        favouriteButton.setBackgroundImage(UIImage(named: "favourite"), for: .normal)
        bgView.addSubview(favouriteButton)
        
        favouriteButton.clipsToBounds = true
        favouriteButton.contentHorizontalAlignment = .fill
        favouriteButton.contentVerticalAlignment = .fill
        favouriteButton.imageView?.contentMode = .scaleAspectFit
        
        favouriteButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView.snp.trailing).inset(10)
            make.top.equalTo(bgView.snp.top).inset(07)
            make.width.height.equalTo(20)
        }
        
        
        
        ratingButton = UIButton()
        let ratingImage = UIImage(named: "rating")
            //?.sd_resizedImage(with: CGSize(width: 09, height: 09), scaleMode: .aspectFit)
        ratingButton.setImage(ratingImage, for: .normal)
        ratingButton.setTitleColor(.black, for: .normal)
        ratingButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        bgView.addSubview(ratingButton)
        
        ratingButton.clipsToBounds = true
        ratingButton.contentHorizontalAlignment = .fill
        ratingButton.contentVerticalAlignment = .fill
        ratingButton.imageView?.contentMode = .scaleAspectFit
        
        ratingButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView.snp.trailing).inset(05)
            make.bottom.equalTo(bgView.snp.bottom).inset(07)
            make.height.equalTo(20)
//            make.width.equalTo(70)
        }
        
        let image = UIImage(named: "White-tick")
            //?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        alreadyHired = UIImageView()
        alreadyHired.image = image
        alreadyHired.contentMode = .center
        alreadyHired.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
        bgView.addSubview(alreadyHired)
        
        alreadyHired.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(imageView)
        }
        alreadyHired.layer.cornerRadius = 30
        alreadyHired.clipsToBounds = true
        self.contentView.bringSubviewToFront(alreadyHired)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class CategoriesCVCell : UICollectionViewCell{
    
    var bgView : UIView!
    var imageview : UIImageView!
    var titleLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUI()
    }
    
    
    private func loadUI(){
        
        bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView)
        }
        
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = true
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 0.5
        
        bgView.layer.shadowColor = UIColor.darkGray.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 6
        
        
        imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        bgView.addSubview(imageview)
        
        imageview.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).inset(20)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(25)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = UIColor.darkGray
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        titleLabel.numberOfLines = 0
        bgView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(bgView)
            make.top.equalTo(imageview.snp.bottom)
            make.bottom.equalTo(bgView)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UIView {
    
    func addDashedBorder(strokeColor: UIColor, lineWidth: CGFloat) {
        self.layoutIfNeeded()
        let strokeColor = strokeColor.cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = self.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: frameSize.height)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height/2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPattern = [5,5] // adjust to your liking
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: shapeRect.width, height: shapeRect.height), cornerRadius: self.layer.cornerRadius).cgPath
        
        self.layer.addSublayer(shapeLayer)
    }
    
}

