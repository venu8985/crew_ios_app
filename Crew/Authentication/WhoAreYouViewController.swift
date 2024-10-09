//
//  WhoAreYouViewController.swift
//  Crew
//
//  Created by Rajeev on 18/03/21.
//

import UIKit

class WhoAreYouViewController: UIViewController {
    
    var mobileNumberString : String!
    
    enum ProfileType : String{
        case Agency = "agency"
        case company = "company"
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        navigationBarItems()
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = Color.liteGray
        self.view.addSubview(tableView)
        tableView.register(WhoAmITVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Who are you?", comment: "")
        
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
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        
    }
    
    @objc func popVC(){
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
}

extension WhoAreYouViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.view.frame.size.height/2.25
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WhoAmITVCell
        cell.selectionStyle = .none
        
        if indexPath.row == 0{
            cell.backgroundColor = .white
            cell.infoLabel.text = NSLocalizedString("I am operating media agency", comment: "")
            cell.imgView?.image = UIImage(named: "mediaAgency")
            cell.arrowImageView.image = UIImage(named: "mediaAgencyArrow")
        }else{
            cell.backgroundColor = Color.liteGray
            cell.infoLabel.text = NSLocalizedString("I am looking for a media agency", comment: "")
            cell.imgView?.image = UIImage(named: "mediaAgencySearch")
            cell.arrowImageView.image = UIImage(named: "mediaAgencySearchArrow")
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateProfileType(profileType: (indexPath.row==0) ? ProfileType.Agency.rawValue:ProfileType.company.rawValue)
        
    }
    
    
    func updateProfileType(profileType:String){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "profile_type" : profileType
        ]
        
        WebServices.postRequest(url: Url.updateProfileType, params: parameters, viewController: self) { success,data  in
            
            do {
                let decoder = JSONDecoder()
                let getProfileResponse = try decoder.decode(CompleteProfile.self, from: data)
                DispatchQueue.main.async {
                    if success{
                        
                        Profile.shared.details = getProfileResponse.data
                        UserDefaults.standard.setValue(profileType, forKey: "ProfileType")
                        
                        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc : ProfileSetupViewController = storyboard.instantiateViewController(withIdentifier: "ProfileSetupViewController") as! ProfileSetupViewController
                        vc.mobileNumberString = self.mobileNumberString
                        vc.isMediaAgency = profileType=="agency" ? true : false
                        vc.hidePasswords = false
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                        
                    }else{
                    }
                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    
}


class WhoAmITVCell : UITableViewCell{
    
    
    public var infoLabel : UILabel!
    public var imgView : UIImageView!
    public var arrowImageView : UIImageView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        imgView = UIImageView()
        imgView.isUserInteractionEnabled = false
        imgView.clipsToBounds = true
        self.contentView.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(70)
            make.centerX.equalTo(self.contentView)
            make.top.equalTo(self.contentView).offset((UIScreen.main.bounds.height/4)-100)
        }
        
        infoLabel = UILabel()
        infoLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        infoLabel.textAlignment = .center
        self.contentView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.contentView)
            make.top.equalTo(imgView.snp.bottom).offset(20)
        }
        
        arrowImageView = UIImageView()
        arrowImageView.clipsToBounds = true
        self.contentView.addSubview(arrowImageView)
        
        arrowImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(35)
            make.top.equalTo(infoLabel.snp.bottom).offset(30)
            make.centerX.equalTo(infoLabel)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
