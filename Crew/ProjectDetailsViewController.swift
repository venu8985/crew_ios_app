//
//  ProjectDetailsViewController.swift
//  Crew
//
//  Created by Rajeev on 13/04/21.
//

import UIKit

class ProjectDetailsViewController: UIViewController {
    
    var projectNameTextfield : FloatingTextfield!
    var descriptionTextView : UITextView!
    var startLabel     : UILabel!
    var stopLabel      : UILabel!
    var budgetLabel    : UILabel!
    var locationButton : UIButton!
    var tableView      : UITableView!
    var requestLabel   : UILabel!
    var agencies       = [HiredAgencies]()
    var scrollView : UIScrollView!
    var findAgencyImageView : UIImageView!
    var findAgencyLabel : UILabel!
    var findLineView : UIView!
    var findAgenciesButton : UIButton!
    var dateTimelineButton : UIButton!
    var projectBudgetButton : UIButton!
    var lineView : UIView!
    var startButton : UIButton!
    var stopButton : UIButton!
    var lineView1 : UIView!
    var lineView3 : UIView!
    var descriptionLabel : UILabel!
    var editButton : UIButton!
    var dotsButton : UIButton!
    var projectDetails : ProjectDetailsData!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        fetchProjectDetails()
        navigationBarItems()
        

        
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        
        
        let editImage = UIImage(named: "edit")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        editButton = UIButton()
        editButton.setImage(editImage, for: .normal)
        editButton.addTarget(self, action: #selector(self.editAction), for: .touchUpInside)
        scrollView.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.top.equalTo(scrollView).offset(15)
            make.trailing.equalTo(self.view).offset(-10)
            make.width.height.equalTo(44)
        }
        
        //edit
        projectNameTextfield = FloatingTextfield()
        projectNameTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 08)
        projectNameTextfield.placeholder = NSLocalizedString("Project Name", comment: "")
        projectNameTextfield.backgroundColor = .white
        projectNameTextfield.leftPadding = 10
        projectNameTextfield.rightPadding = 10
        projectNameTextfield.isUserInteractionEnabled = false
        projectNameTextfield.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(projectNameTextfield)
        
        projectNameTextfield.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(20)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
            make.top.equalTo(scrollView).offset(15)
            make.height.equalTo(46)
        }
        
       
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            projectNameTextfield.textAlignment = .right
            projectNameTextfield.titleLabel.textAlignment = .right
        }else{
            projectNameTextfield.textAlignment = .left
            projectNameTextfield.titleLabel.textAlignment = .left
        }
        
        
        projectNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        projectNameTextfield.layer.cornerRadius = 5.0
        projectNameTextfield.layer.borderWidth = 0
        projectNameTextfield.clipsToBounds = true
        
        lineView = UIView()
        lineView.frame = CGRect(x: 20, y: 60, width: self.view.frame.size.width-40, height: 0.25)
        scrollView.addSubview(lineView)
        drawDottedLine(start: CGPoint(x: lineView.bounds.minX, y: lineView.bounds.minY), end: CGPoint(x: lineView.bounds.maxX, y: lineView.bounds.minY), view: lineView)
        
        
        descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("Description", comment: "")
        descriptionLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        descriptionLabel.textColor = Color.gray
        scrollView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView)
            make.top.equalTo(lineView.snp.bottom).offset(15)
        }
        

        descriptionTextView = UITextView()
        descriptionTextView.textColor = Color.liteBlack
        descriptionTextView.textAlignment = .left
        descriptionTextView.isScrollEnabled = false
        descriptionTextView.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            descriptionTextView.textAlignment = .right
        }
        scrollView.addSubview(descriptionTextView)
        
        descriptionTextView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView).inset(-5)
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.height.lessThanOrEqualTo(150)
        }

        let dateImage = UIImage(named: "date_timeline")
            //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)

        dateTimelineButton = UIButton()
        dateTimelineButton.setTitleColor(UIColor.red, for: .normal)
        dateTimelineButton.setTitle(NSLocalizedString("  Dates / Timeline ", comment: ""), for: .normal)
        dateTimelineButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        dateTimelineButton.setImage(dateImage, for: .normal)
        dateTimelineButton.isUserInteractionEnabled = false
        scrollView.addSubview(dateTimelineButton)
        
        dateTimelineButton.snp.makeConstraints { (make) in
            make.leading.equalTo(descriptionTextView).offset(5)
            make.top.equalTo(descriptionTextView.snp.bottom).offset(15)
            
        }
        
        
        startButton = StartStopButton()
        startButton.isUserInteractionEnabled = false
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        startButton.setTitle(NSLocalizedString("Start   ", comment: ""), for: .normal)
        scrollView.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-14)
            make.top.equalTo(dateTimelineButton.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
//        startButton.imageEdgeInsets = UIEdgeInsets(top: 04, left: 30, bottom: 04, right: 36)
        
        
        stopButton = StartStopButton()
        stopButton.isUserInteractionEnabled = false
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        stopButton.setTitle(NSLocalizedString("Stop    ", comment: ""), for: .normal)
        scrollView.addSubview(stopButton)
        
        stopButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-14)
            make.top.equalTo(startButton.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
//        stopButton.imageEdgeInsets = UIEdgeInsets(top: 05, left: 31, bottom: 03, right: 35);
        
        
        lineView1 = UIView()
        lineView1.backgroundColor = .lightGray
        scrollView.addSubview(lineView1)
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(startButton.snp.bottom).inset(5)
                make.bottom.equalTo(stopButton.snp.top).offset(5)
                make.leading.equalTo(startButton).inset(20)
                make.width.equalTo(1)
            }
        }else{
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(startButton.snp.bottom).inset(5)
                make.bottom.equalTo(stopButton.snp.top).offset(5)
                make.trailing.equalTo(startButton).inset(20)
                make.width.equalTo(1)
            }
        }
        
        
        
        
        startLabel = UILabel()
        startLabel.font = UIFont.boldSystemFont(ofSize: 12)
            
        scrollView.addSubview(startLabel)
        
        startLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startButton)
            make.leading.equalTo(startButton.snp.trailing).offset(-10)
        }
        
        
        stopLabel = UILabel()
        stopLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scrollView.addSubview(stopLabel)
        
        stopLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stopButton)
            make.leading.equalTo(stopButton.snp.trailing).offset(-10)
        }
        
        
        
        budgetLabel = UILabel()
        budgetLabel.font = UIFont.boldSystemFont(ofSize: 12)
        scrollView.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLabel)
            make.leading.equalTo(startLabel.snp.trailing).offset(60)
        }
        
        
        let budgetImage = UIImage(named: "project_budget")
            //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)

        projectBudgetButton = UIButton()
        projectBudgetButton.setTitleColor(UIColor.red, for: .normal)
        projectBudgetButton.setTitle(NSLocalizedString("  \(NSLocalizedString("Project Budget", comment: "")) ", comment: ""), for: .normal)
        projectBudgetButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        projectBudgetButton.setImage(budgetImage, for: .normal)
        projectBudgetButton.isUserInteractionEnabled = false
        scrollView.addSubview(projectBudgetButton)
        
        projectBudgetButton.snp.makeConstraints { (make) in
            make.leading.equalTo(budgetLabel).offset(-10)
            make.top.equalTo(dateTimelineButton)
            
        }

        
        lineView3 = UIView()
        lineView3.backgroundColor = Color.gray
        scrollView.addSubview(lineView3)
        
        lineView3.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton)
            make.trailing.equalTo(lineView)
            make.top.equalTo(stopButton.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        //location_1
//        let location
        let locationImage = UIImage(named: "location_2")
            //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        locationButton = UIButton()
        locationButton.setTitleColor(Color.gray, for: .normal)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        locationButton.setImage(locationImage, for: .normal)
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            locationButton.contentHorizontalAlignment = .right
        }else{
            locationButton.contentHorizontalAlignment = .left
        }
//        locationButton.semanticContentAttribute = .forceRightToLeft
        scrollView.addSubview(locationButton)
        
        locationButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView3)
            make.top.equalTo(lineView3.snp.bottom).offset(10)
        }

        
        requestLabel = UILabel()
        requestLabel.font = UIFont.boldSystemFont(ofSize: 12)
        requestLabel.text = NSLocalizedString("Requested to agencies", comment: "")
        scrollView.addSubview(requestLabel)
        
        requestLabel.snp.makeConstraints { (make) in
            make.top.equalTo(locationButton.snp.bottom).offset(20)
            make.leading.equalTo(locationButton).offset(-5)
        }
        
        
   
        
        findAgenciesButton = UIButton()
        findAgenciesButton.setTitle(NSLocalizedString(" Find Agencies", comment: ""), for: .normal)
        findAgenciesButton.backgroundColor = Color.red
        findAgenciesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        findAgenciesButton.addTarget(self, action: #selector(self.findAgenciesButtonAction), for: .touchUpInside)
        self.view.addSubview(findAgenciesButton)

        findAgenciesButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(25)
        }

        findAgenciesButton.layer.cornerRadius = 5.0
        findAgenciesButton.clipsToBounds = true


        findLineView = UIView()
        findLineView.backgroundColor = Color.liteGray
        self.view.addSubview(findLineView)

        findLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(findAgenciesButton.snp.top).offset(-10)
        }
        
        findAgencyImageView = UIImageView()
        findAgencyImageView.image =  UIImage(named: "agencies")
        findAgencyImageView.contentMode = .scaleAspectFit
        scrollView.addSubview(findAgencyImageView)

        findAgencyImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.centerX.equalTo(scrollView)
            make.top.equalTo(requestLabel.snp.bottom).offset(100)
            make.height.equalTo(150)
        }
        
        findAgencyLabel = UILabel()
        findAgencyLabel.font = UIFont.systemFont(ofSize: 12)
        findAgencyLabel.text = NSLocalizedString("You didn't requested any agencies", comment: "")
        scrollView.addSubview(findAgencyLabel)
        
        findAgencyLabel.snp.makeConstraints { (make) in
            make.top.equalTo(findAgencyImageView.snp.bottom).offset(10)
            make.centerX.equalTo(findAgencyImageView)
        }

        
        projectNameTextfield.isHidden    = true
        descriptionTextView.isHidden     = true
        startLabel.isHidden              = true
        stopLabel.isHidden               = true
        budgetLabel.isHidden             = true
        locationButton.isHidden          = true
        requestLabel.isHidden            = true
        findAgencyLabel.isHidden         = true
        findAgencyImageView.isHidden     = true
        findLineView.isHidden            = true
        findAgenciesButton.isHidden      = true
        lineView.isHidden                = true
        dateTimelineButton.isHidden      = true
        projectBudgetButton.isHidden     = true
        lineView.isHidden                = true
        startButton.isHidden             = true
        stopButton.isHidden              = true
        lineView1.isHidden               = true
        lineView3.isHidden               = true
        descriptionLabel.isHidden        = true
        editButton.isHidden              = true
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        scrollView.addSubview(tableView)
        tableView.register(AgencyProjectTVCell.self, forCellReuseIdentifier: "cell")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProjectAction), name: Notification.updateProject, object: nil)

    }
    
    @objc func updateProjectAction(){
        fetchProjectDetails()
    }
    
    @objc func editAction(){
        
        let vc = CreateProjectViewController()
        vc.editProject = true
        vc.projectName = projectDetails.name
        vc.projectDesc = projectDetails.description
        vc.startDateStr = projectDetails.start_at
        vc.endDateStr = projectDetails.end_at
        vc.budget = projectDetails.budget
        vc.projectId = projectDetails.id
        vc.cityId = projectDetails.city_id
        vc.countryId = projectDetails.country_id
        vc.countryString = projectDetails.country_name
        vc.cityString = projectDetails.city_name
        vc.isAgency = (Profile.shared.details?.is_agency=="Yes") ? true : false
        vc.isCompany = (Profile.shared.details?.is_company=="Yes") ? true : false
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func findAgenciesButtonAction(){
//        let project = projects[sender.tag]
//        CreateContract.shared.project_id = project.id
//        self.tabBarController?.tabBar.isHidden = true
        let vc = AgenciesViewController()
        self.navigationController?.pushViewController(vc, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    func fetchProjectDetails(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "project_id"  : CreateContract.shared.project_id ?? 0
        ]
        
        WebServices.postRequest(url: Url.projectDetails, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let projectDetails = try decoder.decode(ProjectDetails.self, from: data)
                
                DispatchQueue.main.async {
                    if let project = projectDetails.data {
                        self.projectDetails = project
                        self.title = project.name
                        self.projectNameTextfield.text = project.name
                        self.descriptionTextView.text = project.description
                        let location = "  \(project.city_name ?? ""),\(project.country_name ?? "")"
                        self.locationButton.setTitle(location, for: .normal)
                        
                        let budgetString = project.budget ?? "0"
                        let budgetFloat = Float(budgetString)
                        let budget = Int(budgetFloat ?? 0)
                        self.budgetLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(budget)"
                        
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
                        dateFormatter.dateFormat = "yyyy-MM-dd"
                        let startDate = dateFormatter.date(from: project.start_at ?? "")
                        let endDate = dateFormatter.date(from: project.end_at )

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
                        self.agencies = project.hireAgency
                        
                        self.projectNameTextfield.isHidden = false
                        self.descriptionTextView.isHidden = false
                        self.startLabel.isHidden = false
                        self.stopLabel.isHidden = false
                        self.budgetLabel.isHidden = false
                        self.locationButton.isHidden = false
                        self.requestLabel.isHidden = false
                        self.lineView.isHidden = false
                        self.dateTimelineButton.isHidden = false
                        self.projectBudgetButton.isHidden = false
                        self.lineView.isHidden = false
                        self.startButton.isHidden = false
                        self.stopButton.isHidden = false
                        self.descriptionLabel.isHidden = false
                        self.lineView1.isHidden = false
                        self.lineView3.isHidden = false
                        self.editButton.isHidden = false
                        if self.agencies.count>0{
                            self.tableView.isHidden = false
                            self.tableView.reloadData()
                            
                            self.findAgencyLabel.isHidden = true
                            self.findAgencyImageView.isHidden = true
                            self.findLineView.isHidden = true

                        }else{
                            self.tableView.isHidden = true
                            
                            self.findAgencyLabel.isHidden = false
                            self.findAgencyImageView.isHidden = false
                            self.findLineView.isHidden = false
                        }
                        
                        if project.status == "Ongoing"{
                            self.findLineView.isHidden = false
                            self.findAgenciesButton.isHidden = false
                        }else{
                            self.findLineView.isHidden = true
                            self.findAgenciesButton.isHidden = true
                        }
                        
                        self.tableView.snp.makeConstraints { (make) in
                            make.leading.trailing.equalTo(self.view).offset(20)
                            make.height.equalTo((self.agencies.count*120)+55)
                            make.top.equalTo(self.requestLabel.snp.bottom)
                        }
                        let agenciesHeight = CGFloat((self.agencies.count*100)+407+55)
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: agenciesHeight)
                    }
                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }
    
    func navigationBarItems() {
        //Left bar button item
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
        
        //Right bar button item
        let containView1 = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        dotsButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        dotsButton.setImage(UIImage(named: "3dots"), for: .normal)
        dotsButton.contentMode = UIView.ContentMode.scaleAspectFit
        dotsButton.clipsToBounds = true
        containView1.addSubview(dotsButton)
        dotsButton.addTarget(self, action:#selector(self.dotsAction), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: containView1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);
            dotsButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);

        }else{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
            dotsButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);

        }
        
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func dotsAction(){
        
        let alertController = UIAlertController(title: nil, message: nil , preferredStyle: UIAlertController.Style.actionSheet)
        let gallertyAction = UIAlertAction(title: NSLocalizedString("Cancel Project", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.cancelProject()
        }
        let docAction = UIAlertAction(title: NSLocalizedString("Complete Project", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
            self.completeProject()
        }
        let cancelAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.cancel) {
            (result : UIAlertAction) -> Void in
        }
        alertController.addAction(gallertyAction)
        alertController.addAction(docAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    
    
    func completeProject(){

        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "project_id"  : CreateContract.shared.project_id ?? 0
        ]
        
        WebServices.postRequest(url: Url.completeProject, params: parameters, viewController: self) { success,data  in
            if success{
                Banner().displaySuccess(string: "Project succesfully completed")
                self.fetchProjectDetails()
                NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                self.editButton.isHidden = true
                self.dotsButton.isHidden = true
            }else{
                Banner().displayValidationError(string: "Error")
            }
        }
            
    }

    func cancelProject(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "project_id"  : CreateContract.shared.project_id ?? 0
        ]
        
        WebServices.postRequest(url: Url.cancelProject, params: parameters, viewController: self) { success,data  in
            if success{
                Banner().displaySuccess(string: "Project cancelled")
                self.fetchProjectDetails()
                NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                self.editButton.isHidden = true
                self.dotsButton.isHidden = true
            }else{
                Banner().displayValidationError(string: "Error")
            }
        }
    }


}

extension ProjectDetailsViewController : UITableViewDataSource, UITableViewDelegate{

    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let agency = agencies[indexPath.row]
        
        if agency.contracts != nil{
            return 100
        }
        else if agency.status == "Pending" || agency.status == "Rejected"{
            return 70
        }
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return agencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let agency = agencies[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")  as! AgencyProjectTVCell
        cell.selectionStyle = .none
        
        let profilePicurl = Url.userProfile + (agency.profile_image ?? "")
        cell.profileImageView.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
//        cell?.textLabel?.text = agency.namee
        
        
        if agency.contracts != nil{
            cell.statusLabel.textColor = Color.green
            cell.viewProposalButton.isHidden = false
            cell.button2.isHidden = false
            
            cell.viewProposalButton.tag = indexPath.row
            cell.viewProposalButton.addTarget(self, action: #selector(self.viewProposalButtonAction), for: .touchUpInside)
            
            cell.button2.tag = indexPath.row
            cell.button2.setTitle(" \(NSLocalizedString("View Contract", comment: "")) ", for: .normal)
            cell.button2.addTarget(self, action: #selector(self.viewContractAction), for: .touchUpInside)
            let eye2Image = UIImage(named: "eye_black")
                //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            cell.button2.setImage(eye2Image, for: .normal)
        }
        else if agency.status == "Pending" || agency.status == "Rejected"{
            cell.statusLabel.textColor = Color.red
            cell.viewProposalButton.isHidden = true
            cell.button2.isHidden = true
             
            cell.viewProposalButton.tag = indexPath.row
            cell.viewProposalButton.addTarget(self, action: #selector(self.viewProposalButtonAction), for: .touchUpInside)
            
        }else if agency.status == "Proposal Generated"{
            cell.statusLabel.textColor = Color.green
            cell.viewProposalButton.isHidden = false
            cell.button2.isHidden = false
            
            cell.viewProposalButton.tag = indexPath.row
            cell.viewProposalButton.addTarget(self, action: #selector(self.viewProposalButtonAction), for: .touchUpInside)
            
            cell.button2.tag = indexPath.row
            cell.button2.addTarget(self, action: #selector(self.awardButtonAction), for: .touchUpInside)

        }
        else if agency.status == "Awarded"{
            cell.statusLabel.textColor = Color.green
            cell.viewProposalButton.isHidden = false
            cell.button2.isHidden = false
            
            cell.viewProposalButton.tag = indexPath.row
            cell.viewProposalButton.addTarget(self, action: #selector(self.viewProposalButtonAction), for: .touchUpInside)
            
            cell.button2.removeTarget(nil, action: nil, for: .allEvents)
            cell.button2.tag = indexPath.row
            cell.button2.setTitle(" \(NSLocalizedString("Create contract", comment: "")) ", for: .normal)
            cell.button2.addTarget(self, action: #selector(self.createContractAction), for: .touchUpInside)
            cell.button2.backgroundColor = Color.red.withAlphaComponent(0.10)
            cell.button2.setTitleColor(Color.red, for: .normal)
            let button2Image = UIImage(named: "create_contract")
                //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            cell.button2.setImage(button2Image, for: .normal)
        }
                

        cell.statusLabel.text = NSLocalizedString(agency.status ?? "", comment: "")
        cell.nameLabel.text = agency.name
                
        return cell
        
    }
    

    
    //MARK: Button actions
    
    @objc func viewContractAction(){
        
    }
    
    @objc func createContractAction(_ sender : UIButton){
        
        let vc = CompanyCreateContractViewController()
        vc.agencyId = agencies[sender.tag].id
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func viewProposalButtonAction(_ sender : UIButton){
        let proposal = agencies[sender.tag].proposals

        var hideAwardButton = true
        if agencies[sender.tag].status == "Proposal Generated"{
            hideAwardButton = false
        }
        
        let vc = ProposalViewController()
        vc.descString = proposal?.description
        vc.image = proposal?.proposal_file
        vc.agencyId = agencies[sender.tag].id
        vc.hideAwardButton = hideAwardButton
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @objc func awardButtonAction(_ sender : UIButton){

        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "hire_agency_id"  : agencies[sender.tag].id ?? ""
        ]
        
        WebServices.postRequest(url: Url.award, params: parameters, viewController: self) { success,data  in
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Succesfully awarded", comment: ""))
                self.fetchProjectDetails()
            }else{
                Banner().displayValidationError(string: "Error")
            }
        }
            
    }
}


class AgencyProjectTVCell : UITableViewCell{
    
    var profileImageView : UIImageView!
    var statusLabel : UILabel!
    var nameLabel : UILabel!
    var viewProposalButton : UIButton!
    var button2 : UIButton! // for Award, Create Contract, View contract

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(10)
            make.width.height.equalTo(50)
        }
        profileImageView.layer.cornerRadius = 25
        profileImageView.clipsToBounds = true
        
        statusLabel = UILabel()
        statusLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        self.contentView.addSubview(statusLabel)

        statusLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalTo(profileImageView)
        }
        
        nameLabel = UILabel()
        nameLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        self.contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(statusLabel)
            make.top.equalTo(statusLabel.snp.bottom)
            make.height.equalTo(20)
        }
        
        
        let locationImage = UIImage(named: "eye_black")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        viewProposalButton = UIButton()
        viewProposalButton.setTitle(" \(NSLocalizedString("View proposal", comment: "")) ", for: .normal)
        viewProposalButton.setTitleColor(.black, for: .normal)
        viewProposalButton.backgroundColor = Color.liteGray
        viewProposalButton.setImage(locationImage, for: .normal)
        viewProposalButton.contentHorizontalAlignment = .left
        self.contentView.addSubview(viewProposalButton)
        viewProposalButton.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12)

        viewProposalButton.snp.makeConstraints { (make) in
            make.leading.equalTo(nameLabel)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
//        viewProposalButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 05, bottom: 0, right: 15);
        viewProposalButton.layer.cornerRadius = 5.0
        viewProposalButton.clipsToBounds = true
        viewProposalButton.contentHorizontalAlignment = .center
        
        
        let button2Image = UIImage(named: "award")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        button2 = UIButton()
        button2.setTitle(" \(NSLocalizedString("Award", comment: "")) ", for: .normal)
        button2.setTitleColor(.black, for: .normal)
        button2.backgroundColor = Color.liteGray
        button2.setImage(button2Image, for: .normal)
        button2.contentHorizontalAlignment = .left
        self.contentView.addSubview(button2)
        button2.titleLabel!.font = UIFont.boldSystemFont(ofSize: 12)

        button2.snp.makeConstraints { (make) in
            make.leading.equalTo(viewProposalButton.snp.trailing).offset(15)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
//        button2.imageEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
        button2.layer.cornerRadius = 5.0
        button2.clipsToBounds = true
        button2.contentHorizontalAlignment = .center
        
        
        
        let bottomLineView = UIView()
        bottomLineView.backgroundColor = Color.liteGray
        self.contentView.addSubview(bottomLineView)
        
        bottomLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(self.contentView).offset(-1)
            make.height.equalTo(0.5)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
