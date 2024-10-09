//
//  CategoryViewController.swift
//  Crew
//
//  Created by Rajeev on 22/02/21.
//

import UIKit

class CategoryViewController: UIViewController, UICollectionViewDelegate , UICollectionViewDataSource {
    
    private var categoriessCollectionView : UICollectionView!
    var categories = [Category]()
    var isFromProjects = false
    var providers : [ResourcesData]!
    var isNotifyAudition = false
    var projectName : String!
    var audtions : [Audtions]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        hidesBottomBarWhenPushed = true
        self.view.backgroundColor = .white
        
        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.itemSize = CGSize(width: self.view.frame.size.width/5, height: (self.view.frame.size.width/5)+5)
        categoriessCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout1)
        categoriessCollectionView.dataSource = self
        categoriessCollectionView.delegate = self
//        layout1.minimumLineSpacing = 0
//        layout1.minimumInteritemSpacing = 0
        categoriessCollectionView.register(CategoriesCVCell.self, forCellWithReuseIdentifier: "CategoriesCVCell")
        categoriessCollectionView.backgroundColor = UIColor.clear
        self.view.addSubview(categoriessCollectionView)
        
        categoriessCollectionView.snp.makeConstraints { (make) in
            make.top.leading.trailing.bottom.equalTo(self.view).inset(15)
        }
        
        if !isFromProjects {
            let categoriesLabel = UILabel()
            categoriesLabel.text = NSLocalizedString("Categories", comment: "")
            categoriesLabel.font = UIFont(name: "AvenirLTStd-Black", size: 18)
            self.view.addSubview(categoriesLabel)
            categoriesLabel.snp.makeConstraints { (make) in
                make.top.equalTo(self.view).offset(55)
                make.leading.equalTo(self.view).offset(15)
            }
            
            let notificationImage = UIImage(named: "notification")//?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
            
            let notificationsButton = UIButton()
            notificationsButton.setImage(notificationImage, for: .normal)
            notificationsButton.addTarget(self, action: #selector(self.notificationsAction), for: .touchUpInside)
            self.view.addSubview(notificationsButton)
            
            notificationsButton.snp.makeConstraints { (make) in
                make.trailing.equalTo(self.view).offset(-15)
                make.centerY.equalTo(categoriesLabel)
                make.width.height.equalTo(40)
            }
            categoriessCollectionView.snp.remakeConstraints { (make) in
                make.top.equalTo(categoriesLabel.snp.bottom).offset(15)
                make.leading.trailing.bottom.equalTo(self.view).inset(15)
            }
        }

        
    
        
        if let cats = Categories.shared.list{
            self.categories = cats
            categoriessCollectionView.reloadData()
        }
        
        
        if isFromProjects {
            self.navigationBarItems()
        }
    }
    
    func navigationBarItems() {
        self.title = NSLocalizedString("Categories", comment: "")

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
        
        
        
        
        let notificationImage = UIImage(named: "notification")
            //.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
        
        let containView1 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let notificationButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        notificationButton.setImage(notificationImage, for: .normal)
        notificationButton.contentMode = UIView.ContentMode.scaleAspectFit
        notificationButton.clipsToBounds = true
        containView1.addSubview(notificationButton)
        notificationButton.addTarget(self, action:#selector(self.notificationsAction), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: containView1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        

    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func notificationsAction(){
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
        
//        self.tabBarController?.tabBar.isHidden = true
//        let vc = NotificationsViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    

    func checkUserVerification(){
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ReviewPopupVC = storyboard.instantiateViewController(withIdentifier: "ReviewPopupVC") as! ReviewPopupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        
        if !isFromProjects {
            self.navigationController?.navigationBar.isHidden = true
        }
        
        if let cats = Categories.shared.list{
            self.categories = cats
            categoriessCollectionView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFromProjects{
            self.tabBarController?.tabBar.isHidden = true
        }else{
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if isFromProjects{
            self.navigationController?.navigationBar.isHidden = false
        }
        else{
            self.navigationController?.navigationBar.isHidden = true
        }
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 15
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVCell", for: indexPath) as! CategoriesCVCell
        
        let category =  categories[indexPath.row]
        let categoryUrl = Url.categories + category.image
        cell.imageview.sd_setImage(with: URL(string: categoryUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        cell.titleLabel.text = category.name
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tabBarController?.tabBar.isHidden = true
        let category =  categories[indexPath.row]
        let vc = CateogryProfilesViewController()
        vc.category_id = category.id
        if isFromProjects{
            vc.skipProjects = true
        }
        vc.titleString = category.name
        vc.providers = providers
        vc.isNotifyAudition = isNotifyAudition
        vc.projectName = projectName
        vc.audtions = self.audtions
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
}
