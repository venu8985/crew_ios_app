//
//  RequestDetailsViewController.swift
//  Crew
//
//  Created by Rajeev on 14/04/21.
//

import UIKit

class RequestDetailsViewController: UIViewController {

    var hire_agency_id : Int!
    var projectNameTextfield : FloatingTextfield!
    var descriptionTextView : UITextView!
    var startLabel     : UILabel!
    var stopLabel      : UILabel!
    var budgetLabel    : UILabel!
    var locationButton : UIButton!
    var imageView      : UIImageView!
    var nameLabel      : UILabel!
    var acceptButton   : UIButton!
    var rejectButton   : UIButton!
    var lineView       : UIView!
    var lineView1      : UIView!
    var descriptionLabel : UILabel!
    var dateTimelineButton : UIButton!
    var projectBudgetButton : UIButton!
    var startButton : UIButton!
    var stopButton : UIButton!
    var lineView3 : UIView!
    var lineView4 : UIView!
    var lineView5 : UIView!
    var viewContractButton : UIButton!
    var contractId : Int!
    var statusLabel : UILabel!
    var dotView : UIView!
    var requestDetail:RequestDetailsData?
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        navigationBarItems()
    
        projectNameTextfield = FloatingTextfield()
        projectNameTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 08)
        projectNameTextfield.placeholder = NSLocalizedString("Project Name", comment: "")
        projectNameTextfield.backgroundColor = .white
        projectNameTextfield.leftPadding = 10
        projectNameTextfield.rightPadding = 20
        projectNameTextfield.isUserInteractionEnabled = false
        projectNameTextfield.font = UIFont.systemFont(ofSize: 14.0)
        self.view.addSubview(projectNameTextfield)
        
        projectNameTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
            make.height.equalTo(46)
        }
        
        projectNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        projectNameTextfield.layer.cornerRadius = 5.0
        projectNameTextfield.layer.borderWidth = 0
        projectNameTextfield.clipsToBounds = true
        
    
        
        
        statusLabel = UILabel()
        statusLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        statusLabel.textColor = Color.red
        self.view.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(projectNameTextfield)
        }
        
        dotView = UIView()
        self.view.addSubview(dotView)
        
        dotView.snp.makeConstraints { (make) in
            make.width.height.equalTo(08)
            make.trailing.equalTo(statusLabel.snp.leading).offset(-4)
            make.top.equalTo(statusLabel)
        }
        dotView.layer.cornerRadius = 4.0
        dotView.clipsToBounds = true
        
        
        lineView = UIView()
        lineView.frame = CGRect(x: 30, y: 55, width: self.view.frame.size.width-60, height: 0.25)
        self.view.addSubview(lineView)
        drawDottedLine(start: CGPoint(x: lineView.bounds.minX, y: lineView.bounds.minY), end: CGPoint(x: lineView.bounds.maxX, y: lineView.bounds.minY), view: lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(projectNameTextfield)
            make.trailing.equalTo(projectNameTextfield)
            make.top.equalTo(projectNameTextfield.snp.bottom).offset(10)
            make.height.equalTo(0.25)
        }

        descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("Description", comment: "")
        descriptionLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        descriptionLabel.textColor = Color.gray
        self.view.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView)
            make.top.equalTo(lineView.snp.bottom).offset(15)
        }
        

        descriptionTextView = UITextView()
        descriptionTextView.textColor = Color.liteBlack
        descriptionTextView.textAlignment = .justified
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.view.addSubview(descriptionTextView)
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView).inset(-5)
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.height.lessThanOrEqualTo(150)
        }

        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            projectNameTextfield.textAlignment = .right
            projectNameTextfield.titleLabel.textAlignment = .right
            descriptionTextView.textAlignment = .right
        }else{
            projectNameTextfield.textAlignment = .left
            projectNameTextfield.titleLabel.textAlignment = .left
            descriptionTextView.textAlignment = .left
        }
        
        dateTimelineButton = UIButton()
        dateTimelineButton.setTitleColor(UIColor.red, for: .normal)
        dateTimelineButton.setTitle(NSLocalizedString("  Dates / Timeline ", comment: ""), for: .normal)
        dateTimelineButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        let dateImage = UIImage(named: "date_timeline")//?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        dateTimelineButton.setImage(dateImage, for: .normal)
        dateTimelineButton.isUserInteractionEnabled = false
        self.view.addSubview(dateTimelineButton)
        
        dateTimelineButton.snp.makeConstraints { (make) in
            make.leading.equalTo(descriptionTextView).offset(5)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(15)
            
        }
        
        
        startButton = StartStopButton()
        startButton.isUserInteractionEnabled = false
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        startButton.setTitle(NSLocalizedString("Start   ", comment: ""), for: .normal)
        self.view.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-14)
            make.top.equalTo(dateTimelineButton.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        startButton.imageEdgeInsets = UIEdgeInsets(top: 04, left: 30, bottom: 04, right: 36)
        
        
        stopButton = StartStopButton()
        stopButton.isUserInteractionEnabled = false
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        stopButton.setTitle(NSLocalizedString("Stop    ", comment: ""), for: .normal)
        self.view.addSubview(stopButton)
        
        stopButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-14)
            make.top.equalTo(startButton.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
        stopButton.imageEdgeInsets = UIEdgeInsets(top: 05, left: 31, bottom: 03, right: 35);
        
        
        lineView1 = UIView()
        lineView1.backgroundColor = .lightGray
        self.view.addSubview(lineView1)
   
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(startButton.snp.bottom).inset(5)
                make.bottom.equalTo(stopButton.snp.top).offset(5)
                make.leading.equalTo(startButton).inset(22)
                make.width.equalTo(1)
            }
            
        }else{
            
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(startButton.snp.bottom).inset(5)
                make.bottom.equalTo(stopButton.snp.top).offset(5)
                make.trailing.equalTo(startButton).inset(22)
                make.width.equalTo(1)
            }
        }
        
        startLabel = UILabel()
        startLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(startLabel)
        
        startLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startButton)
            make.leading.equalTo(startButton.snp.trailing).offset(-10)
        }
        
        
        stopLabel = UILabel()
        stopLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(stopLabel)
        
        stopLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stopButton)
            make.leading.equalTo(stopButton.snp.trailing).offset(-10)
        }
        
        
        budgetLabel = UILabel()
        budgetLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLabel)
            make.leading.equalTo(startLabel.snp.trailing).offset(50)
        }
        
        
        projectBudgetButton = UIButton()
        projectBudgetButton.setTitleColor(UIColor.red, for: .normal)
        projectBudgetButton.setTitle(NSLocalizedString("  Project Budget ", comment: ""), for: .normal)
        projectBudgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        let budgetImage = UIImage(named: "project_budget")//?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        projectBudgetButton.setImage(budgetImage, for: .normal)
        projectBudgetButton.isUserInteractionEnabled = false
        self.view.addSubview(projectBudgetButton)
        
        projectBudgetButton.snp.makeConstraints { (make) in
            make.leading.equalTo(budgetLabel)
            make.top.equalTo(dateTimelineButton)
            
        }

        
        lineView3 = UIView()
        lineView3.backgroundColor = Color.gray
        self.view.addSubview(lineView3)
        
        lineView3.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton)
            make.trailing.equalTo(lineView)
            make.top.equalTo(stopButton.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        //location_1
//        let location
        let locationImage = UIImage(named: "location_2")//?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        locationButton = UIButton()
        locationButton.setTitleColor(Color.gray, for: .normal)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        locationButton.setImage(locationImage, for: .normal)
//        locationButton.contentHorizontalAlignment = .left
//        locationButton.semanticContentAttribute = .forceRightToLeft
        self.view.addSubview(locationButton)
        
        locationButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView3)
            make.top.equalTo(lineView3.snp.bottom).offset(10)
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            locationButton.contentHorizontalAlignment = .right
        }else{
            locationButton.contentHorizontalAlignment = .left
        }
        
        lineView4 = UIView()
        lineView4.backgroundColor = Color.liteGray
        self.view.addSubview(lineView4)
        
        lineView4.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton)
            make.trailing.equalTo(lineView)
            make.top.equalTo(locationButton.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView4).offset(10)
            make.leading.equalTo(lineView4)
            make.width.height.equalTo(50)
        }
        
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.systemFont(ofSize: 14)
        self.view.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.centerY.equalTo(imageView)
            make.width.equalTo(self.view).dividedBy(2)
        }
        
        
        let contractImage = UIImage(named: "eye")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        viewContractButton = UIButton()
        viewContractButton.setTitle(NSLocalizedString("   View Contract", comment: ""), for: .normal)
        viewContractButton.setTitleColor(.black, for: .normal)
        viewContractButton.backgroundColor = Color.liteGray
        viewContractButton.setImage(contractImage, for: .normal)
        viewContractButton.contentHorizontalAlignment = .left
        self.view.addSubview(viewContractButton)
        viewContractButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12)

        viewContractButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-20)
            make.centerY.equalTo(nameLabel)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        viewContractButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 05, bottom: 0, right: 15);
        viewContractButton.layer.cornerRadius = 5.0
        viewContractButton.clipsToBounds = true
        
        
        rejectButton = UIButton()
        rejectButton.setTitle(NSLocalizedString("Reject", comment: ""), for: .normal)
        rejectButton.backgroundColor = Color.red
        rejectButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(rejectButton)
        
        rejectButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(25)
            make.width.equalTo(self.view).dividedBy(2.2)
        }
        
        rejectButton.layer.cornerRadius = 5.0
        rejectButton.clipsToBounds = true
        
         
        
        acceptButton = UIButton()
        acceptButton.setTitle(NSLocalizedString("Send Proposal", comment: ""), for: .normal)
        acceptButton.backgroundColor = Color.green
        acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        self.view.addSubview(acceptButton)
        
        acceptButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(25)
            make.width.equalTo(self.view).dividedBy(2.5)
        }
        
        acceptButton.layer.cornerRadius = 5.0
        acceptButton.clipsToBounds = true
        
        
        lineView5 = UIView()
        lineView5.backgroundColor = Color.gray
        self.view.addSubview(lineView5)
        
        lineView5.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(0.5)
            make.bottom.equalTo(rejectButton.snp.bottom).offset(10)
        }
        
        
        //Hiding temporarily until api response
        projectNameTextfield.isHidden = true
        descriptionLabel.isHidden     = true
        descriptionTextView.isHidden  = true
        startLabel.isHidden           = true
        stopLabel.isHidden            = true
        budgetLabel.isHidden          = true
        locationButton.isHidden       = true
        imageView.isHidden            = true
        nameLabel.isHidden            = true
        acceptButton.isHidden         = true
        rejectButton.isHidden         = true
        lineView.isHidden             = true
        lineView1.isHidden            = true
        lineView3.isHidden            = true
        dateTimelineButton.isHidden   = true
        projectBudgetButton.isHidden  = true
        lineView4.isHidden            = true
        lineView5.isHidden            = true
        startButton.isHidden          = true
        stopButton.isHidden           = true
        viewContractButton.isHidden   = true
        
    }
    
    @objc func acceptButtonAction(){
        let vc = CreateProposalViewController()
        vc.hire_agency_id = hire_agency_id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func PayForProposalButtonAction(){
        let vc = UIStoryboard.instantiateViewController(withViewClass: ProposalWalletViewController.self)
        vc.modalPresentationStyle = .overFullScreen
        vc.proposalId = requestDetail?.proposals.id ?? 0
        vc.completionHandler = { status in
            if status{
                self.fetchRequestDetails()
            }
        }
        self.present(vc, animated: true)
    }
    @objc func rejectButtonAction(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id" : hire_agency_id ?? 0
        ]

        WebServices.postRequest(url: Url.rejectProposal, params: parameters, viewController: self) { success,data  in
            
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Request is rejected", comment: ""))
                NotificationCenter.default.post(name: Notification.agencyRequests, object: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                Banner().displayValidationError(string: "Error")
            }
            
        }
        
    }
    
    func fetchRequestDetails(){
 
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id" : hire_agency_id ?? 0
        ]

        WebServices.postRequest(url: Url.requestDetails, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let requestDetails = try decoder.decode(RequestDetails.self, from: data)
                self.requestDetail = requestDetails.data
                let request = requestDetails.data
                self.title = request.name
                self.projectNameTextfield.text = request.name
                self.descriptionTextView.text = request.description
                let location = "  \(request.city_name ?? ""),\(request.country_name ?? "")"
                self.locationButton.setTitle(location, for: .normal)
                
                let budgetString = request.budget ?? "0"
                let budgetFloat = Float(budgetString)
                let budget = Int(budgetFloat ?? 0)
                self.budgetLabel.text = "SAR \(budget)"
                
                
                self.statusLabel.text = request.status
                
                if request.status == "Proposal Generated"{
                    self.statusLabel.text = NSLocalizedString(request.status, comment: "")
                    self.statusLabel.textColor = Color.green
                    self.dotView.backgroundColor = Color.green
                }else{
                    self.statusLabel.text = NSLocalizedString(request.status, comment: "")
                    self.statusLabel.textColor = Color.red
                    self.dotView.backgroundColor = Color.red
                }
                
                
                let dateFormatter = DateFormatter()
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                dateFormatter.dateFormat = "yyyy-MM-dd"
                let startDate = dateFormatter.date(from: request.start_at )
                let endDate = dateFormatter.date(from: request.end_at )

                dateFormatter.dateFormat = "dd MMM yyyy"
                dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                if let date = startDate{
                    let dateString = dateFormatter.string(from: date)
                    self.startLabel.text = dateString
                }
                if let date = endDate{
                    let dateString = dateFormatter.string(from: date)
                    self.stopLabel.text = dateString
                }
                
                let profilePicurl = Url.userProfile + (request.profile_image ?? "")
                self.imageView.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
                self.nameLabel.text = request.company_name
                
                if let contract = request.contracts{
                    if let contractId = contract.id{
                        self.contractId = contractId
                    }
                }
                if let proposals = request.proposals{
                    if proposals.status == "Confirmed"{
                        self.acceptButton.isHidden = true
                        self.rejectButton.isHidden = true
                    }else{
                        self.acceptButton.setTitle(NSLocalizedString("Pay For Proposal", comment: ""), for: .normal)
                        self.acceptButton.isHidden = false
                        self.rejectButton.isHidden = false
                        self.rejectButton.addTarget(self, action: #selector(self.rejectButtonAction), for: .touchUpInside)
                        self.acceptButton.addTarget(self, action: #selector(self.PayForProposalButtonAction), for: .touchUpInside)
                    }
                }else{
                    self.acceptButton.isHidden = false
                    self.rejectButton.isHidden = false
                    self.rejectButton.addTarget(self, action: #selector(self.rejectButtonAction), for: .touchUpInside)
                    self.acceptButton.addTarget(self, action: #selector(self.acceptButtonAction), for: .touchUpInside)
                }
                
                if request.status == "Rejected"{
                    self.acceptButton.isHidden = true
                    self.rejectButton.isHidden = true
                }
                
                
                if let contract = request.contracts{
                    if contract.status == "Pending"{
                        self.acceptButton.isHidden = false
                        self.rejectButton.isHidden = false
                        self.viewContractButton.isHidden = false
                        
                        self.acceptButton.setTitle(NSLocalizedString("Accept", comment: ""), for: .normal)
                        self.rejectButton.addTarget(self, action: #selector(self.contractRejectButtonAction), for: .touchUpInside)
                        self.acceptButton.addTarget(self, action: #selector(self.contractAcceptButtonAction), for: .touchUpInside)
                        self.viewContractButton.addTarget(self, action: #selector(self.viewContractButtonAction), for: .touchUpInside)
                        
                    }
                }
                
                
                //unhiding temporarily until api response
                self.projectNameTextfield.isHidden = false
                self.descriptionLabel.isHidden     = false
                self.descriptionTextView.isHidden  = false
                self.startLabel.isHidden           = false
                self.stopLabel.isHidden            = false
                self.budgetLabel.isHidden          = false
                self.locationButton.isHidden       = false
                self.imageView.isHidden            = false
                self.nameLabel.isHidden            = false
                self.lineView.isHidden             = false
                self.lineView1.isHidden            = false
                self.lineView3.isHidden            = false
                self.dateTimelineButton.isHidden   = false
                self.projectBudgetButton.isHidden  = false
                self.lineView4.isHidden            = false
                self.lineView5.isHidden            = false
                self.startButton.isHidden          = false
                self.stopButton.isHidden           = false
                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
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
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
        self.fetchRequestDetails()
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = Color.red.withAlphaComponent(0.25).cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    //MARK: contract button actions
    
    @objc func contractRejectButtonAction() {
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id" : hire_agency_id ?? 0,
            "contract_id" : self.contractId ?? 0
        ]

        WebServices.postRequest(url: Url.rejectContract, params: parameters, viewController: self) { success,data  in
            
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Contract is rejected", comment: ""))
                NotificationCenter.default.post(name: Notification.agencyRequests, object: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                Banner().displayValidationError(string: "Error")
            }
            
        }
        
    }
    
    @objc func contractAcceptButtonAction(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id" : hire_agency_id ?? 0,
            "contract_id" : self.contractId ?? 0
        ]

        WebServices.postRequest(url: Url.acceptContract, params: parameters, viewController: self) { success,data  in
            
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Contract is accepted", comment: ""))
                NotificationCenter.default.post(name: Notification.agencyRequests, object: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                Banner().displayValidationError(string: "Error")
            }
            
        }
        
    }
    @objc func viewContractButtonAction(){
        
    }
}
