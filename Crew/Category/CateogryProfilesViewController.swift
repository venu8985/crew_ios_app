//
//  CateogryProfilesViewController.swift
//  Crew
//
//  Created by Rajeev on 25/03/21.
//

import UIKit

class CateogryProfilesViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var isGrid = true
    var picsCollectionView : UICollectionView!
    var layout : UICollectionViewFlowLayout!
    var profiles = [FeaturedProfile]()
    var selectedProfiles = [FeaturedProfile]()
    var paginationCount = 0
    var lastPage : Int!
    var category_id : Int!
    var skipProjects : Bool!
    var providers : [ResourcesData]!
    var providerIds = [Int]()
    var titleString = NSLocalizedString("Featured Profiles", comment: "")
    var filtersDict = NSMutableDictionary()
    var isNotifyAudition = false
    var auditionIndex = [Int]()
    var projectName : String!
    var audtions : [Audtions]!
    var sortButton : UIButton!
    var refreshControl : UIRefreshControl!
    var favIdsArray = [Int]()
    var noProfilesLabel : UILabel!
//    let controller = ProfilesFilterViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adding filter screen
        
//        self.addChild(controller)
//        self.view.addSubview(controller.view)
//        controller.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
//        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
//        controller.didMove(toParent: self)
//        controller.view.alpha = 0
//        self.view.bringSubviewToFront(controller.view)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDetails), name: Notification.fetchProfiles, object: nil)

        if !isNotifyAudition{
            if providers != nil{
                for provider in providers{
                    if let id = provider.provider_profile_id{
                        providerIds.append(id)
                    }
                }
            }
        }else{
            if audtions != nil{
                for audtion in audtions{
                    if let id = audtion.provider_profile_id{
                        providerIds.append(id)
                    }
                }
            }
        }
     
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width/2)-20, height: 150)
        picsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picsCollectionView.dataSource = self
        picsCollectionView.delegate = self
        picsCollectionView.tag = 1
        picsCollectionView.showsVerticalScrollIndicator = false
        picsCollectionView.register(ProfilesCVMiniCell.self, forCellWithReuseIdentifier: "CVCellMini")
        picsCollectionView.register(ProfilesCVCell.self, forCellWithReuseIdentifier: "CVCell")
        
        picsCollectionView.showsHorizontalScrollIndicator = false
        picsCollectionView.backgroundColor = UIColor.clear
        layout.scrollDirection = .vertical
        self.view.addSubview(picsCollectionView)
        
        picsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view).offset(10)
            make.leading.trailing.bottom.equalTo(self.view).inset(12)
        }
        picsCollectionView.isHidden = true
        
        noProfilesLabel = UILabel()
        noProfilesLabel.text = NSLocalizedString("No profiles found", comment: "")
        noProfilesLabel.textAlignment = .center
        noProfilesLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.view.addSubview(noProfilesLabel)
        noProfilesLabel.isHidden = true
        noProfilesLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        if isNotifyAudition{
            
            let sendReqButton = UIButton()
            sendReqButton.setTitle(NSLocalizedString("Send Request", comment: ""), for: .normal)
            sendReqButton.backgroundColor = Color.red
            sendReqButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
            sendReqButton.addTarget(self, action: #selector(self.sendReqButtonAction), for: .touchUpInside)
            self.view.addSubview(sendReqButton)
            
            sendReqButton.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.leading.trailing.equalTo(self.view).inset(20)
                make.bottom.equalTo(self.view).offset(-10)
            }
            sendReqButton.layer.cornerRadius = 5.0
            sendReqButton.clipsToBounds = true
            
            
            picsCollectionView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.view).offset(10)
                make.leading.trailing.equalTo(self.view).inset(10)
                make.bottom.equalTo(sendReqButton.snp.top).offset(-5)
            }
        }
        
        
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        picsCollectionView.bottomRefreshControl = refreshControl
        
        self.navigationBarItems()
        
        fetchProfiles()
    }
    
    @objc func updateDetails(){
        paginationCount = 0
        fetchProfiles()
    }
    
    @objc func paginationAction(){
        refreshControl.endRefreshing()
        fetchProfiles()
    }
    
    @objc func sendReqButtonAction(){
        
        if selectedProfiles.count>0{
            let vc = CreateAuditionViewController()
            vc.projectName = projectName
            vc.profiles = selectedProfiles
            self.navigationController?.pushViewController(vc, animated: true)

        }else{
            Banner().displayValidationError(string: NSLocalizedString("Please select atleast one profile to proceed", comment: ""))
        }
            
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func fetchProfiles(){
        
        if lastPage == paginationCount{
            return
        }
        
        paginationCount += 1
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "page" : "\(paginationCount)",
            "category_id" : category_id ?? 0
        ]
        
//        if filtersDict != nil{
            filtersDict.addEntries(from: parameters)
//        }
        
        WebServices.postRequest(url: Url.categoryProfiles, params: filtersDict as! [String : Any], viewController:self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getProfileResponse = try decoder.decode(FeaturedProfiles.self, from: data)
                self.lastPage = getProfileResponse.data?.last_page
                if let profiles = getProfileResponse.data?.data{
                    if self.profiles.count == 0{
                        self.profiles.append(contentsOf: profiles)
                        
                        for i in 0..<profiles.count{
                            let profile = profiles[i]
                            if profile.is_favorite == 1{
                                self.favIdsArray.append(profile.id!)
                            }
                        }
                        if profiles.count>0{
                            self.picsCollectionView.isHidden = false
                            self.noProfilesLabel.isHidden = true
                        }else{
                            self.noProfilesLabel.isHidden = false
                        }
                        self.picsCollectionView.reloadData()

                        
                    }
                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    func navigationBarItems() {
        
        self.title = titleString
        
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
        
        
        
        let sortContainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        sortButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        sortButton.setImage(UIImage(named: "Grid"), for: .normal)
        sortButton.contentMode = UIView.ContentMode.scaleAspectFit
        sortButton.clipsToBounds = true
        sortContainView.addSubview(sortButton)
        sortButton.addTarget(self, action:#selector(self.sortAction), for: .touchUpInside)
        let sortBarButton = UIBarButtonItem(customView: sortContainView)
        sortButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);
        
        let filterContainView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let filterButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        filterButton.setImage(UIImage(named: "filter"), for: .normal)
        filterButton.contentMode = UIView.ContentMode.scaleAspectFit
        filterButton.clipsToBounds = true
        filterContainView.addSubview(filterButton)
        filterButton.addTarget(self, action:#selector(self.filterAction), for: .touchUpInside)
        filterButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);
        
        let filterBarButton = UIBarButtonItem(customView: filterContainView)
        self.navigationItem.rightBarButtonItems = [filterBarButton,sortBarButton]
        
        
        
    }
    
    @objc func filterAction(){
        let vc = ProfilesFilterViewController()
        vc.filterDelegate = self
        vc.category_id = self.category_id
        show(vc, sender: self)
                
    }
    
    
    @objc func sortAction(){
        
        isGrid = !isGrid
        
        if isGrid{
            layout.itemSize = CGSize(width: (self.view.frame.size.width/2)-20, height: 155)

            picsCollectionView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.view).offset(10)
                make.leading.trailing.bottom.equalTo(self.view).inset(12)
            }
            sortButton.setImage(UIImage(named: "Grid"), for: .normal)

        }else{
            layout.itemSize = CGSize(width: self.view.frame.size.width-10, height: 90)
            picsCollectionView.snp.remakeConstraints { (make) in
                make.top.equalTo(self.view).offset(10)
                make.leading.trailing.bottom.equalTo(self.view)
            }
            sortButton.setImage(UIImage(named: "options"), for: .normal)
        }
        
        picsCollectionView.reloadData()
        
    }
        
    
    @objc func popVC(){
        
        FilterOptions.shared.selectedCategoryId = nil
        FilterOptions.shared.subCategoriesArray = nil
        FilterOptions.shared.rating = nil
        FilterOptions.shared.countryId = nil
        FilterOptions.shared.countryName = nil
        FilterOptions.shared.cities = nil
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 15
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let profile = self.profiles[indexPath.row]
        var isHired : Bool!
        
            if let profileId = profile.id{
                if providerIds.contains(profileId){
                    print("already hired")
                    isHired = true
                }else{
                    print("not hired")
                    isHired = false
                }
            }
        
        if isGrid{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCellMini", for: indexPath) as! ProfilesCVMiniCell
            
            cell.alreadyHired.isHidden = !isHired
             
            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            
            let rating = profile.rating ?? "0"
            let jobs = profile.job_received ?? 0
            cell.ratingButton.setTitle(" \(rating) (\(jobs) \(NSLocalizedString("jobs", comment: "")))", for: .normal)
            cell.infoLabel.text = profile.title
            
            let mainCategory            = profile.main_category ?? ""
            cell.cateogoryLabel.text    = "\(mainCategory)"
            
            let chargesUnit = profile.charges_unit ?? ""
            let chargesString = profile.charges
            let chargesFloat = Float(chargesString ?? "0.00")
            let charges = Int(chargesFloat ?? 0)
            cell.priceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit)"

            
            if favIdsArray.contains(profile.id!){
                cell.favouriteButton.tag = 1
                cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite_red"), for: .normal)
            }else{
                cell.favouriteButton.tag = 0
                cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite"), for: .normal)
            }
            cell.favouriteButton.row = indexPath.item
            cell.favouriteButton.addTarget(self, action: #selector(self.favouriteAction), for: .touchUpInside)
            
            if auditionIndex.contains(indexPath.row){
                cell.bgView.layer.borderColor = Color.red.cgColor
                cell.bgView.layer.borderWidth = 1.0
            }else{
                cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
                cell.bgView.layer.borderWidth = 0.5
            }
            
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! ProfilesCVCell
            
            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            cell.alreadyHired.isHidden = !isHired
            
            let rating = profile.rating ?? "0"
            let jobs = profile.job_received ?? 0
            cell.ratingButton.setTitle(" \(rating) (\(jobs) jobs)", for: .normal)
            //            cell.infoLabel.text = profile.title
            
            let childCategory           = profile.child_category ?? ""
            let mainCategory           = profile.main_category ?? ""
            cell.category1Label.text    = "\(childCategory)"
            cell.categoryLabel.text    = "\(mainCategory)"
            

            let chargesUnit = profile.charges_unit ?? ""
            let chargesString = profile.charges
            let chargesFloat = Float(chargesString ?? "0.00")
            let charges = Int(chargesFloat ?? 0)
            cell.priceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit)"
            
            if favIdsArray.contains(profile.id!){
                cell.favouriteButton.tag = 1
                cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite_red"), for: .normal)
            }else{
                cell.favouriteButton.tag = 0
                cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite"), for: .normal)
            }
            cell.favouriteButton.row = indexPath.item
            cell.favouriteButton.addTarget(self, action: #selector(self.favouriteAction), for: .touchUpInside)

            
            if auditionIndex.contains(indexPath.row){
                cell.bgView.layer.borderColor = Color.red.cgColor
                cell.bgView.layer.borderWidth = 1.0
            }else{
                cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
                cell.bgView.layer.borderWidth = 0.5
            }
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("index path \(indexPath.row)")
        
        if isNotifyAudition{
            let profile = self.profiles[indexPath.row]

            if let profileId = profile.id{
                if providerIds.contains(profileId){
                    print("audition is already requested")
                }else{
                    
                    if auditionIndex.contains(indexPath.row){
                        auditionIndex.remove(at: auditionIndex.firstIndex(of: indexPath.row)!)
                        //selectedProfiles.remove(at: selectedProfiles.firstIndex(where: T##(FeaturedProfile) throws -> Bool))
                        
                        if let index = selectedProfiles.firstIndex(where: { child in child.id == profile.id }){
                            selectedProfiles.remove(at: index)
                        }
                        
                    }else{
                        auditionIndex.append(indexPath.row)
                        selectedProfiles.append(profile)
                    }
                    picsCollectionView.reloadData()
                }
            }
        }
        else{
            
            let profile = self.profiles[indexPath.row]
            if let profileId = profile.id{
                if providerIds.contains(profileId){
                    print("provider is already hired")
                }else{
                    //Saving providerid in shared class for create contract
                    CreateContract.shared.provider_id = profile.provider_id
                    CreateContract.shared.provider_profile_id = profile.id
                    
                    let vc = ProfileDetailsViewController()
                    vc.profileId = profile.id
                    vc.skipProjects = skipProjects
                    vc.completionHander = { value in
                        if value == 0{
                            if self.favIdsArray.count > 0{
                                for i in 0..<self.favIdsArray.count{
                                    let id = self.favIdsArray[i]
                                    if id == profile.id{
                                        self.favIdsArray.remove(at: i)
                                        break
                                    }
                                }
                            }
                        }else{
                            self.favIdsArray.append(profile.id ?? 0)
                        }
                        
                        DispatchQueue.main.async {
                            self.picsCollectionView.reloadData()
                        }
                    }
                    vc.view.backgroundColor = .white
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            
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
                            self.picsCollectionView.reloadData()
                            NotificationCenter.default.post(name: Notification.dashboard, object: nil)
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
                            self.picsCollectionView.reloadData()
                            NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                        }
                    }
                }
            }
        }
    }
}

extension CateogryProfilesViewController : FilterDelegate{
    
    func applyFilters(filters: NSMutableDictionary) {
        
        if let name = filters.value(forKey: "category_Name"){
            self.title = name as? String
        }
        if let catId = filters.value(forKey: "category_id") as? Int{
            self.category_id = catId
        }
        self.filtersDict = filters
        paginationCount = 0
        self.profiles.removeAll()
        fetchProfiles()

    }
    
}
