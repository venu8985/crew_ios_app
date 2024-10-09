//
//  FavouriteViewController.swift
//  Crew
//
//  Created by Rajeev on 11/04/21.
//

import UIKit

class FavouriteViewController: UIViewController {

    var paginationCount = 0
    var lastPage : Int!
    var tableView : UITableView!
    var profiles = [FavouriteProfile]()
    
    var picsCollectionView : UICollectionView!
    var layout : UICollectionViewFlowLayout!
    var isGrid = true
    var sortButton : UIButton!
    var refreshControl : UIRefreshControl!
    var noProfilesLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarItems()
        fetchProfiles()
        self.view.backgroundColor = .white
        
        
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
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.bottom.equalTo(self.view).inset(12)
        }
        
        
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        picsCollectionView.bottomRefreshControl = refreshControl
        
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
        
        WebServices.postRequest(url: Url.favouriteProfiles, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getProfileResponse = try decoder.decode(FavouriteProfiles.self, from: data)
                self.lastPage = getProfileResponse.data?.last_page
                if let profiles = getProfileResponse.data?.data{
                    self.profiles.append(contentsOf: profiles)
                    
                    if self.profiles.count>0{
                        self.noProfilesLabel.isHidden = true
                        self.picsCollectionView.isHidden = false
                    }else{
                        self.noProfilesLabel.isHidden = false
                    }
                    self.picsCollectionView.reloadData()
                    
                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }

    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Favourite Profiles", comment: "")
        
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
            
        
        noProfilesLabel = UILabel()
        noProfilesLabel.text = NSLocalizedString("No profiles found", comment: "")
        noProfilesLabel.textAlignment = .center
        noProfilesLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.view.addSubview(noProfilesLabel)
        noProfilesLabel.isHidden = true
        noProfilesLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }

}

extension FavouriteViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
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
            
            let rating = profile.rating
            cell.ratingButton.setTitle(" \(rating ?? "") ", for: .normal)
            cell.infoLabel.text = profile.name
            
//            let mainCategory            = profile.main_category
            let childCategory           = profile.child_category
            cell.cateogoryLabel.text    = "\(childCategory ?? "")"
            
//            let charges         = profile.charges
//            let chargesUnit     = profile.charges_unit
//            cell.priceLabel.text = "SAR \(charges)/\(chargesUnit)"
            
            let chargesUnit = profile.charges_unit
            let chargesString = profile.charges ?? "0"
            let chargesFloat = Float(chargesString )
            let charges = Int(chargesFloat ?? 0)
            cell.priceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit ?? "")"
            
            
            cell.favouriteButton.tag = indexPath.item
            cell.favouriteButton.addTarget(self, action: #selector(self.favouriteAction), for: .touchUpInside)
            cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite_red"), for: .normal)
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! ProfilesCVCell
            cell.alreadyHired.isHidden = true
            let profileUrl = Url.providers + (profile.profile_image ?? "")
            cell.imageView.sd_setImage(with: URL(string: profileUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = profile.name
            
            let rating = profile.rating
            cell.ratingButton.setTitle(" \(rating ?? "")         ", for: .normal)
            
            let childCategory           = profile.child_category
            let mainCategory           = profile.main_category
            cell.category1Label.text    = "\(childCategory ?? "")"
            cell.categoryLabel.text    = "\(mainCategory ?? "")"
            
            let chargesUnit = profile.charges_unit
            let chargesString = profile.charges
            let chargesFloat = Float(chargesString ?? "0")
            let charges = Int(chargesFloat ?? 0)
            cell.priceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit ?? "")"
            
            cell.favouriteButton.tag = indexPath.item
            cell.favouriteButton.addTarget(self, action: #selector(self.favouriteAction), for: .touchUpInside)
            cell.favouriteButton.setBackgroundImage(UIImage(named: "favourite_red"), for: .normal)
            
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
    
    @objc func favouriteAction(sender : UIButton){
        
        let provider_id = profiles[sender.tag].provider_id
        let provider_profile_id = profiles[sender.tag].id
        
        AddorRemoveFavourite.removeProfileFromFavourites(provider_id: provider_id!, provider_profile_id: provider_profile_id!, vc: self) { (success) in
            
            if success{
                self.paginationCount = 0
                self.profiles.removeAll()
                self.fetchProfiles()
            }
            
        }
    }
        
    
}



