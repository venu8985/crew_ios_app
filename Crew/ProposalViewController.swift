//
//  ProposalViewController.swift
//  Crew
//
//  Created by Rajeev on 13/04/21.
//

import UIKit

class ProposalViewController: UIViewController {

    var descString: String!
    var image : String!
    var agencyId : Int!
    var hideAwardButton : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBarItems()
        self.view.backgroundColor = .white
        
        if !hideAwardButton{
            
            let awardButton = UIButton()
            awardButton.setTitle(NSLocalizedString("Award", comment: ""), for: .normal)
            awardButton.backgroundColor = Color.red
            awardButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 14)
            awardButton.addTarget(self, action: #selector(self.awardButtonAction), for: .touchUpInside)
            self.view.addSubview(awardButton)
            
            awardButton.snp.makeConstraints { (make) in
                make.height.equalTo(44)
                make.leading.trailing.equalTo(self.view).inset(20)
                make.bottom.equalTo(self.view).inset(25)
            }
            
            awardButton.layer.cornerRadius = 5.0
            awardButton.clipsToBounds = true
            
            
            let lineView = UIView()
            lineView.backgroundColor = Color.liteGray
            self.view.addSubview(lineView)
            
            lineView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.height.equalTo(1)
                make.bottom.equalTo(awardButton.snp.top).offset(-10)
            }
        }
        let descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("Description", comment: "")
        descriptionLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview().inset(20)
        }
        
        let descriptionTextView = UITextView()
        descriptionTextView.inputView = UIView()
        descriptionTextView.textAlignment = .justified
        descriptionTextView.text = descString
        self.view.addSubview(descriptionTextView)
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(05)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(200)
        }
        
//        descriptionTextView.isScrollEnabled = true
        
        
        let borderView = UIView()
        self.view.addSubview(borderView)
        
        borderView.layer.borderColor = Color.liteGray.cgColor
        borderView.layer.borderWidth = 0.5
        borderView.layer.cornerRadius = 10.0
        borderView.clipsToBounds = true
        
        borderView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view).inset(10)
            make.bottom.equalTo(descriptionTextView).offset(5)
        }
        
        let attachImage = UIImage(named: "attachment")?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
        let attachButton = UIButton()
        attachButton.addTarget(self, action: #selector(self.attachButtonAction), for: .touchUpInside)
        attachButton.setImage(attachImage, for: .normal)
        self.view.addSubview(attachButton)
        attachButton.backgroundColor = Color.liteGray
        
        attachButton.snp.makeConstraints { (make) in
            make.leading.equalTo(descriptionTextView)
            make.top.equalTo(borderView.snp.bottom).offset(05)
            make.width.height.equalTo(40)
        }
        attachButton.layer.cornerRadius = 10
        attachButton.clipsToBounds = true
        
        let attachmentLabel = UILabel()
        attachmentLabel.text = NSLocalizedString("View attachment", comment:
                                                 "")
        attachmentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        attachmentLabel.textColor = Color.red
        self.view.addSubview(attachmentLabel)
        
        attachmentLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(attachButton.snp.trailing).offset(05)
            make.centerY.equalTo(attachButton)
        }
        
        
        attachmentLabel.isUserInteractionEnabled = true
        attachmentLabel.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(attachButtonAction)))
    }
    @objc func attachButtonAction(){
        let attachmentURL = Url.proposal + image
        let vc = CRNViewController()
        vc.crnURLString = attachmentURL
        self.present(vc, animated: true, completion: nil)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func awardButtonAction(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id"  : agencyId ?? 0
        ]
        
        WebServices.postRequest(url: Url.award, params: parameters, viewController: self) { success,data  in
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Succesfully awarded", comment: ""))
                if let nav = self.navigationController {
                    nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 3], animated: true)
                }
            }else{
                Banner().displayValidationError(string: "Error")
            }
        }
    }
    
    
    func navigationBarItems() {
            self.navigationItem.title = NSLocalizedString("Proposal", comment: "")
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
