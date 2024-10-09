//
//  ProviderMilestonesViewController.swift
//  Crew
//
//  Created by Rajeev on 06/04/21.
//

import UIKit

class ProviderMilestonesViewController: UIViewController {

    var hire_resource_id        : Int!
    var nameLabel               : UILabel!
    var budgetLabel             : UILabel!
    var dateLabel               : UILabel!
    var dateRangeLabel          : UILabel!
    var daysLabel               : UILabel!
    var paymentMilestonesLabel  : UILabel!
    var amountLabel             : UILabel!
    var pendingAmountLabel      : UILabel!
    var tableView               : UITableView!
    var milestones              = [Milestone]()
    var profileImageView        : UIImageView!
    var profileButton           : UIButton!
    var calendarIcon            : UIImageView!
    var viewContractButton      : UIButton!
    var paymentMilestoneTitleLabel : UILabel!
    var amountTitleLabel           : UILabel!
    var amountIcon                 : UIImageView!
    var pendingAmountTitleLabel    : UILabel!
    var lineView                   : UIView!
    var lineView1                  : UIView!
    var lineView2                  : UIView!
    var statusLabel                : UILabel!
    var submitButton              : UIButton!
    
    var paidAmount:Double = 0
    
    var isContractAccepted = false
    var isJobDone = false
    var allPaid = false
    var sectionsCount = 1
    var review = ""
    var profileId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = UIColor.white//(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        self.navigationBarItems()

        loadUI()
        
        profileImageView.isHidden              = true
        profileButton.isHidden                 = true
        calendarIcon.isHidden                  = true
        amountLabel.isHidden                   = true
        pendingAmountLabel.isHidden            = true
        viewContractButton.isHidden            = true
        paymentMilestoneTitleLabel.isHidden    = true
        amountTitleLabel.isHidden              = true
        amountIcon.isHidden                    = true
        pendingAmountTitleLabel.isHidden       = true
        lineView.isHidden                      = true
        lineView1.isHidden                     = true
        lineView2.isHidden                     = true
        
       loadResourceDetails()
    }
    
    func loadResourceDetails(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_resource_id" : hire_resource_id ?? 0
        ]
        
        WebServices.postRequest(url: Url.resourceDetails, params: parameters, viewController: self) { [self] success,data  in
            
            if success{
                do {
                    let decoder = JSONDecoder()
                    let resourceDetails = try decoder.decode(ResourceDetails.self, from: data)
                    
                    
                    CreateContract.shared.provider_id = resourceDetails.data.provider_id
                    CreateContract.shared.provider_profile_id = resourceDetails.data.id
                    self.profileId = resourceDetails.data.provider_profile_id
                    
                    let imageUrl = Url.providers + (resourceDetails.data.profile_image ?? "")
                    self.profileImageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
                    
                    self.nameLabel.text = resourceDetails.data.name

                    
                    let chargesUnit = resourceDetails.data.charges_unit ?? ""
                    let chargesString = resourceDetails.data.charges ?? "0"
                    let chargesFloat = Float(chargesString)
                    let charges = Int(chargesFloat ?? 0)
                    self.budgetLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit)"
                    
                    
                    if let dateString = resourceDetails.data.created_at{
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
                        let showDate = inputFormatter.date(from: dateString)
                        inputFormatter.dateFormat = "dd MMM, yyyy"
                        self.dateLabel.text = inputFormatter.string(from: showDate!)
                    }
                    
                    var dateRangeString : String!
                    if let startDate = resourceDetails.data.slots.first?.start_at{
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        let showDate = inputFormatter.date(from: startDate)
                        inputFormatter.dateFormat = "dd MMM, yyyy"
                        dateRangeString = inputFormatter.string(from: showDate!)
                    }
                    if let endDate = resourceDetails.data.slots.last?.end_at{
                        let inputFormatter = DateFormatter()
                        inputFormatter.dateFormat = "yyyy-MM-dd"
                        let showDate = inputFormatter.date(from: endDate)
                        inputFormatter.dateFormat = "dd MMM, yyyy"
                        let date = inputFormatter.string(from: showDate!)
                        dateRangeString = "\(dateRangeString ?? "")-\(date)"
                    }
                    self.dateRangeLabel.text = dateRangeString;
                    var days = 0
                    for slot in resourceDetails.data.slots{
                        if let dayCount = slot.days{
                            days = days+dayCount
                        }
                    }
                    self.daysLabel.text = "\(NSLocalizedString("Request for -", comment: "")) \(days) \(NSLocalizedString("days", comment: ""))"
                    self.title = resourceDetails.data.main_category
                    self.isContractAccepted = (resourceDetails.data.status == "Contract Accepted")
                    self.isJobDone = (resourceDetails.data.status == "Job Done")

                    self.statusLabel.text = NSLocalizedString(resourceDetails.data.status ?? "", comment: "")
                    if self.isContractAccepted || self.isJobDone{
                        self.statusLabel.textColor = Color.green
                    }else{
                        self.statusLabel.textColor = Color.red
                    }
                    
                    if resourceDetails.data.milestones.count>1{
                        self.paymentMilestonesLabel.text = "\(resourceDetails.data.milestones.count) \(NSLocalizedString("Milestones", comment: ""))"
                    }else{
                        self.paymentMilestonesLabel.text = "\(resourceDetails.data.milestones.count) \(NSLocalizedString("Milestone", comment: ""))"
                    }
                    
                    
                    let amountString = resourceDetails.data.total_amount ?? "0"
                    let amountFloat = Float(amountString)
                    let amount = Int(amountFloat ?? 0)
                    self.amountLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(amount)"
                    
                
                    
                    self.milestones = resourceDetails.data.milestones
                    self.allPaid = true
                    for mile in self.milestones{
                        let status = mile.status ?? ""
                        if status != "Paid"{
                            self.allPaid = false
                        }else if status == "Paid"{
                            self.paidAmount += Double(mile.milestone_amount ?? "") ?? 0.00
                        }
                    }
                    print("paid amount \(self.paidAmount)")
                    
                    
                    let pendingString = resourceDetails.data.total_amount ?? "0"
                    let pendingFloat = (Float(pendingString) ?? 0.00) - Float(self.paidAmount) //substract total amount paid from pending amount
                    let pending = Int(pendingFloat)
                    self.pendingAmountLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(pending)"
                    
                    
                    
                    if !self.allPaid{
                        // Not all milestones paid so no need of job done button
                        self.tableView.snp.remakeConstraints { (make) in
                            make.top.equalTo(self.lineView2).offset(10)
                            make.leading.trailing.bottom.equalTo(self.view)
                        }
                        
                        self.submitButton.snp.remakeConstraints { (make) in
                            make.height.equalTo(0)
                            make.leading.trailing.bottom.equalTo(self.view).inset(15)
                        }
                        
                    }else{
                        
                        let rating = resourceDetails.data.rating ?? ""
                        let feedback = resourceDetails.data.feedback ?? ""
                        
                        if self.isContractAccepted{
                            self.submitButton.setTitle(NSLocalizedString("Job Done", comment: ""), for: .normal)
                            self.submitButton.addTarget(self, action: #selector(self.jobDoneButtonAction), for: .touchUpInside)
                            
                            self.tableView.snp.remakeConstraints { (make) in
                                make.top.equalTo(self.lineView2).offset(10)
                                make.leading.trailing.equalTo(self.view)
                                make.bottom.equalTo(self.view).offset(-55)
                            }
                            
                            self.submitButton.snp.remakeConstraints { (make) in
                                make.height.equalTo(44)
                                make.leading.trailing.bottom.equalTo(self.view).inset(15)
                            }
                        }
                        else if self.isJobDone && rating == "" && feedback == ""{
                            self.submitButton.setTitle(NSLocalizedString("Submit review", comment: ""), for: .normal)
                            self.submitButton.addTarget(self, action: #selector(self.submitReviewAction), for: .touchUpInside)
                            
                            self.tableView.snp.remakeConstraints { (make) in
                                make.top.equalTo(self.lineView2).offset(10)
                                make.leading.trailing.equalTo(self.view)
                                make.bottom.equalTo(self.view).offset(-55)
                            }
                            self.submitButton.snp.remakeConstraints { (make) in
                                make.height.equalTo(44)
                                make.leading.trailing.bottom.equalTo(self.view).inset(15)
                            }
                        }
                        else  {
                            self.review = feedback
                            self.sectionsCount = 2
                            self.submitButton.isHidden = true
                        }
                        
                    }
                    
                    self.tableView.reloadData()
                    
                    self.profileImageView.isHidden              = false
                    self.profileButton.isHidden                 = false
                    self.calendarIcon.isHidden                  = false
                    self.amountLabel.isHidden                   = false
                    self.pendingAmountLabel.isHidden            = false
                    self.viewContractButton.isHidden            = false
                    self.paymentMilestoneTitleLabel.isHidden    = false
                    self.amountTitleLabel.isHidden              = false
                    self.amountIcon.isHidden                    = false
                    self.pendingAmountTitleLabel.isHidden       = false
                    self.lineView.isHidden                      = false
                    self.lineView1.isHidden                     = false
                    self.lineView2.isHidden                     = false
                    
                } catch _ {
                    Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                }
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
            
        }
        
    }
    
    
    
    func loadUI(){
        
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFit
        self.view.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.leading.top.equalToSuperview().inset(15)
            make.width.height.equalTo(70)
        }
        profileImageView.layer.cornerRadius = 35.0
        profileImageView.clipsToBounds = true
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: "AvenirLTStd-Book", size: 13)
        nameLabel.textColor = UIColor.black
        self.view.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView).offset(07)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        budgetLabel = UILabel()
//        budgetLabel.text = "SAR 5000/Day"
        budgetLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        budgetLabel.textColor = Color.liteBlack
        self.view.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { (make) in
            make.top.equalTo(nameLabel.snp.bottom).offset(05)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
        }
        
        
        profileButton = UIButton()
        profileButton.setTitleColor(Color.red, for: .normal)
        profileButton.setTitle(NSLocalizedString("Go to profile  ", comment: ""), for: .normal)
        profileButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        let nextImage = UIImage(named: "next")//?.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
        profileButton.setImage(nextImage, for: .normal)
        profileButton.addTarget(self, action: #selector(self.viewProfileAction), for: .touchUpInside)
        profileButton.semanticContentAttribute = .forceRightToLeft
        self.view.addSubview(profileButton)
        
        profileButton.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(budgetLabel.snp.bottom).offset(05)
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            let nextImage = UIImage(named: "nextR")//?.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            profileButton.setImage(nextImage, for: .normal)
            profileButton.semanticContentAttribute = .forceLeftToRight
        }else{
            let nextImage = UIImage(named: "next")//?.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            profileButton.setImage(nextImage, for: .normal)
            profileButton.semanticContentAttribute = .forceRightToLeft
        }
        
        
        dateLabel = UILabel()
        dateLabel.font = UIFont(name: "AvenirLTStd-Light", size: 10)
        dateLabel.textColor = Color.gray
        self.view.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(profileImageView).offset(05)
            make.trailing.equalTo(self.view).offset(-15)
        }
        
        statusLabel = UILabel()
        statusLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            statusLabel.textAlignment = .left
        }else{
            statusLabel.textAlignment = .right
        }
        
        self.view.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(10)
            make.trailing.equalTo(self.view).offset(-15)
            make.leading.equalTo(budgetLabel.snp.trailing)
        }
        
        //MARK: Date range UI
        let calendarImage = UIImage(named: "calendar")//?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
        calendarIcon = UIImageView()
        calendarIcon.image = calendarImage
        calendarIcon.contentMode = .center
        self.view.addSubview(calendarIcon)
        
        calendarIcon.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView)
            make.top.equalTo(profileImageView.snp.bottom).offset(20)
            make.width.height.equalTo(25)
        }
        
        daysLabel = UILabel()
        daysLabel.textColor = Color.gray
        daysLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        self.view.addSubview(daysLabel)
        
        daysLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(calendarIcon.snp.trailing).offset(07)
            make.top.equalTo(calendarIcon).offset(-2)
        }
        
        dateRangeLabel = UILabel()
        dateRangeLabel.textColor = UIColor.black
        dateRangeLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        self.view.addSubview(dateRangeLabel)
        
        dateRangeLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(daysLabel)
            make.top.equalTo(daysLabel.snp.bottom)//.offset(05)
        }
        
        //MARK: Total amount UI
        
        amountTitleLabel = UILabel()
        amountTitleLabel.text = NSLocalizedString("Total Amount", comment: "")
        amountTitleLabel.textColor = Color.gray
        amountTitleLabel.font = UIFont(name: "AvenirLTStd-Light", size: 10)
        self.view.addSubview(amountTitleLabel)
        
        amountTitleLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-07)
            make.top.equalTo(daysLabel)
        }
        
        amountLabel = UILabel()
        amountLabel.textColor = UIColor.black
        amountLabel.font = UIFont(name: "Avenir Heavy", size: 10)
        self.view.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-07)
            make.top.equalTo(daysLabel.snp.bottom)//.offset(05)
        }
        
        let amountImage = UIImage(named: "total_amount-1")//?.sd_resizedImage(with: CGSize(width: 20, height: 20), scaleMode: .aspectFit)
        amountIcon = UIImageView()
        amountIcon.image = amountImage
        amountIcon.contentMode = .center
        self.view.addSubview(amountIcon)
        
        amountIcon.snp.makeConstraints { (make) in
            make.trailing.equalTo(amountLabel.snp.leading).offset(-10)
            make.centerY.equalTo(calendarIcon)
            make.width.height.equalTo(25)
        }
        
        let topView = UIView()
        topView.backgroundColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0)
        self.view.addSubview(topView)
        
        
        topView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view)
            make.bottom.equalTo(amountLabel.snp.bottom).offset(20)
        }
        
        self.view.sendSubviewToBack(topView)
        lineView = UIView()
        lineView.backgroundColor = UIColor.gray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(topView.snp.bottom)
            make.height.equalTo(0.25)
        }
        
        
        
        let contractIcon = UIImage(named: "saved_contract")//?.sd_resizedImage(with: CGSize(width: 22, height: 22), scaleMode: .aspectFit)
        viewContractButton = UIButton()
//        viewContractButton.backgroundColor = .green
        viewContractButton.setImage(contractIcon, for: .normal)
        viewContractButton.setTitleColor(UIColor.black, for: .normal)
        viewContractButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        viewContractButton.setTitle(NSLocalizedString("  View Contract", comment: ""), for: .normal)
        self.view.addSubview(viewContractButton)
        
        viewContractButton.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView)
            make.top.equalTo(topView.snp.bottom).offset(10)
        }
        
        lineView1 = UIView()
        lineView1.backgroundColor = UIColor.gray
        self.view.addSubview(lineView1)
        
        lineView1.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(viewContractButton.snp.bottom).offset(10)
            make.height.equalTo(0.25)
        }
        
        //MARK: Pending amount UI
        
        pendingAmountLabel = UILabel()
        pendingAmountLabel.textColor = Color.red
        pendingAmountLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        self.view.addSubview(pendingAmountLabel)
        
        pendingAmountLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-10)
            make.top.equalTo(lineView1).offset(15)
        }
        
        pendingAmountTitleLabel = UILabel()
        pendingAmountTitleLabel.text = NSLocalizedString("Pending Amount", comment: "")
        pendingAmountTitleLabel.textColor = Color.gray
        pendingAmountTitleLabel.font = UIFont(name: "AvenirLTStd-Light", size: 13)
        self.view.addSubview(pendingAmountTitleLabel)
        
        pendingAmountTitleLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).offset(-10)
            make.top.equalTo(pendingAmountLabel.snp.bottom).offset(5)
        }
                
        
        paymentMilestoneTitleLabel = UILabel()
        paymentMilestoneTitleLabel.text = NSLocalizedString("Payment Milestone", comment: "")
        paymentMilestoneTitleLabel.textColor = UIColor.black
        paymentMilestoneTitleLabel.font = UIFont(name: "Avenir Heavy", size: 14)
        self.view.addSubview(paymentMilestoneTitleLabel)
        
        paymentMilestoneTitleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView)
            make.top.equalTo(lineView1).offset(15)
        }
        
        paymentMilestonesLabel = UILabel()
        paymentMilestonesLabel.textColor = Color.gray
        paymentMilestonesLabel.font = UIFont(name: "AvenirLTStd-Light", size: 13)
        self.view.addSubview(paymentMilestonesLabel)
        
        paymentMilestonesLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView)
            make.top.equalTo(paymentMilestoneTitleLabel.snp.bottom).offset(5)
        }
        
        
        lineView2 = UIView()
        lineView2.backgroundColor = UIColor.gray
        self.view.addSubview(lineView2)
        
        lineView2.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(paymentMilestonesLabel.snp.bottom).offset(10)
            make.height.equalTo(0.25)
        }
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(ProviderMileStoneTVCell.self, forCellReuseIdentifier: "cell")
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell1")

        self.tableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.lineView2).offset(10)
            make.leading.trailing.bottom.equalTo(self.view)
        }

    
        
        submitButton = UIButton()
        submitButton.setTitle(NSLocalizedString("Job Done", comment: ""), for: .normal)
        submitButton.backgroundColor = Color.red
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.view.addSubview(submitButton)
        

        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
                
        self.submitButton.snp.remakeConstraints { (make) in
            make.height.equalTo(0)
            make.leading.trailing.bottom.equalTo(self.view).inset(15)
        }
        
    }
    
    @objc func submitReviewAction(){
        
        let vc = ReviewPopupViewController()
        vc.reviewDelegate = self
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func jobDoneButtonAction(){
        
        if self.isContractAccepted == false{
            return
        }
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_resource_id" : hire_resource_id ?? 0
        ]
        
        WebServices.postRequest(url: Url.jobDone, params: parameters, viewController: self) { success,data  in
            if success{
                self.loadResourceDetails()
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
        }
    }
    
    @objc func viewProfileAction(){
        self.tabBarController?.tabBar.isHidden = true
        let vc = ProfileDetailsViewController()
        vc.profileId = profileId
        vc.view.backgroundColor = .white
        self.navigationController?.pushViewController(vc, animated: true)
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

    }
    

}

extension ProviderMilestonesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1{
            return UITableView.automaticDimension
        }
        
        return 265
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return milestones.count
        }else{
            return 1

        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if indexPath.section == 1{
            let cell: UITableViewCell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "cell1")
            cell.selectionStyle = .none
            cell.textLabel?.text = "\n \(NSLocalizedString("My Review", comment: ""))"
            cell.detailTextLabel?.text = "  \(review)"
            
            cell.textLabel?.numberOfLines = 0
            cell.detailTextLabel?.numberOfLines = 0
            
            return cell
        }
        else{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProviderMileStoneTVCell
            cell.selectionStyle = .none
            
            let milestone = milestones[indexPath.row]
            cell.nameTextfield.text = milestone.title
            //        cell.amountTextfield.text = "SAR \(milestone.milestone_amount ?? "")"
            
            let amountString = milestone.milestone_amount ?? "0"
            let amountFloat = Float(amountString)
            let amount = Int(amountFloat ?? 0)
            cell.amountTextfield.text = "\(NSLocalizedString("SAR", comment: "")) \(amount)"
            
            cell.descriptionTextview.text = milestone.description
            
            //Milestone date
            let milestoneDate = milestone.milestone_date ?? ""
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let mileDate = dateFormatter.date(from: milestoneDate)
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = mileDate{
                let dateString = dateFormatter.string(from: date)
                cell.dateButton.setTitle(" \(dateString) ", for: .normal)
            }
            
            
            //Created date
            
            let createdDate = milestone.created_at ?? ""
            let createDateFormatter = DateFormatter()
            createDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            createDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let createdAtDate = createDateFormatter.date(from: createdDate)
            
            createDateFormatter.dateFormat = "dd MMM yyyy"
            createDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            var createdDateStr = ""
            if let date = createdAtDate{
                createdDateStr = createDateFormatter.string(from: date)
            }
            
            createDateFormatter.dateFormat = "HH:mm a"
            createDateFormatter.locale = Locale(identifier: "en_US_POSIX")
            var createdTimeStr = ""
            if let time = createdAtDate{
                createdTimeStr = createDateFormatter.string(from: time)
            }
            
            let status = NSLocalizedString(milestone.status ?? "", comment: "")
            cell.statusLabel.text = "  \(status)  "
            
            if status == NSLocalizedString("Paid", comment: ""){
                cell.statusLabel.backgroundColor = Color.green.withAlphaComponent(0.1)
                cell.statusLabel.textColor = Color.green
                cell.bgView.layer.borderColor = Color.green.cgColor
                cell.dotView.layer.borderColor = Color.green.cgColor
                cell.lineView.backgroundColor = Color.green
                cell.dateLabel.text = "\(createdDateStr) | \(createdTimeStr)"
                cell.dateLabel.isHidden = false
                cell.payButton.isHidden = true
            }
            else if status == NSLocalizedString("Waiting for confirmation", comment: ""){
                cell.statusLabel.backgroundColor   = Color.red.withAlphaComponent(0.1)
                cell.statusLabel.textColor         = Color.red
                cell.bgView.layer.borderColor      = Color.red.cgColor
                cell.dotView.layer.borderColor     = Color.red.cgColor
                cell.lineView.backgroundColor      = Color.red
                
                cell.payButton.removeTarget(nil, action: nil, for: .allEvents)

                if isContractAccepted{
                    cell.dateLabel.isHidden = true //"I Paid"
                    cell.payButton.isHidden = false
                    cell.payButton.backgroundColor = Color.green
                    cell.payButton.setTitle(NSLocalizedString("I Paid", comment: ""), for: .normal)
                    cell.payButton.addTarget(self, action: #selector(self.paidButtonAction), for: .touchUpInside)
                }else{
                    cell.dateLabel.isHidden = false
                    cell.payButton.isHidden = true
                    cell.dateLabel.text = "\(createdDateStr) | \(createdTimeStr)"
                }
            }
            else if status == NSLocalizedString("Pending", comment: ""){
                cell.statusLabel.backgroundColor = Color.red.withAlphaComponent(0.1)
                cell.statusLabel.textColor = Color.red
                cell.bgView.layer.borderColor = Color.red.cgColor
                cell.dotView.layer.borderColor = Color.red.cgColor
                cell.lineView.backgroundColor = Color.red
                if isContractAccepted{
                    cell.dateLabel.isHidden = true // = "Pay"
                    cell.payButton.isHidden = false
                    cell.payButton.backgroundColor = Color.red
                    cell.payButton.tag = indexPath.row
                    cell.payButton.addTarget(self, action: #selector(self.payButtonAction), for: .touchUpInside)
                }else{
                    cell.dateLabel.isHidden = false
                    cell.payButton.isHidden = true
                    cell.dateLabel.text = "\(createdDateStr) | \(createdTimeStr)"
                }
            }
            
            return cell
        }
    }
    
    @objc func paidButtonAction(){
        print("paid button action")
    }
    
    @objc func payButtonAction(_ sender:UIButton){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "contract_milestone_id" : milestones[sender.tag].id ?? 0
        ]
        
        WebServices.postRequest(url: Url.releasePayment, params: parameters, viewController: self) { success,data  in
            if success{
                self.loadResourceDetails()
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
        }
        
    }
    
}

class ProviderMileStoneTVCell : UITableViewCell {
    
    var bgView              : UIView!
    var dotView             : UIView!
    var lineView            : UIView!
    var addImageView        : UIImageView!
    var milestoneLabel      : UILabel!
    var statusBGView        : UIView!
    var nameTextfield       : UITextField!
    var amountTextfield     : UITextField!
    var descriptionTextview : UITextView!
    var dateButton          : UIButton!
    var statusLabel         : UILabel!
    var dateLabel           : UILabel!
    var payButton           : UIButton!


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(230)
            make.leading.equalTo(self.contentView).offset(35)
            make.trailing.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(15)
        }
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true

        statusBGView = UIView()
        statusBGView.backgroundColor = .white
        self.contentView.addSubview(statusBGView)
        
        statusBGView.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(25)
            make.top.equalTo(bgView).offset(-10)
            make.height.equalTo(25)
        }
        statusBGView.layer.cornerRadius = 10.0
        statusBGView.clipsToBounds = true
        
        
        statusLabel = UILabel()
        statusLabel.text = NSLocalizedString("  Status    ", comment: "")
        statusLabel.font = UIFont(name: "AvenirLTStd-Light", size: 13)
        statusLabel.textAlignment = .center
        statusLabel.backgroundColor = .white
        statusBGView.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        statusLabel.layer.cornerRadius = 10.0
        statusLabel.clipsToBounds = true
        
        self.contentView.bringSubviewToFront(statusBGView)
        
        nameTextfield = UITextField()
        nameTextfield.isUserInteractionEnabled = false
        nameTextfield.placeholder = NSLocalizedString("Milestone Name", comment: "")
        nameTextfield.font = UIFont(name: "AvenirLTStd-Light", size: 16)
        bgView.addSubview(nameTextfield)
        
        nameTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(10)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(40)
        }
        
        nameTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        nameTextfield.leftViewMode = .always
        
        nameTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        nameTextfield.rightViewMode = .always
        
        
        let nameLineView = UIView()
        nameLineView.backgroundColor = .lightGray
        bgView.addSubview(nameLineView)

        nameLineView.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextfield.snp.bottom).offset(2)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(0.5)
        }

        
        amountTextfield = UITextField()
        amountTextfield.isUserInteractionEnabled = false
        amountTextfield.font = UIFont(name: "Avenir Heavy", size: 14)
        amountTextfield.placeholder = NSLocalizedString("Enter Amount", comment: "")
        bgView.addSubview(amountTextfield)
        
        amountTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(nameLineView.snp.bottom)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(40)
        }
        
        amountTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        amountTextfield.leftViewMode = .always
        amountTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        amountTextfield.rightViewMode = .always
        
        
 

        let amountLineView = UIView()
        amountLineView.backgroundColor = .lightGray
        bgView.addSubview(amountLineView)

        amountLineView.snp.makeConstraints { (make) in
            make.top.equalTo(amountTextfield.snp.bottom).offset(2)
            make.leading.trailing.equalTo(amountTextfield)
            make.height.equalTo(0.5)
        }
        
        
        descriptionTextview = UITextView()
        descriptionTextview.isUserInteractionEnabled = false
        descriptionTextview.textColor = Color.liteBlack
        descriptionTextview.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        descriptionTextview.text = NSLocalizedString("Enter description", comment: "")
        bgView.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(bgView).inset(15)
            make.trailing.equalTo(bgView)
            make.top.equalTo(amountLineView.snp.bottom).offset(2)
            make.height.equalTo(75)
        }

        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            nameTextfield.textAlignment = .right
            amountTextfield.textAlignment = .right
            descriptionTextview.textAlignment = .right
        }else{
            nameTextfield.textAlignment = .left
            amountTextfield.textAlignment = .left
            descriptionTextview.textAlignment = .left
        }
        let descLineView = UIView()
        descLineView.backgroundColor = .lightGray
        bgView.addSubview(descLineView)

        descLineView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextview.snp.bottom).offset(2)
            make.leading.trailing.equalTo(amountTextfield)
            make.height.equalTo(0.5)
        }
        
        dotView = UIView()
        self.contentView.addSubview(dotView)

        dotView.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView.snp.leading).offset(-15)
            make.top.equalTo(bgView)
            make.width.height.equalTo(14)
        }
        dotView.layer.cornerRadius = 7.0
        dotView.clipsToBounds = true
        dotView.layer.borderWidth = 1.0
        dotView.layer.borderColor = UIColor.lightGray.cgColor


        lineView = UIView()
        lineView.backgroundColor = .lightGray
        self.contentView.addSubview(lineView)

        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(dotView.snp.bottom).offset(2)
            make.centerX.equalTo(dotView)
            make.height.equalTo(240)
            make.width.equalTo(1)
        }
        
        let calendarIcon = UIImage(named: "calendar")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        dateButton = UIButton()
        dateButton.setImage(calendarIcon, for: .normal)
        dateButton.backgroundColor = Color.liteWhite
        dateButton.setTitleColor(Color.liteBlack, for: .normal)
        dateButton.setTitle(NSLocalizedString("  Start Date  ", comment: ""), for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "Avenir Heavy", size: 12.0)
        bgView.addSubview(dateButton)
        
        dateButton.snp.makeConstraints { (make) in
            make.top.leading.equalTo(descLineView).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        dateButton.layer.cornerRadius = 5.0
        dateButton.clipsToBounds = true
        
        
        dateLabel = UILabel()
        dateLabel.textColor = Color.liteBlack
        dateLabel.textAlignment = .right
        dateLabel.font = UIFont(name: "AvenirLTStd-Light", size: 12)
        bgView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.centerY.equalTo(dateButton)
        }
        
        
        payButton = UIButton()
        payButton.setTitleColor(UIColor.white, for: .normal)
        payButton.setTitle(NSLocalizedString("Pay", comment: ""), for: .normal)
        payButton.titleLabel?.font = UIFont(name: "Avenir Heavy", size: 12.0)
        bgView.addSubview(payButton)
        
        payButton.snp.makeConstraints { (make) in
            make.trailing.equalToSuperview().offset(-10)
            make.height.equalTo(dateButton)
            make.width.equalTo(100)
            make.centerY.equalTo(dateButton)
        }
        payButton.layer.cornerRadius = 5.0
        payButton.clipsToBounds = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


protocol ReviewProtocol {
    func submitReview(rating:String, feedback : String)
}

extension ProviderMilestonesViewController : ReviewProtocol{
    func submitReview(rating: String, feedback: String) {
        print("rating \(rating) feedback \(feedback)")
        
        let parameters: [String: Any] = [
            
            "current_version"  : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale"           : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id"        : UIDevice.current.identifierForVendor!.uuidString,
            "device_type"      : "ios",
            "hire_resource_id" : hire_resource_id ?? 0,
            "rating"           : rating,
            "feedback"         : feedback
        ]
        
        WebServices.postRequest(url: Url.submitReview, params: parameters, viewController: self) { success,data  in
            if success{
                self.loadResourceDetails()
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
        }
    }
    
}
