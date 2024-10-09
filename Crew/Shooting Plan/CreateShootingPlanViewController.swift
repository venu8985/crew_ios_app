//
//  CreateShootingPlanViewController.swift
//  Crew
//
//  Created by Rajeev on 07/04/21.
//

import UIKit
import DatePickerDialog
import SkyFloatingLabelTextField

class CreateShootingPlanViewController: UIViewController {
    var providers : [ResourcesData]!
    var selectedProviders = [ResourcesData]()
    var shootingPlan : ShootingPlan!
    var projectName : String!
    var tableView : UITableView!
    var address = ""
    var date = ""
    var latitude = ""
    var longitude = ""
    var delegate : ShootingPlanDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        navigationBarItems()
        
        if shootingPlan != nil{
            
            address = shootingPlan.location ?? ""
            longitude = String(shootingPlan.longitude ?? 0.00)
            latitude = String(shootingPlan.latitude ?? 0.00)
            date = shootingPlan.shooting_date ?? ""
            // updating resources
            for source in shootingPlan.resources{
                let resource = ResourcesData(id: source.id ?? 0,
                                             name: source.name ?? "",
                                             profile_image: source.profile_image ?? "",
                                             main_category: source.main_category ?? "",
                                             child_category: source.child_category ?? "",
                                             total_amount: "",
                                             status: "")
                selectedProviders.append(resource)
            }
            
        }
        
        let createButton = UIButton()
        
        if shootingPlan != nil{
            createButton.setTitle(NSLocalizedString("Update shooting plan", comment: ""), for: .normal)
        }else{
            createButton.setTitle(NSLocalizedString("Create shooting plan", comment: ""), for: .normal)
        }
        createButton.backgroundColor = Color.red
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        createButton.addTarget(self, action: #selector(self.createButtonAction), for: .touchUpInside)
        self.view.addSubview(createButton)
        
        createButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        createButton.layer.cornerRadius = 5.0
        createButton.clipsToBounds = true
        
        
        let separtorLineView = UIView()
        separtorLineView.backgroundColor = Color.gray
        self.view.addSubview(separtorLineView)
        
        separtorLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalTo(createButton.snp.top).offset(-10)
        }
        
        
        
        tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(ShootingCell.self, forCellReuseIdentifier: "ShootingCell")
        tableView.register(ResourceCell.self, forCellReuseIdentifier: "cell")

        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(separtorLineView).offset(-10)
        }
        
    }
    
    func navigationBarItems() {
        
        if shootingPlan != nil{
            self.title = NSLocalizedString("Update shooting plan", comment: "")
        }
        else{
            self.title = NSLocalizedString("Create shooting plan", comment: "")
        }
        
        
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

}

extension CreateShootingPlanViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if section == 3{
            let vw = UIView()

            let bgView = UIView()
            bgView.backgroundColor = Color.litePink
            bgView.frame = CGRect(x: 0, y: 10, width: self.view.frame.size.width, height: 40)
            vw.addSubview(bgView)
            
            let titleLabel = UILabel()
            titleLabel.text = NSLocalizedString("Resource", comment: "")
            titleLabel.frame = CGRect(x: 25, y: 0, width: self.view.frame.size.width-200, height: 40)
            titleLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14)
            bgView.addSubview(titleLabel)
            
            let image = UIImage(named: "AddResources")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            let resourceButton = UIButton()
            resourceButton.setImage(image, for: .normal)
            resourceButton.setTitle(NSLocalizedString(" Add Resource", comment: ""), for: .normal)
            resourceButton.setTitleColor(Color.red, for: .normal)
            resourceButton.addTarget(self, action: #selector(self.resourceButtonAction), for: .touchUpInside)
            resourceButton.frame = CGRect(x:  self.view.frame.size.width-130, y:0, width: 130, height: 40)
            resourceButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Light", size: 14)
            bgView.addSubview(resourceButton)
            
            return vw
        }
        else{
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        return vw
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 3{
            return 50
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3{
            return selectedProviders.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 3{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResourceCell

            cell.selectionStyle = .none
            let provider = selectedProviders[indexPath.row]
            let imageUrl = Url.providers + (provider.profile_image ?? "")
            cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = provider.name
            cell.titleLabel.text = provider.child_category
            cell.deleteButton.tag = indexPath.row
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonAction), for: .touchUpInside)
            return cell
            
        }else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShootingCell") as! ShootingCell
            cell.separatorInset = .zero
            cell.selectionStyle = .none
            cell.backgroundColor = Color.litePink
            
            if indexPath.section == 0{
                cell.titleLabel.text = NSLocalizedString("Project Name", comment: "")
                cell.textfield.placeholder = NSLocalizedString("Name", comment: "")
                cell.textfield.text = projectName
                cell.setupImage(name: "")
                
            }
            else if indexPath.section == 1{
                cell.titleLabel.text = NSLocalizedString("Shooting Date", comment: "")
                cell.textfield.placeholder = NSLocalizedString("Date", comment: "")
                cell.textfield.text = date
                cell.setupImage(name: "calendar")
                
                cell.textfield.isUserInteractionEnabled = true
                cell.textfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(datePicker)))
                if shootingPlan != nil{
                    cell.textfield.text = shootingPlan.shooting_date
                }
            }
            else if indexPath.section == 2{
                cell.titleLabel.text = NSLocalizedString("Location", comment: "")
                cell.textfield.text = address
                cell.textfield.placeholder = NSLocalizedString("Address", comment: "")
                cell.setupImage(name: "gps1")
                
                cell.textfield.isUserInteractionEnabled = true
                cell.textfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openLocation)))
                if shootingPlan != nil{
                    cell.textfield.text = shootingPlan.location
                }
            }
            return cell

        }
        
        
    }
    
    //MARK: actions
    
    @objc func datePicker(){
        
        
        let datePicker = DatePickerDialog()
        
        let currentDate = Date()
        var dateComponents1 = DateComponents()
        dateComponents1.month = 12
        let twelveMonthsAfter = Calendar.current.date(byAdding: dateComponents1, to: currentDate)
        datePicker.show("",
                        doneButtonTitle: NSLocalizedString("Done", comment: ""),
                        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                        minimumDate: Date(),
                        maximumDate: twelveMonthsAfter,
                        datePickerMode: .date) { (date) in
            
            if date != nil{
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                self.date = formatter.string(from: date!)
                self.tableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: .none)
                
            }
        }
        
    }
    @objc func openLocation(){
        let vc = LocationPickerController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func resourceButtonAction(){

      let vc = ShootingResourcesViewController()
        vc.providers = self.providers
        vc.delegate = self
      self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func deleteButtonAction(sender: UIButton){
        selectedProviders.remove(at: sender.tag)
        tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
    }
//    @objc func nameTextfieldAction(sender:UITextField){
//
//            name = sender.text ?? ""
//    }
    @objc func createButtonAction(){
        
        if date == ""{
            Banner().displayValidationError(string: NSLocalizedString("Date is required", comment: ""))
        }
        else if address == ""{
            Banner().displayValidationError(string: NSLocalizedString("Address is required", comment: ""))
        }
        else if selectedProviders.count==0{
            Banner().displayValidationError(string: NSLocalizedString("Please add atleast one resource", comment: ""))
        }
        else{
            createShootingPlan()
        }
        
    }
    func createShootingPlan(){
        
        if shootingPlan != nil{
            
            //Creating provider ids as array
            var resourceIds = [Int]()
            for i in selectedProviders {
                if let id = i.id{
                    resourceIds.append(id)
                }
            }
            
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "project_id" : CreateContract.shared.project_id ?? "",
                "shooting_date" : date,
                "location" : address,
                "latitude" : latitude,
                "longitude": longitude,
                "resources":resourceIds,
                "shooting_plan_id" : shootingPlan.id ?? 0
            ]
            
            
            WebServices.postRequest(url: Url.updateShootingPlan, params: parameters, viewController: self) { success,data  in
                if success{
                    DispatchQueue.main.async {
                        self.delegate.newPlanCreated()
                        Banner().displaySuccess(string: NSLocalizedString("Shooting plan successfully updated", comment: ""))
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    Banner().displayValidationError(string: "Error")
                }
            }
        }
        
        else {
            
            //Creating provider ids as array
            var resourceIds = [Int]()
            for i in selectedProviders {
                if let id = i.id{
                    resourceIds.append(id)
                }
            }
            
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "project_id" : CreateContract.shared.project_id ?? "",
                "shooting_date" : date,
                "location" : address,
                "latitude" : latitude,
                "longitude": longitude,
                "resources":resourceIds
            ]
            
            WebServices.postRequest(url: Url.createShootingPlan, params: parameters, viewController: self) { success,data  in
                if success{
                    DispatchQueue.main.async {
                        self.delegate.newPlanCreated()
                        Banner().displaySuccess(string: NSLocalizedString("Shooting plan successfully created", comment: ""))
                        self.navigationController?.popViewController(animated: true)
                    }
                }else{
                    Banner().displayValidationError(string: "Error")
                }
            }
        }
    }
    
    
}




extension CreateShootingPlanViewController : LocationDelegate{
    func newLocation(address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.longitude = String(longitude)
        self.latitude = String(latitude)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        
    }
}


class ShootingCell : UITableViewCell{
    
    var textfield : FloatingTextfield!
    var placeholder : String!
    var imageName : String!
    var titleLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14)
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalToSuperview().offset(10)
            make.height.equalTo(20)
        }
        
        textfield = FloatingTextfield()
      
        textfield.leftPadding = 10
        textfield.rightPadding = 20
        textfield.inputView = UIView()
        self.contentView.addSubview(textfield)
        textfield.inputView = UIView()
        textfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(25)
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.height.equalTo(45)
        }
     
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            textfield.textAlignment = .right
            textfield.titleLabel.textAlignment = .right
            textfield.leftViewMode = UITextField.ViewMode.always
            titleLabel.textAlignment = .right
        }else{
            textfield.textAlignment = .left
            textfield.titleLabel.textAlignment = .left
            textfield.rightViewMode = UITextField.ViewMode.always
            titleLabel.textAlignment = .left
        }
    }
    
    func setupImage(name:String){
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        imageView.image = UIImage(named: name)
        imageView.contentMode = .scaleAspectFit
        let rightView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
        rightView.addSubview(imageView)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            textfield.leftView = rightView
        }else{
            textfield.rightView = rightView
        }

    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ResourceCell : UITableViewCell{
    
    var profileImage : UIImageView!
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var deleteButton : UIButton!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        profileImage = UIImageView()
        profileImage.image = UIImage(named: "tom-hardy")
        profileImage.contentMode = .scaleAspectFit
        self.contentView.addSubview(profileImage)
        
        profileImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.leading.equalToSuperview().offset(30)
            make.centerY.equalToSuperview()
        }
        profileImage.layer.cornerRadius = 30
        profileImage.clipsToBounds = true
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14)
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.top.equalTo(profileImage).offset(10)
            make.trailing.equalToSuperview().offset(-50)
            
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        nameLabel.textColor = Color.gray
        self.contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImage.snp.trailing).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(05)
            make.trailing.equalToSuperview().offset(-50)
        }
        
        deleteButton = UIButton()
        deleteButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Light", size: 15)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.setTitleColor(Color.red, for: .normal)
        self.contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: providers select delegate

protocol ResourceDelegate {
    func selected(resources : [ResourcesData])
}

extension CreateShootingPlanViewController : ResourceDelegate{
    
    func selected(resources : [ResourcesData]){
        selectedProviders = resources
        tableView.reloadSections(IndexSet(integer: 3), with: .automatic)
    }
    
}
