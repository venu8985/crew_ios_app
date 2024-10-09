//
//   .swift
//  Crew
//
//  Created by Rajeev on 03/03/21.
//

import UIKit
import ImageViewer_swift
import AVKit
import AVFoundation
class ProfileDetailsViewController: UIViewController,UIScrollViewDelegate {
    var skipProjects : Bool!
    var descLines : Int!
    
    var tab1height : CGFloat!
    var tab2Height : CGFloat!
    var tab3Height : CGFloat!
    
    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        return tableView.contentSize.height
    }
    
    //Banner
    let bannerScrollView = UIScrollView()
    //    var bannerImages = [UIImage(named: "farm_house")!,UIImage(named: "banner1")!, UIImage(named: "banner2")!, UIImage(named: "banner1")!]
    var frame: CGRect = CGRect(x:0, y:0, width:0, height:0)
    var ratingsContentHeight = 0.00
    var profileId : Int!
    var busySlots : [String]!
    var bannerImages : [ProviderGallery]!{
        didSet{
            updateBannerImages()
        }
    }
    
    var specialities : [ProviderSpecialities]!{
        didSet{
            aboutTableView.reloadData()
            
            tableView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.height.equalTo((specialities.count*30)+50)
                make.top.equalTo(segemntBGView.snp.bottom).offset(10)
            }
            
        }
    }
    
    var achievements : [ProviderAchievements]!{
        didSet{
            tableView.reloadData()
            print("achievements \(self.achievements)")
            tableView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.height.equalTo((achievements.count*30)+100)
                make.top.equalTo(segemntBGView.snp.bottom).offset(10)
            }
        }
    }
    
    var reviews : [Review]!{
        didSet{
            tableView.reloadData()
            
            tableView.snp.remakeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.height.equalTo((reviews.count*100)+50)
                make.top.equalTo(segemntBGView.snp.bottom).offset(10)
            }
        }
    }
    
    var height: CGFloat = 0
 
    
    var completionHander:((Int) -> Void)?
    
    
    //UI declarations
    var pageControl                  : UIPageControl = UIPageControl()
    var countButton                  : UIButton!
    var tableView                    : UITableView!
    var aboutView                    : UIView!
    var aboutTableView               : UITableView!
    var cateogoryLabel               : UILabel!
    var cateogory1Label              : UILabel!
    var nameLabel                    : UILabel!
    var priceLabel                   : UILabel!
    var locationDetailsLabel         : UILabel!
    var nameImageView                : UIImageView!
    var ratingButton                 : UIButton!
    var descLabel                    : UILabel!
    var locationImageView            : UIImageView!
    var segment                      : UISegmentedControl!
    var descTitleLabel               : UILabel!
    var lineView                     : UIView!
    var hireNowButton                : UIButton!
    var favButton                    : UIButton!
    var backButton                   : UIButton!
    var shareButton                  : UIButton!
    var segemntBGView                : UIView!
    var resumeButton                 : UIButton!
    var noProfilesLabel              : UILabel!
    
    var charges       : String!
    var chargesUnit   : String!
    var scrollView : UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        
        scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-65)
        }
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 1500)
        
        bannerScrollView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,height: 190)
        bannerScrollView.center.x = self.view.center.x
        bannerScrollView.showsHorizontalScrollIndicator = false
        bannerScrollView.showsVerticalScrollIndicator = false
        bannerScrollView.bounces = false
        bannerScrollView.delegate = self
        bannerScrollView.isPagingEnabled = true
        scrollView.addSubview(bannerScrollView)
        

        self.galleryButtons()
        
        
        cateogoryLabel = UILabel()
        cateogoryLabel.sizeToFit()
        cateogoryLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        cateogoryLabel.textColor = UIColor.red
        cateogoryLabel.numberOfLines = 0
        cateogoryLabel.textAlignment = .center
        scrollView.addSubview(cateogoryLabel)
        
        cateogoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bannerScrollView.snp.bottom).offset(15)
            make.leading.equalTo(bannerScrollView).offset(15)
        }
        
        cateogory1Label = UILabel()
        cateogory1Label.sizeToFit()
        cateogory1Label.font = UIFont(name: "Avenir Heavy", size: 14)
        cateogory1Label.textColor = UIColor.black
        cateogory1Label.numberOfLines = 0
        cateogory1Label.textAlignment = .center
        scrollView.addSubview(cateogory1Label)
        
        cateogory1Label.snp.makeConstraints { (make) in
            make.top.equalTo(cateogoryLabel.snp.bottom).offset(03)
            make.leading.equalTo(bannerScrollView).offset(15)
        }
        
            
        ratingButton = UIButton()
        let ratingImage = UIImage(named: "rating")
            //?.sd_resizedImage(with: CGSize(width: 09, height: 09), scaleMode: .aspectFit)
        ratingButton.setImage(ratingImage, for: .normal)
        ratingButton.setTitleColor(.black, for: .normal)
        ratingButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        scrollView.addSubview(ratingButton)
        
        ratingButton.clipsToBounds = true
        ratingButton.contentHorizontalAlignment = .fill
        ratingButton.contentVerticalAlignment = .fill
        ratingButton.imageView?.contentMode = .scaleAspectFit
        
        ratingButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-05)
            make.height.equalTo(20)
            make.centerY.equalTo(cateogoryLabel)
        }
        ratingButton.isHidden = true
        
        
        
        priceLabel = UILabel()
        priceLabel.textColor = Color.red
        priceLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        scrollView.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(cateogory1Label)
            make.top.equalTo(cateogory1Label.snp.bottom).offset(03)
        }
        
        
        locationImageView = UIImageView()
        locationImageView.image = UIImage(named: "location_2")
        locationImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(locationImageView)
        
        locationImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(cateogory1Label).offset(-2)
            make.top.equalTo(priceLabel.snp.bottom).offset(08)
            make.width.height.equalTo(12)
        }
        locationImageView.isHidden = true
        
        
        locationDetailsLabel = UILabel()
        locationDetailsLabel.numberOfLines = 0
        locationDetailsLabel.sizeToFit()
        locationDetailsLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        locationDetailsLabel.textColor = Color.gray
        scrollView.addSubview(locationDetailsLabel)
        
        locationDetailsLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(locationImageView.snp.trailing).offset(05)
            make.centerY.equalTo(locationImageView)
            make.trailing.equalTo(self.view).inset(80)
        }
        
        
        nameImageView = UIImageView()
        nameImageView.contentMode = .scaleAspectFill
        scrollView.addSubview(nameImageView)
        
        nameImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(cateogory1Label)
            make.top.equalTo(locationDetailsLabel.snp.bottom).offset(08)
            make.width.height.equalTo(24)
        }
        
        nameImageView.layer.cornerRadius = 12.0
        nameImageView.clipsToBounds = true
        
        
        nameLabel = UILabel()
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: "Avenir Medium", size: 15)
        nameLabel.textColor = UIColor.darkGray
        scrollView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameImageView.snp.trailing).offset(10)
            make.centerY.equalTo(nameImageView)
        }
        
        
        segemntBGView = UIView()
        segemntBGView.backgroundColor = Color.litePink
        scrollView.addSubview(segemntBGView)
        
        segemntBGView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(nameLabel.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        segemntBGView.isHidden = true
        
        let items = [NSLocalizedString("About", comment: ""),
                     NSLocalizedString("Achievement", comment: ""),
                     NSLocalizedString("Ratings", comment: "")]
        
        segment = UISegmentedControl(items: items)
        segment.selectedSegmentTintColor = UIColor.white
        //        let favImage = UIImage(named: "SemgentBG")?.sd_resizedImage(with: CGSize(width: self.view.frame.size.width-40, height: 40), scaleMode: .aspectFit)
        //        segment.setBackgroundImage(favImage, for: .normal, barMetrics: .default)
        
        
        segment.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: 12)
        segment.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: .valueChanged)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.red], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        segemntBGView.addSubview(segment)
        segment.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.centerY.equalToSuperview()
            //            make.top.equalTo(nameLabel.snp.bottom).offset(20)
        }
        segment.isHidden = true
        
        
        if Profile.shared.details?.is_agency == "Yes"{
            
            hireNowButton = UIButton()
            hireNowButton.setTitle(NSLocalizedString("Hire Now", comment: ""), for: .normal)
            hireNowButton.backgroundColor = Color.red
            hireNowButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
            hireNowButton.addTarget(self, action: #selector(self.hireNowAction), for: .touchUpInside)
            self.view.addSubview(hireNowButton)
            
            hireNowButton.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.leading.trailing.bottom.equalTo(self.view).inset(20)
            }
            
            hireNowButton.layer.cornerRadius = 5.0
            hireNowButton.clipsToBounds = true
            hireNowButton.isHidden = true
            
            lineView = UIView()
            lineView.backgroundColor = Color.liteGray
            scrollView.addSubview(lineView)
            
            lineView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.height.equalTo(1)
                make.bottom.equalTo(hireNowButton.snp.top).offset(-10)
            }
            lineView.isHidden = true
        }
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tag = 1
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        scrollView.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ReviewTVCell.self, forCellReuseIdentifier: "ReviewCell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-65)
            make.top.equalTo(segemntBGView.snp.bottom).offset(10)
        }
        tableView.isHidden = true
        
        
        noProfilesLabel = UILabel()
        noProfilesLabel.textAlignment = .center
        noProfilesLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        scrollView.addSubview(noProfilesLabel)
        noProfilesLabel.isHidden = true
        noProfilesLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(segemntBGView.snp.bottom).offset(50)
        }

        
        aboutView = UIView()
        aboutView.backgroundColor = .white
        scrollView.addSubview(aboutView)
        
        aboutView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-65)
            make.top.equalTo(segemntBGView.snp.bottom).offset(10)
        }
        aboutView.isHidden = false
        
        
        descTitleLabel = UILabel()
        descTitleLabel.text = NSLocalizedString("Description", comment: "")
        descTitleLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        aboutView.addSubview(descTitleLabel)
        
        descTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(aboutView)
            make.leading.equalTo(aboutView).offset(20)
        }
        descTitleLabel.isHidden = true
        
        descLabel = UILabel()
        descLabel.textColor = Color.gray
        descLabel.textAlignment = .justified
        descLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        descLabel.numberOfLines = 0
        aboutView.addSubview(descLabel)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            descLabel.textAlignment = .right
        }else{
            descLabel.textAlignment = .left
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(descTitleLabel)
            make.trailing.equalTo(aboutView).offset(-10)
            make.top.equalTo(descTitleLabel.snp.bottom).offset(10)
        }
        
        let resumeImage = UIImage(named: "resume")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        resumeButton = UIButton()
        resumeButton.setTitle(NSLocalizedString("  Resume", comment: ""), for: .normal)
        resumeButton.setTitleColor(UIColor.black, for: .normal)
        resumeButton.setImage(resumeImage, for: .normal)
        resumeButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        resumeButton.backgroundColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        scrollView.addSubview(resumeButton)
        
        resumeButton.snp.makeConstraints { (make) in
            make.width.equalTo(140)
            make.height.equalTo(40)
            make.leading.equalTo(descLabel)
            make.top.equalTo(descLabel.snp.bottom).offset(10)
        }
        resumeButton.layer.cornerRadius = 5.0
        resumeButton.clipsToBounds = true
        resumeButton.isHidden = true
        
        aboutTableView = UITableView()
        aboutTableView.dataSource = self
        aboutTableView.delegate = self
        aboutTableView.separatorStyle = .none
        aboutTableView.tag = 3
        aboutTableView.isScrollEnabled = false
        aboutTableView.tableFooterView = UIView()
        aboutView.addSubview(aboutTableView)
        aboutTableView.register(UITableViewCell.self, forCellReuseIdentifier: "aboutCell")
        
        aboutTableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(aboutView)
            make.bottom.equalTo(aboutView).offset(-10)
            make.top.equalTo(resumeButton.snp.bottom).offset(10)
        }
        tableView.isHidden = true
        /*
         */
        fetchProfileDetails()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProjectAction), name: Notification.updateProject, object: nil)

    }
    
    @objc func updateProjectAction(){
        fetchProfileDetails()
    }
    
    //MARK: Webservices
    func fetchProfileDetails(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "provider_profile_id" : profileId ?? 0
            
        ]
        
        WebServices.postRequest(url: Url.providerProfileDetails, params: parameters, viewController: self) { success,data  in
            
            if success{
                do {
                    let decoder = JSONDecoder()
                    let providerProfileDetails = try decoder.decode(ProviderProfileDetails.self, from: data)
                    
                    if let gallery = providerProfileDetails.data.gallery {
                        
                        self.bannerImages = gallery
                        
                        if providerProfileDetails.data.is_favorite == 1{
                            self.favButton.tag = 1
                            let favImage = UIImage(named: "favourite_red")
                                //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                            self.favButton.setImage(favImage, for: .normal)
                        }else{
                            self.favButton.tag = 0
                            let favImage = UIImage(named: "favorite")
                                //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                            self.favButton.setImage(favImage, for: .normal)
                        }
                        
                        self.bannerScrollView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,height: 190)
                        self.bannerScrollView.isHidden = false
                        
                        self.pageControl.isHidden = false
                    }
                    
                    //Saving providerid in shared class for create contract
                    CreateContract.shared.provider_id = providerProfileDetails.data.provider_id
                    CreateContract.shared.provider_profile_id = providerProfileDetails.data.id
                    
                    self.cateogoryLabel.text = providerProfileDetails.data.main_category ?? ""
                    self.cateogory1Label.text = providerProfileDetails.data.child_category ?? ""
                    self.nameLabel.text = providerProfileDetails.data.name ?? ""
                    
//                    self.charges = providerProfileDetails.data.charges ?? ""
//                    self.chargesUnit = providerProfileDetails.data.charges_unit ?? ""
//                    self.priceLabel.text = "SAR \(self.charges ?? "")/\(self.chargesUnit ?? "")"
                    
                    
                    self.chargesUnit = providerProfileDetails.data.charges_unit ?? ""
                    let chargesString = providerProfileDetails.data.charges ?? "0"
                    let chargesFloat = Float(chargesString)
                    let chargesInt = Int(chargesFloat ?? 0)
                    self.charges = String(chargesInt)
                    self.priceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(self.charges ?? "")/\(self.chargesUnit ?? "")"
                    
                    let cityName = providerProfileDetails.data.city_name ?? ""
                    let countryName = providerProfileDetails.data.country_name ?? ""
                    self.locationDetailsLabel.text = "\(cityName),\(countryName)"
                    
                    
                    let profileImageURL = Url.providers + (providerProfileDetails.data.profile_image ?? "")
                    self.nameImageView.sd_setImage(with: URL(string: profileImageURL), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
                    
                    if let jobs = providerProfileDetails.data.job_received,let rating = providerProfileDetails.data.rating{
                        self.ratingButton.isHidden = false
                        self.ratingButton.setTitle(" \(rating) (\(jobs) \(NSLocalizedString("jobs", comment: "")))", for: .normal)
                    }else{
                        self.ratingButton.isHidden = true
                    }
                    self.scrollView.bringSubviewToFront(self.ratingButton)
                    let descString = providerProfileDetails.data.description ?? ""
                    
                    // Below code is to create line gap
                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.minimumLineHeight = 15
                    paragraphStyle.maximumLineHeight = 15
                    paragraphStyle.alignment = .left
                    let attrString = NSMutableAttributedString(string: descString)
                    attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirLTStd-Book", size: 12)!, range: NSRange(location: 0, length: attrString.length))
                    attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
                    self.descLabel.text = descString
                    
                    self.descLines = self.lines(label: self.descLabel)
                    self.specialities = providerProfileDetails.data.specialities
                    
                    
           
                    
                    self.achievements = providerProfileDetails.data.achievements
                    self.reviews = providerProfileDetails.data.reviews
                    
                    self.busySlots = providerProfileDetails.data.busySlots
                    
                    self.locationImageView.isHidden    = false
                    self.segment.isHidden              = false
                    self.descTitleLabel.isHidden       = false
                    if self.lineView != nil{
                        self.lineView.isHidden             = false
                    }
                    if self.hireNowButton != nil{
                        self.hireNowButton.isHidden             = false
                    }
                    self.resumeButton.isHidden = false
                    self.segemntBGView.isHidden = false
//                    let specilitiesHeight = CGFloat((self.specialities.count*30)+660)+CGFloat(self.descLines*20)
//                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: specilitiesHeight)
                    
//                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 2500)
                    
                    let aboutHeight = CGFloat((self.specialities.count*30)+500+(self.descLines*25))
                    self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: aboutHeight)
                }catch let error {
                    print("Error \(error.localizedDescription)")
                }
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Invalid input", comment: ""))
                
            }
            
        }
        
        
    }
    func lines(label: UILabel) -> Int {
        let textSize = CGSize(width: label.frame.size.width, height: CGFloat(Float.infinity))
        let rHeight = lroundf(Float(label.sizeThatFits(textSize).height))
        let charSize = lroundf(Float(label.font.lineHeight))
        let lineCount = rHeight/charSize
        return lineCount
    }
    
    func checkUserVerification(){
//        self.tabBarController?.tabBar.isHidden = true
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ReviewPopupVC = storyboard.instantiateViewController(withIdentifier: "ReviewPopupVC") as! ReviewPopupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    @objc func hireNowAction(){
        if Profile.shared.details?.profile_status != "Verified"{
            checkUserVerification()
        }else{
            //Saving details in shared class for create contract
            CreateContract.shared.charges = self.charges
            CreateContract.shared.chargesUnit = self.chargesUnit
            
            let vc = DatesViewController()
            vc.reservedDatesArray = busySlots
            vc.skipProjects = skipProjects
            self.navigationController?.pushViewController(vc, animated: true)
        }        
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        

        
        if sender.selectedSegmentIndex == 0 {
            tableView.isHidden = true
            aboutView.isHidden = false
            aboutTableView.reloadData()
            let specilitiesHeight = CGFloat((self.specialities.count*30)+50)

            resumeButton.isHidden = false
            
            let aboutHeight = CGFloat((self.specialities.count*30)+500+(self.descLines*25))
            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: aboutHeight)
            
            }else if sender.selectedSegmentIndex == 1{
                let acheives = self.achievements
                self.achievements = acheives
            aboutView.isHidden = true
            resumeButton.isHidden = true
             
            if self.achievements.count>0{
                noProfilesLabel.isHidden = true
                tableView.isHidden = false
                tableView.tag = 1
                tableView.reloadData()
//                print("contt \(ratingsContentHeight)")

            }else{
                noProfilesLabel.text = NSLocalizedString("No achievements found", comment: "")
                tableView.isHidden = true
                noProfilesLabel.isHidden = false
            }
                scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 400+tableViewHeight)

        }else if sender.selectedSegmentIndex == 2{
            aboutView.isHidden = true
            resumeButton.isHidden = true
            
            if reviews.count>0{
                tableView.isHidden = false
                noProfilesLabel.isHidden = true
                tableView.tag = 2
                tableView.reloadData()
//                print("contt \(ratingsContentHeight)")
            }else{
                noProfilesLabel.text = NSLocalizedString("No reviews found", comment: "")
                tableView.isHidden = true
                noProfilesLabel.isHidden = false
            }
            
        }
        
//        print("tab 1 height \(tab1height)")
//        print("tab 2 height \(tab2Height)")
//        print("tab 3 height \(tab3Height)")
//        print("height111 \(tableViewHeight)")
//        if tableView == aboutTableView{
//            let aboutHeight = CGFloat((self.specialities.count*30)+500+(self.descLines*25))
//            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: aboutHeight)
//        }else{
//            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 400+tableViewHeight)
//
//        }

    }
    
    
    func galleryButtons(){
        
        
//        let backImage = UIImage(named: "back_white")?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        backButton = UIButton()
        backButton.addTarget(self, action: #selector(self.backButtonAction), for: .touchUpInside)
        backButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        scrollView.addSubview(backButton)
        scrollView.bringSubviewToFront(backButton)
        
        
        
        let shareImage = UIImage(named: "share")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        shareButton = UIButton()
        shareButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        shareButton.setImage(shareImage, for: .normal)
        shareButton.addTarget(self, action: #selector(self.shareButtonAction), for: .touchUpInside)
        scrollView.addSubview(shareButton)
        scrollView.bringSubviewToFront(shareButton)
        
        
        
        let favImage = UIImage(named: "favorite")//?.sd_resizedImage(with: CGSize(width: 14, height: 14), scaleMode: .aspectFit)
        favButton = UIButton()
        favButton.addTarget(self, action: #selector(favButtonAction), for: .touchUpInside)
        favButton.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        favButton.setImage(favImage, for: .normal)
        scrollView.addSubview(favButton)
        
        scrollView.bringSubviewToFront(favButton)
        
        
        let countImage = UIImage(named: "image")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        countButton = UIButton()
        countButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        countButton.backgroundColor = UIColor.black.withAlphaComponent(0.25)
        countButton.setImage(countImage, for: .normal)
        scrollView.addSubview(countButton)
        
        countButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        countButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        
        countButton.layer.cornerRadius = 03
        countButton.clipsToBounds = true
        
        scrollView.bringSubviewToFront(countButton)
        
        
        countButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.bannerScrollView.snp.bottom).offset(-10)
            make.leading.equalTo(self.bannerScrollView.snp.leading).offset(10)
            make.height.equalTo(30)
        }
        countButton.isHidden = true
        
    }
    
    
    @objc func backButtonAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func shareButtonAction(){
        
        let link = "http://crew-sa.com/provider/\(self.profileId ?? 0)/\(UserDefaults.standard.value(forKey: "Language") as? String ?? "")"
        let items = [self.nameLabel.text,link]
        let ac = UIActivityViewController(activityItems: items as [Any], applicationActivities: nil)
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func favButtonAction(_ sender : UIButton){
        
        let provider_id = CreateContract.shared.provider_id ?? 0
        let provider_profile_id = CreateContract.shared.provider_profile_id ?? 0
        
        if sender.tag == 1{
            AddorRemoveFavourite.removeProfileFromFavourites(provider_id: provider_id, provider_profile_id: provider_profile_id, vc: self) { (success) in
                if success{
                    let favImage = UIImage(named: "favorite")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                    self.favButton.setImage(favImage, for: .normal)
                    self.favButton.tag = 0
                    self.completionHander?(0)
                    NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                    NotificationCenter.default.post(name: Notification.fetchProfiles, object: nil)
                    
                }
            }
        }
        else{
            AddorRemoveFavourite.addProfileToFavourites(provider_id: provider_id, provider_profile_id: provider_profile_id, vc: self) { (success) in
                if success{
                    let favImage = UIImage(named: "favourite_red")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                    self.favButton.setImage(favImage, for: .normal)
                    self.favButton.tag = 1
                    self.completionHander?(1)
                    NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                    NotificationCenter.default.post(name: Notification.fetchProfiles, object: nil)
                }
            }
        }
    }
    
    //Updating banner images
    
    func updateBannerImages(){
        
        //gallery scrollview content size
        self.bannerScrollView.contentSize = CGSize(width:self.bannerScrollView.frame.size.width * CGFloat(bannerImages.count),height: self.bannerScrollView.frame.size.height)
        self.bannerScrollView.frame = CGRect(x:0, y:0, width:self.view.frame.size.width,height: 190)
        self.bannerScrollView.contentInsetAdjustmentBehavior = .never
        
        for index in 0..<bannerImages.count {
            
            frame.origin.x = self.bannerScrollView.frame.size.width * CGFloat(index)
            frame.size = self.bannerScrollView.frame.size
            
            let imageView = UIImageView(frame: frame)
            self.bannerScrollView.addSubview(imageView)
            if bannerImages[index].thumb == nil{
                let bannerUrl = Url.gallery + (bannerImages[index].filename ?? "")
                imageView.sd_setImage(with: URL(string: bannerUrl), placeholderImage: bannerPlaceholderImage, options: [], progress: nil, completed: nil)
            }else{
                let bannerUrl = Url.gallery + (bannerImages[index].thumb ?? "")
                imageView.sd_setImage(with: URL(string: bannerUrl), placeholderImage: bannerPlaceholderImage, options: [], progress: nil, completed: nil)
                let btnPlay = UIButton(frame: frame)
                btnPlay.tag = index
                btnPlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                btnPlay.setImage(UIImage(named: "play"), for: .normal)
                btnPlay.addTarget(self, action: #selector(btnVideoTap), for: .touchUpInside)
                self.bannerScrollView.addSubview(btnPlay)
            }
           
            imageView.backgroundColor = Color.liteWhite
            imageView.contentMode = .scaleAspectFit
            //            imageView.image = UIImage(named: "banner2")
            imageView.layer.cornerRadius = 10.0
            imageView.clipsToBounds = true
        }
  
        if bannerImages.count>0{
            countButton.setTitle( " 1 of \(bannerImages.count)    ", for: .normal)
            countButton.isHidden = false
        }else{
            countButton.isHidden = true
        }

        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            let backImage = UIImage(named: "back_white-R")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            backButton.setImage(backImage, for: .normal)

        }else{
            let backImage = UIImage(named: "back_white")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            backButton.setImage(backImage, for: .normal)


        }
        backButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).inset(10)
            make.top.equalTo(bannerScrollView).offset(05)
            make.width.height.equalTo(36)
        }

        backButton.layer.cornerRadius = 18
        backButton.clipsToBounds = true
        
        
        shareButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-10)
            make.top.equalTo(bannerScrollView).offset(05)
            make.width.height.equalTo(36)
        }
        shareButton.layer.cornerRadius = 18
        shareButton.clipsToBounds = true
        
        
        favButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(shareButton.snp.leading).offset(-15)
            make.top.equalTo(bannerScrollView).offset(05)
            make.width.height.equalTo(36)
        }
        favButton.layer.cornerRadius = 18
        favButton.clipsToBounds = true
        
    }
    @objc func btnVideoTap(_ sender:UIButton){
        let videoURL = URL(string: Url.gallery + (bannerImages[sender.tag].filename ?? ""))
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        countButton.setTitle( " \(self.pageControl.currentPage+1) of \(bannerImages.count)    ", for: .normal)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false
        
    }
    
    
}


extension ProfileDetailsViewController : UITableViewDelegate, UITableViewDataSource{
    
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//
//
//        if tableView.indexPathsForVisibleRows!.last == nil { return }
//
//        if indexPath.row == (tableView.indexPathsForVisibleRows!.last! as NSIndexPath).row {
//            let contentSize : CGSize = self.tableView.contentSize
//            let width = self.tableView.contentSize.width
//            let height1 = self.tableView.contentSize.height
//
//            print("height112 \(height1)")
            /*
            if tableView.tag == 1{
                tab2Height = height1
                print("tab height2 \(height1)")
            }
            else if tableView.tag == 2{
                tab3Height = height1
                print("tab height3 \(height1)")
            }
            else{
                tab1height = height1
                print("tab height1 \(height1)")

            }
            */
            
//            if aboutView.isHidden == true{
//                scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(height1+400))
//            }else{
//                scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat(height1+500)+CGFloat(descLines*15))
//            }
//            ratingsContentHeight = Double(height1+400)

//        }
//    }
    

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 10, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 20, y: 7, width: view.frame.size.width-40, height: 25))
        label.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        if tableView.tag == 1{
            if achievements != nil{
                if achievements.count>0{
                    label.text = NSLocalizedString("Achievement", comment: "")
                }
            }
        }
        else if tableView.tag == 2{
            label.text = "" //Reviews
        }
        else if tableView.tag == 3{
            if specialities != nil{
                label.text = NSLocalizedString("Speciality", comment: "")
            }
        }
        
        //        label.font = UIFont(name: "AvenirLTStd-Heavy", size: 14.0)
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView.tag == 3{
            return 30
        }
        else if tableView.tag == 1{
            return 30
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView.tag == 1{
            if achievements != nil{
                return achievements.count
            }else{
                return 0
            }
        }
        if tableView.tag == 2{
            if reviews != nil{
                return reviews.count
            }else{
                return 0
            }
        }
        else if tableView.tag == 3{
            if specialities != nil{
                return specialities.count
            }else{
                return 0
            }
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView.tag == 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
            cell?.selectionStyle = .none
            cell?.imageView?.image = UIImage(named: "Achievement")//?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
            cell?.textLabel?.text = achievements[indexPath.row].achievement_name
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
            
            cell?.textLabel?.textColor = Color.liteBlack
            return cell!
        }
        else if tableView.tag == 2{
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewCell") as! ReviewTVCell
            cell.selectionStyle = .none
            
            let review = reviews[indexPath.row]
            cell.nameLabel.text = review.name
            cell.ratingButton.setTitle(review.rating, for: .normal)
            cell.descLabel.text = review.feedback
            
            var imageUrl = ""
            if review.profile_image != nil{
                imageUrl = Url.userProfile + review.profile_image
            }
            cell.imgView.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)

            if let createdAt = review.created_at{
                let inputFormatter = DateFormatter()
                inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                if let date = inputFormatter.date(from: createdAt) {
                    let timeAgo = timeAgoSinceLast(date)
                    cell.daysAgoLabel.text = timeAgo
                }
            }
            return cell
        }
        else if tableView.tag == 3{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "aboutCell")
            cell?.selectionStyle = .none
            let speciality = specialities[indexPath.row]
            cell?.selectionStyle = .none
            cell?.imageView?.image = UIImage(named: "Specialty")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            let specialityString = speciality.speciality_name
            
            // Below code is to create line gap
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.minimumLineHeight = 15
            paragraphStyle.maximumLineHeight = 15
            paragraphStyle.alignment = .left
            let attrString = NSMutableAttributedString(string: specialityString!)
            attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: "AvenirLTStd-Book", size: 12)!, range: NSRange(location: 0, length: attrString.length))
            attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
            cell?.textLabel?.attributedText = attrString
            
            cell?.textLabel?.numberOfLines = 0
            cell?.textLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
            cell?.textLabel?.textColor = UIColor.darkGray
            
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"
            {
                cell?.textLabel?.textAlignment = .right
            }else{
                cell?.textLabel?.textAlignment = .left
            }
            
            return cell!
        }
        
        return UITableViewCell()
        
    }
    
}


class ReviewTVCell : UITableViewCell{
    
    var imgView : UIImageView!
    var nameLabel : UILabel!
//    var countryLabel : UILabel!
    var descLabel : UILabel!
    var ratingButton : UIButton!
    var daysAgoLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imgView = UIImageView()
        self.contentView.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.leading.top.equalTo(self.contentView).offset(05)
            make.width.height.equalTo(40)
        }
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "Avenir Heavy", size: 14.0)
        self.contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(15)
            make.top.equalTo(imgView)
        }
        

        descLabel = UILabel()
        descLabel.textColor = Color.liteBlack
        descLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        descLabel.numberOfLines = 0
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            descLabel.textAlignment = .right
        }else{
            descLabel.textAlignment = .left
        }
        self.contentView.addSubview(descLabel)
        
        descLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(self.contentView)
            make.top.equalTo(nameLabel.snp.bottom).offset(12)
            make.bottom.equalTo(self.contentView).offset(-40)
        }
        
        
        
        ratingButton = UIButton()
        let ratingImage = UIImage(named: "rating")//?.sd_resizedImage(with: CGSize(width: 09, height: 09), scaleMode: .aspectFit)
        ratingButton.setImage(ratingImage, for: .normal)
        ratingButton.isUserInteractionEnabled = false
        ratingButton.setTitleColor(.black, for: .normal)
        ratingButton.titleLabel?.font = UIFont.systemFont(ofSize: 08)
        self.contentView.addSubview(ratingButton)
        
        ratingButton.clipsToBounds = true
        ratingButton.contentHorizontalAlignment = .right
        ratingButton.contentVerticalAlignment = .fill
        ratingButton.imageView?.contentMode = .scaleAspectFit
        
        ratingButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.contentView).offset(-05)
            make.top.equalTo(nameLabel).offset(-10)
            make.height.equalTo(20)
            make.width.equalTo(40)
        }
        
        daysAgoLabel = UILabel()
        daysAgoLabel.textColor = Color.gray
        daysAgoLabel.font = UIFont.systemFont(ofSize: 10)
        self.contentView.addSubview(daysAgoLabel)
        
        daysAgoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ratingButton.snp.bottom)
            make.trailing.equalTo(ratingButton)
        }
        
        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.trailing.equalTo(self.contentView)
            make.height.equalTo(1)
            make.bottom.equalTo(descLabel.snp.bottom).offset(10)
        }
        lineView.isHidden = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//extension UISegmentedControl{
//    func selectedSegmentTintColor(_ color: UIColor) {
//        self.setTitleTextAttributes([.foregroundColor: color], for: .selected)
//    }
//    func unselectedSegmentTintColor(_ color: UIColor) {
//        self.setTitleTextAttributes([.foregroundColor: color], for: .normal)
//    }
//}
