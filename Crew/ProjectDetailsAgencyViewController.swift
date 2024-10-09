//
//  ProjectDetailsAgencyViewController.swift
//  Crew
//
//  Created by Rajeev on 16/04/21.
//

import UIKit

class ProjectDetailsAgencyViewController: UIViewController {
    
    var projectNameTextfield : FloatingTextfield!
    var statusLabel     : UILabel!
    var startLabel     : UILabel!
    var stopLabel      : UILabel!
    var budgetLabel    : UILabel!
    var tableView      : UITableView!
    var resourceLabel   : UILabel!
//    var agencies       = [HiredAgencies]()
    var scrollView : UIScrollView!
    var findLineView : UIView!
    var auditionReqButton : UIButton!
    var hireResourceButton : UIButton!
    var notifyAuditionButton : UIButton!
    var dateTimelineButton : UIButton!
    var editProjectButton : UIButton!
    var shootingPlanButton : UIButton!
    var projectBudgetButton : UIButton!
    var lineView : UIView!
    var startButton : UIButton!
    var stopButton : UIButton!
    var lineView1 : UIView!
    var lineView3 : UIView!
    var resources = [ResourcesData]()
    var auditions = [Audtions]()
    var project : ProjectDetailsData!
    var dotsButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationBarItems()
        self.view.backgroundColor = .white
        self.title = NSLocalizedString("Project Details", comment: "")
        
        fetchProjectDetails()
        
        
        
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.view)
        }
        

        projectNameTextfield = FloatingTextfield()
        projectNameTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 08)
        projectNameTextfield.placeholder = NSLocalizedString("Project Name", comment: "")
        projectNameTextfield.backgroundColor = .white
        projectNameTextfield.leftPadding = 10
        projectNameTextfield.rightPadding = 10
        projectNameTextfield.keyboardType = .numberPad
        projectNameTextfield.font = UIFont.systemFont(ofSize: 14.0)
        projectNameTextfield.isUserInteractionEnabled = false
        scrollView.addSubview(projectNameTextfield)
        
        projectNameTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(scrollView).offset(15)
            make.height.equalTo(46)
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            projectNameTextfield.titleLabel.textAlignment = .right
            projectNameTextfield.textAlignment = .right
        }
        
        
        projectNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        projectNameTextfield.layer.cornerRadius = 5.0
        projectNameTextfield.layer.borderWidth = 0
        projectNameTextfield.clipsToBounds = true
        
        statusLabel = UILabel()
        statusLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        statusLabel.textAlignment = .right
        statusLabel.textColor = Color.red
        scrollView.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(projectNameTextfield)
            make.trailing.equalTo(projectNameTextfield).offset(-10)
        }
        self.view.bringSubviewToFront(statusLabel)
        
        lineView = UIView()
        lineView.frame = CGRect(x: 20, y: 60, width: self.view.frame.size.width-40, height: 0.25)
        scrollView.addSubview(lineView)
        drawDottedLine(start: CGPoint(x: lineView.bounds.minX, y: lineView.bounds.minY), end: CGPoint(x: lineView.bounds.maxX, y: lineView.bounds.minY), view: lineView)
    

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
            make.leading.equalTo(lineView).offset(5)
            make.top.equalTo(lineView.snp.bottom).offset(15)
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
        projectBudgetButton.setTitle(NSLocalizedString("  Project Budget ", comment: ""), for: .normal)
        projectBudgetButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        projectBudgetButton.setImage(budgetImage, for: .normal)
        projectBudgetButton.isUserInteractionEnabled = false
        scrollView.addSubview(projectBudgetButton)
        
        projectBudgetButton.snp.makeConstraints { (make) in
            make.leading.equalTo(budgetLabel).offset(-10)
            make.top.equalTo(dateTimelineButton)
            
        }
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            shootingPlanButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            projectBudgetButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        let editImage = UIImage(named: "edit-2")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        editProjectButton = UIButton()
        editProjectButton.setImage(editImage, for: .normal)
        editProjectButton.setTitle(NSLocalizedString("Edit Project", comment: ""), for: .normal)
        editProjectButton.addTarget(self, action: #selector(self.editProjectAction), for: .touchUpInside)
        editProjectButton.backgroundColor = Color.liteWhite
        editProjectButton.setTitleColor(UIColor.black, for: .normal)
        editProjectButton.titleLabel?.font  = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.view.addSubview(editProjectButton)

        editProjectButton.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.leading.equalTo(dateTimelineButton)
            make.width.equalTo(self.view).dividedBy(2.4)
            make.top.equalTo(stopButton.snp.bottom).offset(20)
        }
        editProjectButton.layer.cornerRadius = 5.0
        editProjectButton.clipsToBounds = true
        editProjectButton.isHidden = true
        
        let shootPlan = UIImage(named: "shooting_plan")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)

        shootingPlanButton = UIButton()
        shootingPlanButton.setImage(shootPlan, for: .normal)
        shootingPlanButton.setTitle("  \(NSLocalizedString("Shooting Plan", comment: ""))   ", for: .normal)
        shootingPlanButton.backgroundColor = Color.liteWhite
        shootingPlanButton.setTitleColor(UIColor.black, for: .normal)
        shootingPlanButton.addTarget(self, action: #selector(shootingPlanButtonAction), for: .touchUpInside)
        shootingPlanButton.titleLabel?.font  = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.view.addSubview(shootingPlanButton)

        shootingPlanButton.snp.makeConstraints { (make) in
            make.height.equalTo(35)
            make.leading.equalTo(projectBudgetButton)
            make.width.equalTo(self.view).dividedBy(2.4)
            make.top.equalTo(stopButton.snp.bottom).offset(20)
        }
        shootingPlanButton.layer.cornerRadius = 5.0
        shootingPlanButton.clipsToBounds = true
        shootingPlanButton.isHidden = true
        
        
        
//        shootingPlanButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)

//        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
////            shootingPlanButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//            shootingPlanButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
//            editProjectButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
//
//        }
        
        lineView3 = UIView()
        lineView3.backgroundColor = Color.gray
        scrollView.addSubview(lineView3)
        
        lineView3.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(shootingPlanButton.snp.bottom).offset(10)
            make.height.equalTo(0.5)
        }
        
        
        resourceLabel = UILabel()
        resourceLabel.font = UIFont(name: "Avenir Heavy", size: 16)
        resourceLabel.text = NSLocalizedString("Resources", comment: "")
        scrollView.addSubview(resourceLabel)
        
        resourceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(lineView3.snp.bottom).offset(10)
            make.leading.equalTo(startButton).offset(10)
        }
        
        let audition = UIImage(named: "talent")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        auditionReqButton = UIButton()
        auditionReqButton.setImage(audition, for: .normal)
        auditionReqButton.setTitle(NSLocalizedString("  Audition Request", comment: ""), for: .normal)
        auditionReqButton.backgroundColor = Color.liteWhite
        auditionReqButton.setTitleColor(UIColor.black, for: .normal)
        auditionReqButton.titleLabel?.font  = UIFont(name: "AvenirLTStd-Book", size: 10)
        auditionReqButton.addTarget(self, action: #selector(self.auditionReqButtonAction), for: .touchUpInside)
        self.view.addSubview(auditionReqButton)
        
        auditionReqButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.trailing.equalTo(self.view).offset(-20)
            make.width.equalTo(self.view).dividedBy(2.4)
            make.top.equalTo(lineView3).offset(10)
//            make.centerY.equalTo(resourceLabel)
        }
        auditionReqButton.layer.cornerRadius = 5.0
        auditionReqButton.clipsToBounds = true
        auditionReqButton.isHidden = true
        
        hireResourceButton = UIButton()
        hireResourceButton.setTitle(NSLocalizedString("Hire Resources", comment: ""), for: .normal)
        hireResourceButton.backgroundColor = Color.liteGray
        hireResourceButton.addTarget(self, action: #selector(self.hireResourceAction), for: .touchUpInside)
        hireResourceButton.setTitleColor(UIColor.black, for: .normal)
        hireResourceButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.view.addSubview(hireResourceButton)

        hireResourceButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.equalTo(self.view).offset(20)
            make.width.equalTo(self.view).dividedBy(2.2)
            make.bottom.equalTo(self.view).inset(25)
        }
        hireResourceButton.layer.cornerRadius = 5.0
        hireResourceButton.clipsToBounds = true
        
        notifyAuditionButton = UIButton()
        notifyAuditionButton.setTitle(NSLocalizedString("Notify for audition", comment: ""), for: .normal)
        notifyAuditionButton.backgroundColor = Color.liteBlack
        notifyAuditionButton.setTitleColor(UIColor.white, for: .normal)
        notifyAuditionButton.addTarget(self, action: #selector(self.notifyAuditionButtonAction), for: .touchUpInside)
        notifyAuditionButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        self.view.addSubview(notifyAuditionButton)

        notifyAuditionButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.trailing.equalTo(self.view).offset(-20)
            make.width.equalTo(self.view).dividedBy(2.5)
            make.bottom.equalTo(self.view).inset(25)
        }
        notifyAuditionButton.layer.cornerRadius = 5.0
        notifyAuditionButton.clipsToBounds = true

        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            shootingPlanButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            notifyAuditionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        findLineView = UIView()
        findLineView.backgroundColor = Color.liteGray
        self.view.addSubview(findLineView)

        findLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(hireResourceButton.snp.top).offset(-10)
        }
        
       

        
        projectNameTextfield.isHidden = true
        startLabel.isHidden = true
        stopLabel.isHidden = true
        budgetLabel.isHidden = true
        resourceLabel.isHidden = true
        lineView.isHidden = true
        dateTimelineButton.isHidden = true
        projectBudgetButton.isHidden = true
        lineView.isHidden = true
        startButton.isHidden = true
        stopButton.isHidden = true
        lineView1.isHidden = true
        lineView3.isHidden = true
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.tableFooterView = UIView()
        scrollView.addSubview(tableView)
        tableView.register(AgencyProjectDetailsTVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(findLineView)
            make.top.equalTo(auditionReqButton.snp.bottom).offset(10)
        }
        tableView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateProjectAction), name: Notification.updateProject, object: nil)

    }
    
    @objc func updateProjectAction(){
        fetchProjectDetails()
    }
    
    @objc func editProjectAction(){
        if Profile.shared.details == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }else{
            self.tabBarController?.tabBar.isHidden = true
            
            let vc = CreateProjectViewController()
            vc.editProject = true
            vc.projectName = project.name
            vc.projectDesc = project.description
            vc.startDateStr = project.start_at
            vc.endDateStr = project.end_at
            vc.budget = project.budget
            vc.projectId = project.id
            vc.isAgency = (Profile.shared.details?.is_agency=="Yes") ? true : false
            vc.isCompany = (Profile.shared.details?.is_company=="Yes") ? true : false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func shootingPlanButtonAction(){

        self.tabBarController?.tabBar.isHidden = true
        let vc = ShootingPlanViewController()
        vc.providers = self.resources
        vc.projectName = project.name
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func notifyAuditionButtonAction(){
       
        let vc = CategoryViewController()
        vc.isFromProjects = true
        vc.isNotifyAudition = true
        vc.providers = self.resources
        vc.projectName = self.project.name
        vc.audtions = self.project.auditions
        self.navigationController?.pushViewController(vc, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    @objc func auditionReqButtonAction(){
        let vc = AudtionListViewController()
        vc.auditions = self.auditions
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func hireResourceAction()
    {
        let vc = CategoryViewController()
        vc.isFromProjects = true
        vc.isNotifyAudition = false
        vc.providers = self.resources
        self.navigationController?.pushViewController(vc, animated: true)
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
                        self.project = project
                        if let resources = project.resources{
                            self.resources = resources
                        }
                      
                        if self.resources.count == 0{
                            self.tableView.separatorStyle = .none
                        }
                        self.tableView.isHidden = false
                        self.tableView.reloadData()
                        self.statusLabel.text = NSLocalizedString(project.status ?? "", comment: "")
                        self.projectNameTextfield.text = project.name
                        
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
                        
                        
                        self.projectNameTextfield.isHidden = false
                        self.startLabel.isHidden = false
                        self.stopLabel.isHidden = false
                        self.budgetLabel.isHidden = false
                        self.resourceLabel.isHidden = false
                        self.lineView.isHidden = false
                        self.dateTimelineButton.isHidden = false
                        self.projectBudgetButton.isHidden = false
                        self.lineView.isHidden = false
                        self.startButton.isHidden = false
                        self.stopButton.isHidden = false
                        self.lineView1.isHidden = false
                        self.lineView3.isHidden = false
                        self.editProjectButton.isHidden = false
                        self.shootingPlanButton.isHidden = false
                        
                        if let audtionList = projectDetails.data?.auditions{
                            self.auditions = audtionList
                            if self.auditions.count>0{
                                self.auditionReqButton.isHidden = false
                            }
                        }else{
                            self.auditionReqButton.isHidden = true
                        }
                        
                        let agenciesHeight = CGFloat((self.resources.count*80)+407+55)
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: agenciesHeight)
                    }
                }
                
                
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
        
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        
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
                Banner().displaySuccess(string: NSLocalizedString("Project succesfully completed", comment: ""))
                self.fetchProjectDetails()
                NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                self.dotsButton.isHidden = true
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
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
                Banner().displaySuccess(string: NSLocalizedString("Project cancelled", comment: ""))
                self.fetchProjectDetails()
                NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                self.dotsButton.isHidden = true
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
            }
        }
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
    
}

extension ProjectDetailsAgencyViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if resources.count == 0{
            return 1
        }
        
        return resources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AgencyProjectDetailsTVCell
        cell.selectionStyle = .none
        
        if resources.count == 0{
            cell.profileImageView.image = placeHolderImage
            cell.noResourceLabel.isHidden = false
            cell.budgetIcon.isHidden = true
            cell.amountLabel.isHidden = true
        }else{
            cell.noResourceLabel.isHidden = true
            cell.budgetIcon.isHidden = false
            cell.amountLabel.isHidden = false
            let resource = resources[indexPath.row]
            let profilePicurl = Url.providers + (resource.profile_image ?? "")
            cell.profileImageView.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.category1Label.text = resource.child_category
            cell.category2Label.text = resource.main_category
            cell.nameLabel.text = resource.name
            cell.totalAmountLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(resource.total_amount ?? "")"
            
            let amountString = resource.total_amount ?? "0"
            let amountFloat = Float(amountString)
            let amount = Int(amountFloat ?? 0)
            cell.totalAmountLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(amount)"
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = ProviderMilestonesViewController()
        vc.hire_resource_id = resources[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


class AgencyProjectDetailsTVCell : UITableViewCell{
    
    var profileImageView   : UIImageView!
    var category1Label     : UILabel!
    var category2Label     : UILabel!
    var nameLabel          : UILabel!
    var totalAmountLabel   : UILabel!
    var noResourceLabel    : UILabel!
    var budgetIcon         : UIImageView!
    var amountLabel        : UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        profileImageView = UIImageView()
        profileImageView.contentMode = .scaleAspectFill
        self.contentView.addSubview(profileImageView)
        
        profileImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).offset(10)
            make.top.equalTo(self.contentView).offset(10)
            make.width.height.equalTo(60)
        }
        profileImageView.layer.cornerRadius = 30
        profileImageView.clipsToBounds = true
        
        category1Label = UILabel()
        category1Label.textColor = Color.red
        category1Label.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.contentView.addSubview(category1Label)
        
        category1Label.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalTo(profileImageView).offset(02)
            make.width.equalTo(self.contentView).dividedBy(2)
        }
        
        category2Label = UILabel()
        category2Label.textColor = UIColor.black
        category2Label.font = UIFont(name: "Avenir Heavy", size: 16)
        self.contentView.addSubview(category2Label)
        
        category2Label.snp.makeConstraints { (make) in
            make.top.equalTo(category1Label.snp.bottom).offset(03)
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.width.equalTo(self.contentView).dividedBy(2)
        }
        
        noResourceLabel = UILabel()
        noResourceLabel.text = NSLocalizedString("No Resources Hired", comment: "")
        noResourceLabel.textColor = Color.gray
        noResourceLabel.font = UIFont(name: "AvenirLTStd-Book", size: 16)
        self.contentView.addSubview(noResourceLabel)
        
        noResourceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.centerY.equalTo(profileImageView)
            make.width.equalTo(self.contentView).dividedBy(2)
        }
        
        nameLabel = UILabel()
        nameLabel.textColor = Color.gray
        nameLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        self.contentView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(profileImageView.snp.trailing).offset(10)
            make.top.equalTo(category2Label.snp.bottom).offset(02)
            make.width.equalTo(self.contentView).dividedBy(2)
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            nameLabel.textAlignment = .right
            category1Label.textAlignment = .right
            category2Label.textAlignment = .right
        }else{
            nameLabel.textAlignment = .left
            category1Label.textAlignment = .left
            category2Label.textAlignment = .left
        }
        
        budgetIcon = UIImageView()
        budgetIcon.image = UIImage(named: "project_budget")
        budgetIcon.contentMode = .scaleAspectFit
        self.contentView.addSubview(budgetIcon)
        
        budgetIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(10)
            make.top.equalTo(category1Label)
            make.trailing.equalTo(self.contentView).offset(-60)
        }
        
        amountLabel = UILabel()
        amountLabel.textColor = Color.gray
        amountLabel.text = NSLocalizedString("Total Amount", comment: "")
        amountLabel.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        self.contentView.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(budgetIcon)
            make.top.equalTo(budgetIcon.snp.bottom).offset(03)
        }
        
        totalAmountLabel = UILabel()
        totalAmountLabel.textColor = UIColor.black
        totalAmountLabel.font = UIFont(name: "Avenir Heavy", size: 12)
        self.contentView.addSubview(totalAmountLabel)
        
        totalAmountLabel.snp.makeConstraints { (make) in
            make.centerX.equalTo(budgetIcon)
            make.top.equalTo(amountLabel.snp.bottom).offset(03)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
