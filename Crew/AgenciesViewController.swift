//
//  AgenciesViewController.swift
//  Crew
//
//  Created by Rajeev on 12/04/21.
//

import UIKit

class AgenciesViewController: UIViewController {

    var tableView : UITableView!
    var agenciesList = [Agency]()
    var paginationCount = 0
    var lastPage : Int!
    var selectedIndex : Int!
    var agency_id : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let requestButton = UIButton()
        requestButton.setTitle(NSLocalizedString("Send Request", comment: ""), for: .normal)
        requestButton.backgroundColor = Color.red
        requestButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        requestButton.addTarget(self, action: #selector(self.requestButtonAction), for: .touchUpInside)
        self.view.addSubview(requestButton)
        
        requestButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(25)
        }
        
        requestButton.layer.cornerRadius = 5.0
        requestButton.clipsToBounds = true
        
        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(requestButton.snp.top).offset(-10)
        }
        
        tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        tableView.register(agencyTVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(lineView.snp.top)
        }
        
        navigationBarItems()
        fetchAgencies()
        
        
 
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func requestButtonAction(){
        
        if selectedIndex == nil{
            Banner().displayValidationError(string: NSLocalizedString("Please Select any one agency to proceed", comment: ""))
            return
        }
        
        let parameters: [String: Any] = [
            "current_version"      : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale"               : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id"            : UIDevice.current.identifierForVendor!.uuidString,
            "device_type"          : "ios",
            "agency_id"            : agency_id ?? "",
            "project_id"           : CreateContract.shared.project_id ?? ""
        ]
        
        WebServices.postRequest(url: Url.hireAgency, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(HireAgency.self, from: data)
                
                DispatchQueue.main.async {
                    
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : ResponseViewController = storyboard.instantiateViewController(withIdentifier: "ResponseViewController") as! ResponseViewController
                        vc.requestNo = ""
                    vc.isSuccess = true
                    if let error = response.errors?.error?.first{
                        print("response")
                        vc.errorMessage = error
                        vc.isSuccess = false
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
               
                
                
                
                print("response")
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func fetchAgencies(){
 
        if lastPage == paginationCount{
            return
        }
        
        paginationCount += 1
        
        let parameters: [String: Any] = [
            
            "current_version"      : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale"               : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id"            : UIDevice.current.identifierForVendor!.uuidString,
            "device_type"          : "ios",
            "page"                 : "\(paginationCount)",
            "project_id"           : CreateContract.shared.project_id ?? ""
            
        ]
        
        WebServices.postRequest(url: Url.agencyList, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(AgencyList.self, from: data)
                self.lastPage = response.data?.last_page
                
                if let agencies = response.data?.data{
                    self.agenciesList = agencies
                }
                self.tableView.reloadData()
                print("response")
            }catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }

    func navigationBarItems() {
        self.title = NSLocalizedString("Agencies", comment: "")
        self.view.backgroundColor = .white
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

extension AgenciesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agenciesList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! agencyTVCell
 
        cell.selectionStyle = .none
        
        let provider = agenciesList[indexPath.row]
        let imageUrl = Url.userProfile + (provider.profile_image ?? "")
        cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        cell.titleLabel.text = provider.name
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            cell.titleLabel.textAlignment = .right
        }else{
            cell.titleLabel.textAlignment = .left
        }
        
        if selectedIndex == indexPath.row{
            cell.bgView.layer.borderColor = Color.red.cgColor
        }else{
            cell.bgView.layer.borderColor = Color.gray.cgColor
        }
        
        
        if agenciesList[indexPath.row].hiredAgency == nil{
            cell.alreadyHired.isHidden = true
        }else{
            cell.alreadyHired.isHidden = false
        }
        
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if agenciesList[indexPath.row].hiredAgency == nil{
            
            selectedIndex = indexPath.row
            agency_id = agenciesList[indexPath.row].id
            tableView.reloadData()
        }
        
      
    }
    
    
}


class agencyTVCell : UITableViewCell{
    
    var profileImage : UIImageView!
    var titleLabel : UILabel!
    var bgView : UIView!
    var alreadyHired : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        profileImage = UIImageView()
        profileImage.contentMode = .scaleAspectFill
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
        
        
        
        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView).inset(5)
        }
        
        bgView.layer.cornerRadius = 5.0
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = Color.gray.cgColor
        
     
     
        let image = UIImage(named: "White-tick")//?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        alreadyHired = UIImageView()
        alreadyHired.image = image
        alreadyHired.contentMode = .center
        alreadyHired.backgroundColor = UIColor.systemGreen.withAlphaComponent(0.5)
        bgView.addSubview(alreadyHired)
        
        alreadyHired.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(profileImage)
        }
        alreadyHired.layer.cornerRadius = 30
        alreadyHired.clipsToBounds = true
        self.contentView.bringSubviewToFront(alreadyHired)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
