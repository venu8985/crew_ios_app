//
//  ShootingPlanViewController.swift
//  Crew
//
//  Created by Rajeev on 07/04/21.
//

import UIKit

class ShootingPlanViewController: UIViewController {
    var providers : [ResourcesData]!
    var projectName : String!
    //Empty list UI
    var createPlanButton : UIButton!
    var infoLabel : UILabel!
    var titleLabel : UILabel!
    var imageView : UIImageView!
    
    //List UI
    var tableView : UITableView!
    var createButton : UIButton!
    
    var shootingPlans = [ShootingPlan]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationBarItems()
        
        createPlanButton = UIButton()
        createPlanButton.setTitle(NSLocalizedString("Create plan", comment: ""), for: .normal)
        createPlanButton.backgroundColor = Color.red
        createPlanButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        createPlanButton.addTarget(self, action: #selector(self.createPlanButtonAction), for: .touchUpInside)
        self.view.addSubview(createPlanButton)
        
        createPlanButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.center.equalTo(self.view)
        }
        createPlanButton.layer.cornerRadius = 5.0
        createPlanButton.clipsToBounds = true
        
        infoLabel = UILabel()
        infoLabel.text = NSLocalizedString("Please create the shooting plan", comment: "")
        infoLabel.textAlignment = .center
        infoLabel.textColor = Color.gray
        infoLabel.font = UIFont(name: "AvenirLTStd-Light", size: 12)
        self.view.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(createPlanButton.snp.top).offset(-25)
        }
        
        titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("No shooting plan created yet", comment: "")
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "AvenirLTStd-Black", size: 20)
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(infoLabel.snp.top).offset(-15)
        }
        
        imageView = UIImageView()
        imageView.image = UIImage(named: "no-shooting_plan")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.bottom.equalTo(titleLabel.snp.top).offset(-20)
            make.centerX.equalToSuperview()
        }
        createPlanButton.isHidden = true
        infoLabel.isHidden = true
        titleLabel.isHidden = true
        imageView.isHidden = true
        
        
        tableView = UITableView()
//        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(ShootingTVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        tableView.isHidden = true
        self.fetchShootingPlans()
    }
    
    func fetchShootingPlans(){
          
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "project_id" : CreateContract.shared.project_id ?? "",
        ]
        
        WebServices.postRequest(url: Url.shootingPlans, params: parameters, viewController: self) { success,data  in
            if success{
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(ShootingPlans.self, from: data)
                    
                    if response.data.count>0{
                        self.shootingPlans = response.data
                        self.tableView.reloadData()
                        self.tableView.isHidden = false
                        self.createButton.isHidden = false

                    }else{
                        self.createPlanButton.isHidden = false
                        self.infoLabel.isHidden = false
                        self.titleLabel.isHidden = false
                        self.imageView.isHidden = false
                        self.createButton.isHidden = true
                    }
                    print("create shooting plan response")
                    
                }
                catch let error {
                    print("error \(error.localizedDescription)")
                }
            }else{
                Banner().displayValidationError(string: "Error")
            }
        }
    }
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Shooting Plan", comment: "")
        
        //Back button
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
        
        
        //Create new button
        let containView1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        createButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        createButton.setTitle(NSLocalizedString("Create New", comment: ""), for: .normal)
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        createButton.setTitleColor(Color.red, for: .normal)
        createButton.contentMode = UIView.ContentMode.scaleAspectFit
        createButton.clipsToBounds = true
        createButton.contentHorizontalAlignment = .trailing
        containView1.addSubview(createButton)
        createButton.addTarget(self, action:#selector(self.createPlanButtonAction), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: containView1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        createButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        createButton.isHidden = true

        
    }

    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    @objc func createPlanButtonAction(){
        
        let vc = CreateShootingPlanViewController()
        vc.providers = providers
        vc.delegate = self
        vc.projectName = projectName
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

//MARK : Providers pop up
protocol ResourcesDelegate {
    func openProviders(projectIndex : Int)
}
extension ShootingPlanViewController : ResourcesDelegate{

    func openProviders(projectIndex : Int){
        
        let shootingPlan = shootingPlans[projectIndex]
        let vc = ProvidersViewController()
        vc.modalPresentationStyle = .custom
        vc.titleString = NSLocalizedString("   Resources", comment: "")
        vc.resources = shootingPlan.resources
        self.present(vc, animated: true, completion: nil)
        
    }
}

extension ShootingPlanViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 185
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shootingPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ShootingTVCell
        cell.selectionStyle = .none
        let shootingPlan = shootingPlans[indexPath.row]
        
        cell.shootingDateTextfield.text = shootingPlan.shooting_date
        cell.locationTextfield.text = shootingPlan.location
        
        cell.delegate = self
        cell.providers = shootingPlan.resources
        cell.picsCollectionView.tag = indexPath.row
        cell.picsCollectionView.reloadData()
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(self.editButtonAction), for: .touchUpInside)
        
        return cell
    }
    
    
    @objc func editButtonAction(sender: UIButton){
        
        let shootingPlan = shootingPlans[sender.tag]
        let vc = CreateShootingPlanViewController()
        vc.providers = providers
        vc.shootingPlan = shootingPlan
        vc.delegate = self
        vc.projectName = projectName
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
}


class ShootingTVCell : UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{

    var shootingDateTextfield : FloatingTextfield!
    var locationTextfield     : FloatingTextfield!
    var bgView                : UIView!
    var providers             : [ShootingResource]!
    var picsCollectionView    : UICollectionView!
    var delegate              : ResourcesDelegate!
    var editButton            : UIButton!
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        editButton = UIButton()
        let editImage = UIImage(named: "edit")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        editButton.setImage(editImage, for: .normal)
        self.contentView.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.trailing.top.equalTo(self.contentView).inset(10)
            make.width.height.equalTo(40)
        }
        
        
        shootingDateTextfield = FloatingTextfield()
        shootingDateTextfield.autocapitalizationType = .none
        shootingDateTextfield.placeholder = NSLocalizedString("Shooting Date", comment: "")
        shootingDateTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        shootingDateTextfield.titleFont = UIFont(name: "AvenirLTStd-Book", size: 14)!
        self.contentView.addSubview(shootingDateTextfield)
        
        shootingDateTextfield.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).inset(25)
            make.trailing.equalTo(editButton.snp.leading).inset(10)
            make.top.equalTo(self.contentView).offset(10)
            make.width.equalTo((self.contentView.frame.size.width-15)/2)
            make.height.equalTo(45)
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            
//            shootingDateTextfield.titleLabel.textAlignment = .right
//            shootingDateTextfield.textAlignment = .right
            
            shootingDateTextfield.rightViewMode = UITextField.ViewMode.always
            shootingDateTextfield.layer.borderWidth = 0
            
            let calimageView = UIImageView()
            calimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            calimageView.image = UIImage(named: "date")
            calimageView.contentMode = .scaleAspectFit
            let calleftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            calleftView.addSubview(calimageView)
            shootingDateTextfield.rightView = calleftView
            
        }else{
//            shootingDateTextfield.titleLabel.textAlignment = .left
//            shootingDateTextfield.textAlignment = .left
            
            shootingDateTextfield.leftViewMode = UITextField.ViewMode.always
            shootingDateTextfield.layer.borderWidth = 0
            
            let calimageView = UIImageView()
            calimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            calimageView.image = UIImage(named: "date")
            calimageView.contentMode = .scaleAspectFit
            let calleftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            calleftView.addSubview(calimageView)
            shootingDateTextfield.leftView = calleftView
            
        }
        
        locationTextfield = FloatingTextfield()
        locationTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 14)
        locationTextfield.titleFont = UIFont(name: "AvenirLTStd-Book", size: 14)!
        locationTextfield.textColor = Color.liteBlack
        locationTextfield.placeholder = NSLocalizedString("Location", comment: "")
        self.contentView.addSubview(locationTextfield)
        
        locationTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.contentView).inset(25)
            make.top.equalTo(shootingDateTextfield.snp.bottom).offset(10)
            make.width.equalTo((self.contentView.frame.size.width-15)/2)
            make.height.equalTo(45)
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            
//            locationTextfield.textAlignment = .right
//            locationTextfield.titleLabel.textAlignment = .right
            
            locationTextfield.rightViewMode = UITextField.ViewMode.always
            
            let locimageView = UIImageView()
            locimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            locimageView.image = UIImage(named: "location_1")
            locimageView.contentMode = .scaleAspectFit
            let locLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            locLeftView.addSubview(locimageView)
            locationTextfield.rightView = locLeftView
            locationTextfield.layer.borderWidth = 0
        }else{
            
//            locationTextfield.textAlignment = .left
//            locationTextfield.titleLabel.textAlignment = .left
            
            locationTextfield.leftViewMode = UITextField.ViewMode.always
            
            let locimageView = UIImageView()
            locimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            locimageView.image = UIImage(named: "location_1")
            locimageView.contentMode = .scaleAspectFit
            let locLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
            locLeftView.addSubview(locimageView)
            locationTextfield.leftView = locLeftView
            locationTextfield.layer.borderWidth = 0
        }
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.contentView).inset(25)
            make.top.equalTo(locationTextfield.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        picsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picsCollectionView.dataSource = self
        picsCollectionView.delegate = self
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        picsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        picsCollectionView.showsHorizontalScrollIndicator = false
        picsCollectionView.backgroundColor = UIColor.clear
        layout.scrollDirection = .horizontal
        self.contentView.addSubview(picsCollectionView)

        picsCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(locationTextfield)
            make.height.equalTo(40)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }
        
        

        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().inset(5)
        }
        
        bgView.layer.borderWidth = 1.0
        bgView.layer.cornerRadius = 10.0
        bgView.layer.borderColor = Color.liteGray.cgColor
        self.contentView.sendSubviewToBack(bgView)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: collectionview datasource and delegates
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 08
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if providers.count>3{
            return 3
        }
        return providers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                
        let imageUrl = Url.providers + (providers[indexPath.row].profile_image ?? "")

        let imageView = UIImageView()
        if indexPath.row != 2{
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        }else{
            imageView.backgroundColor = Color.red.withAlphaComponent(0.25)
        }
        cell.addSubview(imageView)

        imageView.backgroundColor = Color.red.withAlphaComponent(0.25)
        imageView.frame = cell.bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20

        let countLabel = UILabel()
        countLabel.frame = imageView.bounds
        if indexPath.row == 2{
            countLabel.text = "+\(providers.count-2)"
        }
        countLabel.font = UIFont(name: "AvenirLTStd-Book", size: 16)
        countLabel.textColor = .red
        imageView.addSubview(countLabel)
        countLabel.textAlignment = .center
            
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(" index \(indexPath.row)")
        if indexPath.row == 2{
            delegate.openProviders(projectIndex: collectionView.tag)
        }
    }
  

}

protocol ShootingPlanDelegate {
    func newPlanCreated()
}
extension ShootingPlanViewController : ShootingPlanDelegate{
    func newPlanCreated(){
        fetchShootingPlans()
    }
}
