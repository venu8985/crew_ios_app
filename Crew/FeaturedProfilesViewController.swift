//
//  FeaturedProfilesViewController.swift
//  Crew
//
//  Created by Rajeev on 24/02/21.
//

import UIKit

class FeaturedProfilesViewController: UIViewController {
    
    var isGrid = true
    var picsCollectionView : UICollectionView!
    var layout : UICollectionViewFlowLayout!
    var profiles = [FeaturedProfile]()
    var paginationCount = 0
    var lastPage : Int!
    var paramsDict = NSMutableDictionary()
    var sortButton : UIButton!
    var refreshControl : UIRefreshControl!
    var favIdsArray = [Int]()
    var noProfilesLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateDetails), name: Notification.dashboard, object: nil)

        layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.frame.size.width/2)-20, height: 155)
        picsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picsCollectionView.dataSource = self
        picsCollectionView.delegate = self
        picsCollectionView.tag = 1
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
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
        
        
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        picsCollectionView.bottomRefreshControl = refreshControl
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
            "page" : "\(paginationCount)"
        ]
        paramsDict.addEntries(from: parameters)

        WebServices.postRequest(url: Url.featuredProfiles, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getProfileResponse = try decoder.decode(FeaturedProfiles.self, from: data)
                self.lastPage = getProfileResponse.data?.last_page
                
                if self.paginationCount == 1{
                    self.profiles = []
                    self.favIdsArray = []
                }
                
                if let profiles = getProfileResponse.data?.data{
                    self.profiles.append(contentsOf: profiles)
                    
                    for i in 0..<profiles.count{
                        let profile = profiles[i]
                        if profile.is_favorite == 1{
                            self.favIdsArray.append(profile.id!)
                        }
                    }
                    
                    self.noProfilesLabel.isHidden = profiles.count == 0 ? false:true
                    self.picsCollectionView.isHidden = profiles.count == 0 ? true:false
                    
                    
                    DispatchQueue.main.async {
                        self.picsCollectionView.reloadData()
                    }

                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Featured Profiles", comment: "")
        
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
        self.navigationItem.rightBarButtonItem = sortBarButton
        
        
    }
    
    @objc func filterAction(){
        
        let vc = ProfilesFilterViewController()
        vc.filterDelegate = self        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.isHidden = false
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
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension FeaturedProfilesViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,
                                           UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 08
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let profile = self.profiles[indexPath.row]
        
        if isGrid{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCellMini", for: indexPath) as! ProfilesCVMiniCell
            cell.alreadyHired.isHidden = true
            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            
            let rating = profile.rating ?? "0"
            let jobs = profile.job_received ?? 0
            cell.ratingButton.setTitle(" \(rating) (\(jobs) \(NSLocalizedString("jobs", comment: "")))", for: .normal)
            cell.infoLabel.text = profile.title
            
//            let mainCategory            = profile.main_category ?? ""
            let childCategory           = profile.child_category ?? ""
            cell.cateogoryLabel.text    = "\(childCategory)"

            let chargesUnit = profile.charges_unit ?? ""
            let chargesString = profile.charges ?? "0"
            let chargesFloat = Float(chargesString)
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

            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! ProfilesCVCell
            cell.alreadyHired.isHidden = true
            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            
            let rating = profile.rating ?? "0"
            let jobs = profile.job_received ?? 0
            cell.ratingButton.setTitle(" \(rating) (\(jobs) \(NSLocalizedString("jobs", comment: "")))", for: .normal)
//            cell.infoLabel.text = profile.title
            
            let childCategory           = profile.child_category ?? ""
            let mainCategory           = profile.main_category ?? ""
            cell.category1Label.text    = "\(childCategory)"
            cell.categoryLabel.text    = "\(mainCategory)"
            
            let chargesUnit = profile.charges_unit ?? ""
            let chargesString = profile.charges ?? "0"
            let chargesFloat = Float(chargesString)
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

            
            return cell
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let profile = profiles[indexPath.row]
        
        //Saving providerid in shared class for create contract
        CreateContract.shared.provider_id = profile.provider_id
        CreateContract.shared.provider_profile_id = profile.id
        let vc = ProfileDetailsViewController()
        vc.profileId = profile.id
        vc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
        
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
                            print("removed profile")
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
                            print("added profile")
                            self.picsCollectionView.reloadData()
                            NotificationCenter.default.post(name: Notification.dashboard, object: nil)

                        }
                    }
                }
            }
        }
        
    }
    
    
}


class ProfilesCVMiniCell : UICollectionViewCell{
    
    var bgView            : UIView!
    var imageView         : UIImageView!
    var infoLabel         : UILabel!
    var nameLabel         : UILabel!
    var priceLabel        : UILabel!
    var favouriteButton   : FavButton!
    var ratingButton      : UIButton!
    var cateogoryLabel    : UILabel!
    var alreadyHired      : UIImageView!
    
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
        
        
        imageView = UIImageView()
        bgView.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.width.height.equalTo(60)
            make.top.equalTo(10)
        }
        
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        
        let ratingImage = UIImage(named: "rating")
            //.sd_resizedImage(with: CGSize(width: 09, height: 09), scaleMode: .aspectFit)

//        let ratingImage = UIImage(named: "rating")
        ratingButton = UIButton()
        ratingButton.setImage(ratingImage, for: .normal)
        ratingButton.setTitleColor(.black, for: .normal)
        ratingButton.titleLabel?.font = UIFont.systemFont(ofSize: 08)
        ratingButton.imageView?.contentMode = .center
        ratingButton.isUserInteractionEnabled = false
        bgView.addSubview(ratingButton)
        
        ratingButton.clipsToBounds = true
        ratingButton.contentHorizontalAlignment = .fill
        ratingButton.contentVerticalAlignment = .fill
        ratingButton.imageView?.contentMode = .scaleAspectFit
        ratingButton.contentHorizontalAlignment = .center
        
        ratingButton.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(02)
            make.trailing.leading.equalTo(bgView).inset(05)
            make.height.equalTo(20)
        }
        
        cateogoryLabel = UILabel()
        cateogoryLabel.sizeToFit()
        cateogoryLabel.font = UIFont.systemFont(ofSize: 08.0)
        cateogoryLabel.textColor = .red
        cateogoryLabel.numberOfLines = 0
        cateogoryLabel.textAlignment = .center
        bgView.addSubview(cateogoryLabel)
        
        cateogoryLabel.snp.makeConstraints { (make) in
            make.top.equalTo(ratingButton.snp.bottom)
            make.trailing.leading.equalTo(bgView).inset(05)
        }
        
//        infoLabel = UILabel()
//        infoLabel.text = "asdfasdf"
//        infoLabel.backgroundColor = .systemBlue
//        infoLabel.font = UIFont.systemFont(ofSize: 12)
//        infoLabel.textAlignment = .center
//        bgView.addSubview(infoLabel)
//
//        infoLabel.snp.makeConstraints { (make) in
//            make.top.equalTo(cateogoryLabel.snp.bottom).offset(03)
//            make.trailing.leading.equalTo(bgView).inset(05)
//        }
//
        
        infoLabel = UILabel()
        infoLabel.font = UIFont(name: "Avenir Heavy", size: 12)
        infoLabel.textAlignment = .center
        bgView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cateogoryLabel.snp.bottom).offset(03)
            make.trailing.leading.equalTo(bgView).inset(05)
        }
        
        
        nameLabel = UILabel()
        nameLabel.textColor = UIColor.gray
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        nameLabel.textAlignment = .center
        bgView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom)
            make.trailing.leading.equalTo(bgView).inset(05)
        }
        
        
        
        priceLabel = UILabel()
        priceLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        priceLabel.textAlignment = .center
        bgView.addSubview(priceLabel)
        
        priceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(03)
            make.trailing.leading.equalTo(bgView).inset(05)
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
            make.top.equalTo(bgView.snp.top).inset(10)
            make.width.height.equalTo(15)
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



protocol FilterDelegate {
    func applyFilters(filters : NSMutableDictionary)
}

extension FeaturedProfilesViewController : FilterDelegate{
    
    func applyFilters(filters : NSMutableDictionary){
        
        paginationCount = 0
        paramsDict = filters
        self.profiles.removeAll()
        fetchProfiles()

    }
}

class FavButton : UIButton {
    var row : Int?
}
