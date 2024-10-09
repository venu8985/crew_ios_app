//
//  CreateAuditionViewController.swift
//  Crew
//
//  Created by Rajeev on 19/04/21.
//

import UIKit
import DatePickerDialog

class CreateAuditionViewController: UIViewController {

    var tableView : UITableView!
    var address = ""
    var date = ""
    var latitude = ""
    var longitude = ""
    var projectName : String!
    var profiles = [FeaturedProfile]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        navigationBarItems()
        
     
        
        let createButton = UIButton()
        createButton.setTitle(NSLocalizedString("Send Audition Request", comment: ""), for: .normal)
        createButton.backgroundColor = Color.red
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
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
            self.navigationItem.title = NSLocalizedString("Send Audition Request", comment: "")
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
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
        
}

extension CreateAuditionViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
 
        let vw = UIView()
        vw.backgroundColor = UIColor.white
        return vw
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                    
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
                cell.titleLabel.text = NSLocalizedString("Audition Date", comment: "")
                cell.textfield.placeholder = NSLocalizedString("Date", comment: "")
                cell.textfield.text = date
                cell.setupImage(name: "calendar")
                
                cell.textfield.isUserInteractionEnabled = true
                cell.textfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(datePicker)))
             
            }
            else if indexPath.section == 2{
                cell.titleLabel.text = NSLocalizedString("Location", comment: "")
                cell.textfield.placeholder = NSLocalizedString("Address", comment: "")
                cell.textfield.text = address
                cell.setupImage(name: "gps1")
                
                cell.textfield.isUserInteractionEnabled = true
                cell.textfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(openLocation)))
               
            }
            return cell
        
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
    


    @objc func createButtonAction(){
        
        if date == ""{
            Banner().displayValidationError(string: NSLocalizedString("Date is required", comment: ""))
        }
        else if address == ""{
            Banner().displayValidationError(string: NSLocalizedString("Address is required", comment: ""))
        }
        
        else{
            createShootingPlan()
        }
        
    }
    func createShootingPlan(){
        
        
        var providersArray = [[String:Int]]()
        
        for profile in profiles{
            
            let profileIds = ["provider_id":profile.provider_id ?? 0,"provider_profile_id":profile.id ?? 0]
            providersArray.append(profileIds)
        }
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "project_id" : CreateContract.shared.project_id ?? "",
            "audition_date" : date,
            "location" : address,
            "latitude" : latitude,
            "longitude": longitude,
            "providers": providersArray
        ]
        
        WebServices.postRequest(url: Url.inviteAudition, params: parameters, viewController: self) { success,data  in
            if success{
                DispatchQueue.main.async {
                                        
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : AudtionSuccessViewController = storyboard.instantiateViewController(withIdentifier: "AudtionSuccessViewController") as! AudtionSuccessViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }else{
//                Banner().displayValidationError(string: "Error")
            }
        }
    }
    
    
}




extension CreateAuditionViewController : LocationDelegate{
    func newLocation(address: String, latitude: Double, longitude: Double) {
        self.address = address
        self.longitude = String(longitude)
        self.latitude = String(latitude)
        tableView.reloadRows(at: [IndexPath(row: 0, section: 2)], with: .automatic)
        
    }
}

