//
//  SearchFilterViewController.swift
//  Crew
//
//  Created by Rajeev on 20/04/21.
//

import UIKit

class SearchFilterViewController: UIViewController, UISearchBarDelegate {
    
    var category : Category!
    lazy var searchBar:UISearchBar = UISearchBar()
    var categoriessCollectionView : UICollectionView!
    var selectedIndex : Int!
    var paginationCount = 0
    var lastPage : Int!
    var profiles = [FeaturedProfile]()
    var filteredProfiles = [FeaturedProfile]()
    var picsCollectionView : UICollectionView!
    var query = ""
    var refreshControl : UIRefreshControl!
    var favIdsArray = [Int]()
    var isSearch = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        navigationBarItems()
        
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.searchTextField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        searchBar.searchTextField.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        searchBar.frame = CGRect(x: 10, y: 44, width: self.view.frame.size.width-50, height: 44)
        searchBar.placeholder = NSLocalizedString(" What are you looking for?", comment: "")
        searchBar.sizeToFit()
        searchBar.returnKeyType = .done
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        
        
        
        let categoriesLabel = UILabel()
        categoriesLabel.text = NSLocalizedString("Category", comment: "")
        categoriesLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.view.addSubview(categoriesLabel)

        categoriesLabel.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().offset(10)
            make.height.equalTo(25)
        }
            
        
        let categoryLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        categoryLayout.itemSize = CGSize(width: 100, height: 45)
        categoriessCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: categoryLayout)
        categoriessCollectionView.dataSource = self
        categoriessCollectionView.delegate = self
        categoriessCollectionView.tag = 2
        categoryLayout.minimumLineSpacing = 10
        categoryLayout.minimumInteritemSpacing = 10
        categoriessCollectionView.register(CatCVCell.self, forCellWithReuseIdentifier: "catCVCell")
        categoriessCollectionView.showsHorizontalScrollIndicator = false
        categoriessCollectionView.backgroundColor = UIColor.clear
        categoryLayout.scrollDirection = .horizontal
        self.view.addSubview(categoriessCollectionView)
        
        categoriessCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(45)
            make.top.equalTo(categoriesLabel.snp.bottom).offset(05)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.top.equalTo(categoriessCollectionView.snp.bottom).offset(07)
        }
        
        
        self.view.backgroundColor = .white
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.size.width-10, height: 90)
        picsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picsCollectionView.dataSource = self
        picsCollectionView.delegate = self
        picsCollectionView.tag = 1
        picsCollectionView.showsVerticalScrollIndicator = false
        picsCollectionView.register(ProfilesCVCell.self, forCellWithReuseIdentifier: "CVCell")
        
        picsCollectionView.showsHorizontalScrollIndicator = false
        picsCollectionView.backgroundColor = UIColor.clear
        layout.scrollDirection = .vertical
        self.view.addSubview(picsCollectionView)
        
        picsCollectionView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView).offset(10)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        picsCollectionView.bottomRefreshControl = refreshControl
        
        
        fetchProfiles()
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
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
            "page" : "\(paginationCount)",
            "category_id" : category.id ?? 0,
            "query" : query
        ]
        
//        if filtersDict != nil{
//        }
        
        WebServices.postRequest(url: Url.categoryProfiles, params: parameters, viewController:self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getProfileResponse = try decoder.decode(FeaturedProfiles.self, from: data)
                self.lastPage = getProfileResponse.data?.last_page
                if let profiles = getProfileResponse.data?.data{
                    self.profiles = profiles//.append(contentsOf: profiles)
                    
                    for i in 0..<profiles.count{
                        let profile = profiles[i]
                        if profile.is_favorite == 1{
                            self.favIdsArray.append(profile.id!)
                        }
                    }
                    self.picsCollectionView.reloadData()
                }
                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
    }
    
    
    func navigationBarItems() {
        
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
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Search delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        if let searchText = searchBar.text{
            paginationCount = 0
            query = searchText
            favIdsArray.removeAll()
            fetchProfiles()
            
        }
    }
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.searchTextField.endEditing(true)
    }
}

extension SearchFilterViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        if collectionView.tag == 2{
            return 15
        }
        return 08
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 2{
            return Categories.shared.list?.count ?? 0
        }
        return profiles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 2{
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catCVCell", for: indexPath) as! CatCVCell
        
        cell.nameLabel.text = Categories.shared.list?[indexPath.row].name
        cell.bgView.layer.borderColor = Color.liteGray.cgColor
            cell.bgView.layer.borderWidth = 1.0
        cell.nameLabel.textColor = Color.liteBlack
        
//        cell.bgView.layer.borderColor = Color.liteGray.cgColor
//        cell.bgView.layer.borderWidth = 1.0
        
        if selectedIndex != nil{
            if indexPath.row == selectedIndex{
                cell.bgView.layer.borderColor = UIColor.black.cgColor
                cell.bgView.layer.borderWidth = 0.5
            }
        }
        
        return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! ProfilesCVCell
            let profile = self.profiles[indexPath.row]

            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            cell.alreadyHired.isHidden = true
            
            let rating = profile.rating ?? "0"
            let jobs = profile.job_rewarded ?? 0
            cell.ratingButton.setTitle(" \(rating) (\(jobs) \(NSLocalizedString("jobs", comment: ""))", for: .normal)
            //            cell.infoLabel.text = profile.title
            
            let childCategory           = profile.child_category ?? ""
            let mainCategory           = profile.main_category ?? ""
            cell.category1Label.text    = "\(childCategory)"
            cell.categoryLabel.text    = "\(mainCategory)"
            
//            let charges         = profile.charges ?? ""
//            let chargesUnit     = profile.charges_unit ?? ""
//
//            cell.priceLabel.text = "SAR \(charges)/\(chargesUnit)"
            
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

            
            cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
            cell.bgView.layer.borderWidth = 0.5
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView.tag == 2{
            selectedIndex = indexPath.row
            category = Categories.shared.list?[indexPath.row]
            categoriessCollectionView.reloadData()
            paginationCount = 0
            self.profiles.removeAll()
            fetchProfiles()
        }else{
            
            let profile = profiles[indexPath.row]
            
            //Saving providerid in shared class for create contract
            CreateContract.shared.provider_id = profile.provider_id
            CreateContract.shared.provider_profile_id = profile.id
            let vc = ProfileDetailsViewController()
            vc.profileId = profile.id
            vc.view.backgroundColor = .white
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

class CatCVCell : UICollectionViewCell{
    
    var bgView : UIView!
    var nameLabel : UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUI()
    }
    
    
    private func loadUI(){
        
        bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        }
        
        bgView.layer.cornerRadius = 5.0
        bgView.clipsToBounds = true
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 2.0
        
        bgView.layer.shadowColor = UIColor.darkGray.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 6
        
        
        
        nameLabel = UILabel()
        nameLabel.center = bgView.center
        nameLabel.textAlignment = .center
        nameLabel.textColor = .darkGray
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        bgView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(bgView)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
