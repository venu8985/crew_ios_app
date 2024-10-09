//
//  ProjectsListViewController.swift
//  Crew
//
//  Created by Rajeev on 10/03/21.
//

import UIKit

class ProjectsListViewController: UIViewController {

    
    var paginationCount : Int!
    var lastPage : Int!
    var projects = [ProjectsData]()
    var tableView : UITableView!
    var noProjectsLabel : UILabel!
    var isFromDatesVC = false
    var refreshControl : UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        self.view.addSubview(tableView)
        tableView.register(ProjectTVCell.self, forCellReuseIdentifier: "cell")
        tableView.register(ProjectMiniTVCell.self, forCellReuseIdentifier: "cell1")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.view)
        }
//        tableView.isHidden = true
//        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            shootingPlanButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        }
                
        noProjectsLabel = UILabel()
        noProjectsLabel.text = NSLocalizedString("No projects found", comment: "")
        noProjectsLabel.textAlignment = .center
        noProjectsLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.view.addSubview(noProjectsLabel)
        noProjectsLabel.isHidden = true
        noProjectsLabel.snp.makeConstraints { (make) in
//            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        self.view.bringSubviewToFront(noProjectsLabel)
        
        self.navigationItem.title = NSLocalizedString("My projects", comment: "")

        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        
        navigationBarItems()
    }
    
    @objc func paginationAction(){
        self.fetchProjects()
        refreshControl.endRefreshing()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        paginationCount = 0
        self.projects.removeAll()
        
        if Profile.shared.details == nil{
            let vc = LoginAlertViewController()
            vc.modalPresentationStyle = .custom
            self.present(vc, animated: true, completion: nil)

        }else{
            self.fetchProjects()
        }
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isFromDatesVC{
            
            self.tabBarController?.tabBar.isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.tableView.snp.remakeConstraints { (make) in
                    make.leading.trailing.top.bottom.equalToSuperview()
                    make.top.equalToSuperview().inset(100)
                    make.bottom.equalToSuperview().inset(75)
                }
            }
            
        }
        
    }
    
    func fetchProjects(){
        
        if lastPage == paginationCount{
            return
        }
        
        paginationCount += 1
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "page" : "\(paginationCount ?? 0)"
        ]
        
        WebServices.postRequest(url: Url.projectList, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getProjectsResponse = try decoder.decode(ProjectsList.self, from: data)
                self.lastPage = getProjectsResponse.data?.last_page
                if let projects = getProjectsResponse.data?.data{
                    for project in projects{
                        self.projects.append(project)
                    }
                    self.refreshControl.endRefreshing()
                    
                    if projects.count>0{
//                        self.tableView.isHidden = false
                        self.noProjectsLabel.isHidden = true
                        self.tableView.reloadData()
                    }else{
                        self.noProjectsLabel.isHidden = false
                    }
                    
                    
                }
                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    func navigationBarItems() {
        if isFromDatesVC{
            self.navigationItem.title = NSLocalizedString("Select the project", comment: "")
            let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
            let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
//            backButton.setImage(UIImage(named: "back"), for: .normal)
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
        
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ProjectsListViewController : UITableViewDataSource, UITableViewDelegate{
         
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        returnedView.backgroundColor = .white
        
        let button = UIButton()
        button.backgroundColor = .white
        button.frame = CGRect(x: 10, y: 7, width: view.frame.size.width-20, height: 30)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle(NSLocalizedString(NSLocalizedString("  Create Project", comment: ""), comment: ""), for: .normal)
        button.setImage(UIImage(named: "create-project"), for: .normal)
        button.setTitleColor(Color.red, for: .normal)
        button.addTarget(self, action: #selector(self.createNewProjectAction), for: .touchUpInside)
        button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)

        returnedView.addSubview(button)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        return returnedView
        
    }
    
    func checkUserVerification(){
//        self.tabBarController?.tabBar.isHidden = true
        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc : ReviewPopupVC = storyboard.instantiateViewController(withIdentifier: "ReviewPopupVC") as! ReviewPopupVC
        vc.modalPresentationStyle = .overFullScreen
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
       
    @objc func createNewProjectAction(){
        
        if Profile.shared.details == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        else if Profile.shared.details?.profile_status != "Verified"{
            checkUserVerification()
        }
        
        
        else{
            self.tabBarController?.tabBar.isHidden = true
            
            let vc = CreateProjectViewController()
            vc.editProject = false
            vc.isAgency = (Profile.shared.details?.is_agency=="Yes") ? true : false
            vc.isCompany = (Profile.shared.details?.is_company=="Yes") ? true : false
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if isFromDatesVC{
            // Hiding all buttons
            return 160
        }
        else {
            // validating to hide shooting plan button
            if projects.count>indexPath.row{
                if let projectResources = projects[indexPath.row].resources{
                    
                    if projectResources.count>0{
                        return 270
                    }else{
                        return 220
                    }
                }
            }
        }
        return 270
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 40
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return projects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if projects.count>indexPath.row{
            
            let project = projects[indexPath.row]
            
            let cell = ProjectTVCell(style: .default, reuseIdentifier: "cell")
            cell.profileDelegate = self
            cell.selectionStyle = .none
            cell.disableLayer.isHidden = true
            cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
            cell.bgView.layer.borderWidth = 0.5
            
            
            //Data updating
            cell.projectDetailsView.statusButton.setTitle(NSLocalizedString(project.status ?? "", comment: ""), for: .normal)
            cell.projectDetailsView.ongoingProjectNameLabel.text = project.name
            
            let budgetString = project.budget ?? "0"
            let budgetFloat = Float(budgetString)
            let budget = Int(budgetFloat ?? 0)
            cell.projectDetailsView.budgetLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(budget)"
            
            let costString = project.cost ?? "0"
            let costFloat = Float(costString)
            let cost = Int(costFloat ?? 0)
            cell.projectDetailsView.costLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(cost)"
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.date(from: project.start_at ?? "")
            let endDate = dateFormatter.date(from: project.end_at ?? "")
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = startDate{
                let dateString = dateFormatter.string(from: date)
                cell.projectDetailsView.startLabel.text = dateString
            }
            if let date = endDate{
                let dateString = dateFormatter.string(from: date)
                cell.projectDetailsView.stopLabel.text = dateString
            }
            
            
            if Profile.shared.details?.is_company == "Yes" {
                
                cell.agencies = project.hireAgency
                cell.delegate = self
                cell.picsCollectionView.tag = indexPath.row
                cell.picsCollectionView.reloadData()
                cell.hideUnhidePics()
                
                cell.hireResourceButton.isHidden = true
                cell.notifyAuditionButton.isHidden = true
                cell.shootingPlanButton.isHidden = true
                cell.findAgenciesButton.isHidden = false
                
                cell.findAgenciesButton.tag = indexPath.row
                cell.findAgenciesButton.addTarget(self, action: #selector(self.findAgenciesButtonAction), for: .touchUpInside)
                
            }
            else{
                
                cell.providers = project.resources
                cell.delegate = self
                cell.picsCollectionView.tag = indexPath.row
                cell.picsCollectionView.reloadData()
                
                if cell.providers.count>0{
                    cell.shootingPlanButton.isHidden = false
                }else{
                    cell.shootingPlanButton.isHidden = true
                }
                
                cell.hireResourceButton.isHidden = false
                cell.notifyAuditionButton.isHidden = false
                cell.shootingPlanButton.isHidden = false
                cell.findAgenciesButton.isHidden = true
                
                cell.hireResourceButton.tag = indexPath.row
                cell.hireResourceButton.addTarget(self, action: #selector(self.hireResourceButtonAction), for: .touchUpInside)
                
                cell.notifyAuditionButton.tag = indexPath.row
                cell.notifyAuditionButton.addTarget(self, action: #selector(self.notifyAuditionButtonAction), for: .touchUpInside)
                
                cell.shootingPlanButton.tag = indexPath.row
                cell.shootingPlanButton.addTarget(self, action: #selector(self.shootingPlanButtonAction), for: .touchUpInside)
                
                if cell.providers.count>0{
                    cell.shootingPlanButton.isHidden = false
                }else{
                    cell.shootingPlanButton.isHidden = true
                }
            }
            
            if isFromDatesVC{
                cell.hireResourceButton.isHidden   = true
                cell.notifyAuditionButton.isHidden = true
                cell.shootingPlanButton.isHidden   = true
                cell.lineView.isHidden             = true
                cell.picsCollectionView.isHidden   = true
                cell.findAgenciesButton.isHidden   = true
                
                //disabling project for already hired user
                if let providerid = CreateContract.shared.provider_profile_id{
                    if let resources = project.resources{
                        let ids = resources.map({ return $0.provider_profile_id ?? 0})
                        if ids.contains(providerid){
                            cell.disableLayer.isHidden = false
                        }else{
                            cell.disableLayer.isHidden = true
                        }
                    }
                }

            }
            
            if project.status == "Awarded" {
                cell.findAgenciesButton.isHidden = true
            }
            
            return cell
        }
        return UITableViewCell()
        
        
        /*
         }else if indexPath.row == 1{
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ProjectTVCell
         cell.selectionStyle = .none
         
         cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
         
         if selectedIndex != nil{
         if selectedIndex == indexPath.row{
         cell.bgView.layer.borderColor = UIColor.red.cgColor
         }
         }
         
         return cell
         }else{
         let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! ProjectMiniTVCell
         cell.selectionStyle = .none
         
         cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
         
         if selectedIndex != nil{
         if selectedIndex == indexPath.row{
         cell.bgView.layer.borderColor = UIColor.red.cgColor
         }
         }
         
         return cell
         }
         */
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        

        let project = projects[indexPath.row]
        
        if isFromDatesVC{
            
            //disabling project for already hired user
            if let providerid = CreateContract.shared.provider_profile_id{
                if let resources = project.resources{
                    let ids = resources.map({ return $0.provider_profile_id ?? 0})
                    if ids.contains(providerid){
                        print("already hired for this project")

                    }else{
                        print("not hired for this project")
                        //Saving dates in shared class for create contract
                        let project = projects[indexPath.row]
                        CreateContract.shared.project_id = project.id
                        let vc = MilestoneViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
                
            
        }else{
            self.tabBarController?.tabBar.isHidden = true
            CreateContract.shared.project_id = project.id
            
            if Profile.shared.details?.is_agency=="Yes"{
                let vc = ProjectDetailsAgencyViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                let vc = ProjectDetailsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }

    }
    
    //MARK: cell button actions
    @objc func hireResourceButtonAction(sender:UIButton){
        let project = projects[sender.tag]
        CreateContract.shared.project_id = project.id
        
        if project.status == "Completed" || project.status == "Cancelled"{
            Banner().displayValidationError(string: NSLocalizedString("This action is not permissible for cancelled or completed projects", comment: ""))
        }else{
            self.tabBarController?.tabBar.isHidden = true

            let vc = CategoryViewController()
            vc.isFromProjects = true
            vc.isNotifyAudition = false
            vc.providers = project.resources
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func notifyAuditionButtonAction(sender:UIButton){
        self.tabBarController?.tabBar.isHidden = true
        let project = projects[sender.tag]
        CreateContract.shared.project_id = project.id
        
        let vc = CategoryViewController()
        vc.isFromProjects = true
        vc.isNotifyAudition = true
        vc.providers = project.resources
        vc.projectName = project.name
        vc.audtions = project.auditions
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func shootingPlanButtonAction(sender:UIButton){
        
        let project = projects[sender.tag]
        CreateContract.shared.project_id = project.id

        if project.status == "Completed" || project.status == "Cancelled"{
            Banner().displayValidationError(string: NSLocalizedString("This action is not permissible for cancelled or completed projects", comment: ""))

        }else{
            self.tabBarController?.tabBar.isHidden = true
            let vc = ShootingPlanViewController()
            vc.providers = project.resources
            vc.projectName = project.name
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        
    }
    @objc func findAgenciesButtonAction(sender : UIButton){
        
        let project = projects[sender.tag]
        CreateContract.shared.project_id = project.id
        
        if project.status == "Completed" || project.status == "Cancelled"{
            Banner().displayValidationError(string: NSLocalizedString("This action is not permissible for cancelled or completed projects", comment: ""))
            
        }else{
            
            let project = projects[sender.tag]
            CreateContract.shared.project_id = project.id
            self.tabBarController?.tabBar.isHidden = true
            let vc = AgenciesViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: open profile details
protocol ProfileDelegate {
    func openProfileDetails(providerId : Int)
}
extension ProjectsListViewController : ProfileDelegate{
    func openProfileDetails(providerId : Int){
        self.tabBarController?.tabBar.isHidden = true
        let vc = ProviderMilestonesViewController()
        vc.hire_resource_id = providerId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

class ProjectTVCell : UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    var bgView               : UIView!
    var projectDetailsView   : ProjectDetailsView!
    var hireResourceButton   : UIButton!
    var findAgenciesButton   : UIButton!
    var notifyAuditionButton : UIButton!
    var shootingPlanButton   : UIButton!
    var providers            : [ResourcesData]!
    var agencies             : [AgencyDetails]!
    var picsCollectionView   : UICollectionView!
    var lineView             : UIView!
    var profileDelegate      : ProfileDelegate!
    var disableLayer         : UIView!
    var delegate             : ResourcesDelegate!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView).inset(10)
        }
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = true
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        projectDetailsView = ProjectDetailsView()
        projectDetailsView.layer.borderWidth = 0
        self.contentView.addSubview(projectDetailsView)
        
        projectDetailsView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.contentView).inset(10)
            make.height.equalTo(140)
        }
          
        lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(projectDetailsView).inset(5)
            make.height.equalTo(1)
            make.top.equalTo(projectDetailsView.snp.bottom).offset(5)
        }
        
        hireResourceButton = UIButton()
        hireResourceButton.backgroundColor = Color.liteGray
        hireResourceButton.setTitleColor(UIColor.black, for: .normal)
        hireResourceButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        hireResourceButton.setImage(UIImage(named: "hire"), for: .normal)
        hireResourceButton.setTitle(NSLocalizedString(" Hire Resources", comment: ""), for: .normal)
        self.contentView.addSubview(hireResourceButton)
        
        hireResourceButton.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(10)
            make.top.equalTo(lineView.snp.bottom).offset(05)
            make.width.equalTo(bgView).dividedBy(2.2)
            make.height.equalTo(40)
        }
        
        hireResourceButton.layer.cornerRadius = 5.0
        hireResourceButton.clipsToBounds = true
        
        
        findAgenciesButton = UIButton()
        findAgenciesButton.backgroundColor = Color.liteGray
        findAgenciesButton.setTitleColor(UIColor.black, for: .normal)
        findAgenciesButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        findAgenciesButton.setTitle(NSLocalizedString(" Find Agencies", comment: ""), for: .normal)
        self.contentView.addSubview(findAgenciesButton)
        
        findAgenciesButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(bgView).inset(10)
            make.top.equalTo(lineView.snp.bottom).offset(05)
            make.height.equalTo(40)
        }
        findAgenciesButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        findAgenciesButton.layer.cornerRadius = 5.0
        findAgenciesButton.clipsToBounds = true
        
        
        notifyAuditionButton = UIButton()
        notifyAuditionButton.backgroundColor = Color.liteGray
        notifyAuditionButton.setTitleColor(UIColor.black, for: .normal)
        notifyAuditionButton.setTitle(" \(NSLocalizedString("Notify for Audition", comment: "")) ", for: .normal)
        notifyAuditionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        notifyAuditionButton.setImage(UIImage(named: "notificationAudtion"), for: .normal)
        self.contentView.addSubview(notifyAuditionButton)
        
        notifyAuditionButton.snp.makeConstraints { (make) in
            make.leading.equalTo(hireResourceButton.snp.trailing).offset(15)
            make.top.equalTo(lineView.snp.bottom).offset(05)
            make.width.equalTo(bgView).dividedBy(2.2)
            make.height.equalTo(40)
        }
        notifyAuditionButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        notifyAuditionButton.layer.cornerRadius = 5.0
        notifyAuditionButton.clipsToBounds = true
        
        
        shootingPlanButton = UIButton()
        shootingPlanButton.backgroundColor = Color.liteGray
        shootingPlanButton.setTitleColor(UIColor.black, for: .normal)
        shootingPlanButton.setTitle(NSLocalizedString(" Shooting Plan", comment: ""), for: .normal)
        shootingPlanButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        shootingPlanButton.setImage(UIImage(named: "shooting_plan"), for: .normal)
        self.contentView.addSubview(shootingPlanButton)
        
        shootingPlanButton.snp.makeConstraints { (make) in
            make.leading.equalTo(hireResourceButton.snp.trailing).offset(15)
            make.top.equalTo(notifyAuditionButton.snp.bottom).offset(10)
            make.width.equalTo(bgView).dividedBy(2.2)
            make.height.equalTo(40)
        }
        shootingPlanButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)

        shootingPlanButton.layer.cornerRadius = 5.0
        shootingPlanButton.clipsToBounds = true
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        picsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picsCollectionView.dataSource = self
        picsCollectionView.delegate = self
        picsCollectionView.isScrollEnabled = false
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        picsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        
        picsCollectionView.showsHorizontalScrollIndicator = false
        picsCollectionView.backgroundColor = UIColor.clear
        layout.scrollDirection = .horizontal
        self.contentView.addSubview(picsCollectionView)

        picsCollectionView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(hireResourceButton)
            make.height.equalTo(40)
            make.top.equalTo(hireResourceButton.snp.bottom).offset(10)
        }

        disableLayer = UIView()
        disableLayer.backgroundColor = UIColor.gray.withAlphaComponent(0.25)
        bgView.addSubview(disableLayer)
        
        disableLayer.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(bgView)
        }
        self.contentView.bringSubviewToFront(disableLayer)
    }
    
    func hideUnhidePics(){
        
        if agencies.count>0{
            
            findAgenciesButton.snp.remakeConstraints { (make) in
                make.trailing.equalTo(bgView).inset(10)
                make.top.equalTo(lineView.snp.bottom).offset(05)
                make.width.equalTo(self.contentView.frame.size.width/2.25)
                make.height.equalTo(40)
            }
            
            picsCollectionView.snp.remakeConstraints { (make) in
                make.leading.equalTo(hireResourceButton)
                make.trailing.equalTo(findAgenciesButton.snp.leading).offset(-10)
                make.height.equalTo(40)
//                make.width.equalTo(self.contentView.frame.size.width/2.5)
                make.top.equalTo(findAgenciesButton)
            }
        }
        
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
        
        if providers != nil{
            if providers.count<3{
                return providers.count
            }
            return 3
        }else if agencies != nil{
            if agencies.count<3{
                return agencies.count
            }
            return 3
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
                
        let imageUrl: String!
            
        if providers != nil{
            imageUrl = Url.providers + (providers[indexPath.row].profile_image ?? "")
        }
        else{
            imageUrl = Url.userProfile + (agencies[indexPath.row].profile_image ?? "")
        }
        
        
        let imageView = UIImageView()
        if indexPath.row != 2{
            imageView.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        }else{
            imageView.backgroundColor = Color.red.withAlphaComponent(0.25)
        }
        cell.addSubview(imageView)
        
        imageView.frame = cell.bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 20

        let countLabel = UILabel()
        countLabel.frame = imageView.bounds
        if indexPath.row == 2{
            
            if providers != nil{
                countLabel.text = "+\(providers.count-2)"
            }
            else{
                countLabel.text = "+\(agencies.count-2)"
            }
            
        }
        countLabel.font = UIFont(name: "AvenirLTStd-Book", size: 16)
        countLabel.textColor = .red
        imageView.addSubview(countLabel)
        countLabel.textAlignment = .center
        
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2{
            delegate.openProviders(projectIndex: collectionView.tag)
        }else{
            if providers != nil{
                if let id = providers[indexPath.row].id {
                    profileDelegate.openProfileDetails(providerId: id)
                }
            }
        }
    }
    
}

class ProjectMiniTVCell : UITableViewCell, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    var bgView : UIView!
    var projectDetailsView : ProjectDetailsView!
    var hireResourceButton : UIButton!
    var notifyAuditionButton : UIButton!
    var shootingPlanButton : UIButton!
    var picsCollectionView : UICollectionViewCell!

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView).inset(10)
        }
        bgView.layer.cornerRadius = 10.0
        bgView.clipsToBounds = true
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        projectDetailsView = ProjectDetailsView()
        projectDetailsView.layer.borderWidth = 0
        self.contentView.addSubview(projectDetailsView)
        
        projectDetailsView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.contentView).inset(10)
            make.height.equalTo(140)
        }

        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(projectDetailsView).inset(5)
            make.height.equalTo(1)
            make.top.equalTo(projectDetailsView.snp.bottom).offset(5)
        }
        
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 40, height: 40)
        let picsCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        picsCollectionView.dataSource = self
        picsCollectionView.delegate = self
        picsCollectionView.isScrollEnabled = false
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        picsCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        picsCollectionView.showsHorizontalScrollIndicator = false
        picsCollectionView.backgroundColor = UIColor.clear
        layout.scrollDirection = .horizontal
        self.contentView.addSubview(picsCollectionView)
        
        picsCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(self.contentView.frame.size.width/2)
            make.top.equalTo(lineView.snp.bottom).offset(10)
        }

        
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
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        let imageView = UIImageView()
        if indexPath.row != 2{
//            imageView.image = UIImage(named: "tom-hardy")
        }else{
            imageView.backgroundColor = Color.red.withAlphaComponent(0.25)
        }
        cell.addSubview(imageView)

        imageView.frame = cell.bounds
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 20

        let countLabel = UILabel()
        countLabel.frame = imageView.bounds
        if indexPath.row == 2{
            countLabel.text = "+5"
        }
        countLabel.font = UIFont(name: "AvenirLTStd-Book", size: 16)
        countLabel.textColor = .red
        imageView.addSubview(countLabel)
        countLabel.textAlignment = .center
                
        return cell
    }
    
}

//MARK: open providers

extension ProjectsListViewController : ResourcesDelegate{

    func openProviders(projectIndex : Int){
        
        let vc = ProvidersViewController()
        vc.modalPresentationStyle = .custom
               
        if Profile.shared.details?.is_agency=="Yes"{
            vc.titleString = NSLocalizedString("   Resources", comment: "")
            vc.profileDelegate = self
        }else{
            vc.titleString = NSLocalizedString("   Agencies", comment: "")
        }
        
        if let providers = projects[projectIndex].resources{
            if providers.count>0{
                vc.providers =  providers
            }
        }
        if let agencies = projects[projectIndex].hireAgency{
            if agencies.count>0{
                vc.agencies = agencies
            }
        }
        self.present(vc, animated: true, completion: nil)
        
    }
}

