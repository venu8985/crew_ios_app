//
//  NotificationsViewController.swift
//  Crew
//
//  Created by Rajeev on 19/03/21.
//

import UIKit

enum NotificationType: String {
    
    //Account
    case ADMIN                            = "admin"
    case VERIFIED                         = "Verified"
    case REJECTED                         = "Rejected"
    
    //Project
    case PROJECT_CANCELLED                = "projectCancelled"
    case PROJECT_COMPLETED                = "projectCompleted"
    case PROJECT_AWARDED                  = "projectAwarded"
    
    //Contracts
    case CONTRACT_RECEIVED                = "contractReceived"
    case CONTRACT_ACCEPTED                = "contractAccepted"
    case CONTRACT_REJECTED                = "contractRejected"
    
    //Shooting plan
    case SHOOTING_PLAN_CREATED            = "shootingPlanCreated"
    case SHOOTING_PLAN_REVISED            = "shootingPlanRevised"
    case SHOOTING_PLAN_RESCHEDULE         = "shootingPlanReschedule"
    
    //Audtion requests
    case AUDITION_REQUEST_RECEIVED        = "auditionRequestReceived"
    case AUDITION_REQUEST_ACCEPTED        = "auditionRequestAccepted"
    case AUDITION_REQUEST_REJECTED        = "auditionRequestRejected"
    
    case HIRE_AGENCY                      = "hireAgency"
    case REQUEST_REJECTED                 = "requestRejected"
    case PROPOSAL_SUBMITTED               = "proposalSubmitted"
    
    //Milestones
    case MILESTONE_PAYMENT_RELEASED       = "milestonePaymentReleased"
    case MILESTONE_PAYMENT_NOT_RECEIVED   = "milestonePaymentNotReceived"
    case MILESTONE_PAYMENT_RECEIVED       = "milestonePaymentReceived"
    case MILESTONE_PAYMENT_REMINDER       = "milestonePaymentReminder"
    
    //Hire requests
    case HIRE_REQUEST_ACCEPTED            = "hireRequestAccepted"
    case HIRE_REQUEST_REJECTED            = "hireRequestRejected"
}

class NotificationsViewController: UIViewController {
    
    enum SegueIdentifier: String {
        case Login = "Login"
        case Main = "Main"
        case Options = "Options"
    }
    
    
    var tableView: UITableView!
    var notifications = [NotificationDetails]()
    var clearButton : UIButton!
    var noNotificationsLabel : UILabel!
    var noNotificationsImageView : UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.frame = self.view.bounds
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(NotificationTVcell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(15)
        }
        
        navigationBarItems()
        
        fetchNotifications()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent  = true
        self.navigationController?.navigationBar.isHidden       = false
    }
    
    func fetchNotifications(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "order_by" : "oldest"
        ]
        
        WebServices.postRequest(url: Url.getNotifications, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let notifications = try decoder.decode(Notifications.self, from: data)

                DispatchQueue.main.async {
                    
                    if success{
                        self.notifications = notifications.data
                        if self.notifications.count>0{
                            self.noNotificationsLabel.isHidden = true
                            self.clearButton.isHidden = false
                            self.tableView.isHidden = false
                            self.noNotificationsImageView.isHidden = true
                            self.tableView.reloadData()
                            
                        }else{
                            self.tableView.isHidden = true
                            self.noNotificationsImageView.isHidden = false
                            self.noNotificationsLabel.isHidden = false
                        }
                    
                    }else{
                        Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                    }
                }
                
            } catch let error {
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                print(error)
            }
        }
        
    }
    
    @objc func deleteAllNotifications(){
        
        
        let alertController = UIAlertController(title: nil, message: NSLocalizedString("Are you sure want to clear notifications", comment: "") , preferredStyle: UIAlertController.Style.alert) //Replace UIAlertControllerStyle.Alert by UIAlertControllerStyle.alert
        let gallertyAction = UIAlertAction(title: NSLocalizedString("Clear", comment: ""), style: UIAlertAction.Style.cancel) {
            (result : UIAlertAction) -> Void in
            self.deleteApi(id: 0)
        }
        
        // Replace UIAlertActionStyle.Default by UIAlertActionStyle.default
        let cameraAction = UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: UIAlertAction.Style.default) {
            (result : UIAlertAction) -> Void in
        }
        
        alertController.addAction(gallertyAction)
        alertController.addAction(cameraAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    func deleteApi(id:Int){
        
        let parameters: [String: Any]!
            
        if id == 0{
            parameters = [
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
            ]
        }else{
            parameters = [
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "notification_id" : id
            ]
        }
        
        WebServices.deleteRequest(url: Url.clearNotifications, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let notifications = try decoder.decode(DeleteNotifications.self, from: data)

                DispatchQueue.main.async {
                    
                    if success{
                        if id == 0{
                            // only for clear all
                            self.notifications.removeAll()
                            self.tableView.reloadData()
                            Banner().displaySuccess(string: NSLocalizedString("Notifications cleared successfully", comment: ""))
                            self.clearButton.isHidden = true
                        }
                    }else{
                        Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                    }
                }
                
            } catch let error {
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                print(error)
            }
        }
        
    }
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Notifications", comment: "")
        
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

        
    
        let clearButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        clearButton.contentMode = UIView.ContentMode.scaleAspectFit
        clearButton.setTitle(NSLocalizedString("Clear all", comment: ""), for: .normal)
        clearButton.setTitleColor(Color.red, for: .normal)
        clearButton.clipsToBounds = true
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        clearButton.contentHorizontalAlignment = .trailing
        clearButtonView.addSubview(clearButton)
        clearButton.addTarget(self, action:#selector(self.deleteAllNotifications), for: .touchUpInside)
        
        let rightBarButton = UIBarButtonItem(customView: clearButtonView)
        self.navigationItem.rightBarButtonItem = rightBarButton
        
        clearButton.isHidden = true
        
        
        noNotificationsLabel = UILabel()
        noNotificationsLabel.text = NSLocalizedString("No notifications found", comment: "")
        noNotificationsLabel.textAlignment = .center
        noNotificationsLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.view.addSubview(noNotificationsLabel)
        noNotificationsLabel.isHidden = true
        noNotificationsLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.center.equalToSuperview()
        }
        
     //   noNotificationsImageView
        
        noNotificationsImageView = UIImageView()
        noNotificationsImageView.image = UIImage(named: "no_notfication")
        noNotificationsImageView.contentMode = .scaleAspectFit
        self.view.addSubview(noNotificationsImageView)
        
        noNotificationsImageView.snp.makeConstraints { (make) in
            make.width.equalTo(200).dividedBy(2)
            make.height.equalTo(200).dividedBy(2)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noNotificationsLabel.snp.top).offset(-10)
        }
        noNotificationsImageView.isHidden = true
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
}
//MARK: notification tableview delegate datasource

extension NotificationsViewController : UITableViewDelegate, UITableViewDataSource{
    
    
//    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
//
//        if let swipeContainerView = tableView.subviews.first(where: { String(describing: type(of: $0)) == "_UITableViewCellSwipeContainerView" }) {
//            if let swipeActionPullView = swipeContainerView.subviews.first, String(describing: type(of: swipeActionPullView)) == "UISwipeActionPullView" {
////                swipeActionPullView.frame.size.height = swipeActionPullView.frame.size.height-20
////                swipeActionPullView.center = swipeActionPullView.center
//                swipeActionPullView.frame = CGRect(x: swipeContainerView.frame.minX, y: 20, width: 100, height: 100)
//            }
//        }
//    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {
//            dataSource.remove(at: indexPath.row)
            if let id = notifications[indexPath.row].id{
                deleteApi(id: id)
                notifications.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }

        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! NotificationTVcell
        cell.selectionStyle = .none
        cell.titleLabel.text = notifications[indexPath.row].title
        cell.infoLabel.text = notifications[indexPath.row].description
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            cell.titleLabel.textAlignment = .right
            cell.infoLabel.textAlignment = .right
        }else{
            cell.titleLabel.textAlignment = .left
            cell.infoLabel.textAlignment = .left
        }
        
        if let dateString = notifications[indexPath.row].created_at {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            let showDate = inputFormatter.date(from: dateString)
            inputFormatter.dateFormat = "dd MMM, yyyy"

            let formatter = RelativeDateTimeFormatter()
            formatter.unitsStyle = .full
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                formatter.locale =  Locale(identifier: "ar_DZ")
            }
            let relativeDate = formatter.localizedString(for: showDate!, relativeTo: Date())
            cell.dateLabel.text = relativeDate
            
        }
            
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let notify_type = notifications[indexPath.row].notify_type ?? ""
            
        if NotificationType.HIRE_AGENCY == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                let vc = RequestDetailsViewController()
                vc.hire_agency_id = Int(id)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.PROJECT_AWARDED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                let vc = RequestDetailsViewController()
                vc.hire_agency_id = Int(id)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.PROPOSAL_SUBMITTED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                let vc = ProjectDetailsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.CONTRACT_RECEIVED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                let vc = RequestDetailsViewController()
                vc.hire_agency_id = Int(id)
                self.navigationController?.pushViewController(vc, animated: true)
                }
        }
        else if NotificationType.CONTRACT_REJECTED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                let vc = ProjectDetailsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.REQUEST_REJECTED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                let vc = ProjectDetailsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.CONTRACT_ACCEPTED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                
                if (Profile.shared.details?.is_agency ?? "") == "No"{
                    let vc = ProjectDetailsViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = ProjectDetailsAgencyViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
        }
        else if NotificationType.HIRE_REQUEST_ACCEPTED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                if (Profile.shared.details?.is_agency ?? "") == "No"{
                    let vc = ProjectDetailsViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = ProjectDetailsAgencyViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
        }
        else if NotificationType.HIRE_REQUEST_REJECTED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                if (Profile.shared.details?.is_agency ?? "") == "No"{
                    let vc = ProjectDetailsViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = ProjectDetailsAgencyViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
        }
        //Projects
        else if NotificationType.PROJECT_CANCELLED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(id)
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.PROJECT_AWARDED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(id)
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.PROJECT_COMPLETED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
            let vc = RequestDetailsViewController()
            vc.hire_agency_id = Int(id)
            self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        
        //Milestone
        else if NotificationType.MILESTONE_PAYMENT_RECEIVED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                if (Profile.shared.details?.is_agency ?? "") == "No"{
                    let vc = ProjectDetailsViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = ProjectDetailsAgencyViewController()
                    self.navigationController?.pushViewController(vc, animated: true)
                }
               
            }
        }
        else if NotificationType.MILESTONE_PAYMENT_RELEASED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                let vc = ProjectDetailsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.MILESTONE_PAYMENT_REMINDER == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                let vc = ProjectDetailsAgencyViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        else if NotificationType.MILESTONE_PAYMENT_NOT_RECEIVED == NotificationType(rawValue: notify_type){
            if let id = notifications[indexPath.row].value{
                CreateContract.shared.project_id = Int(id)
                let vc = ProjectDetailsViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
            
    }
    
}


class NotificationTVcell : UITableViewCell{
    
    public var imgView : UIImageView!
    public var titleLabel : UILabel!
    public var infoLabel : UILabel!
    public var dateLabel : UILabel!
    
    private var bgView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = Color.gray.cgColor
        bgView.layer.cornerRadius = 5.0
            
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView).inset(10)
        }
        
        imgView = UIImageView()
        imgView?.image = UIImage(named: "notification_3")
        imgView?.clipsToBounds = true
        bgView.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(10)
            make.width.height.equalTo(50)
            make.top.equalTo(bgView).offset(10)
        }
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 16)
        bgView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(10)
            make.top.equalTo(bgView).offset(10)
            make.trailing.equalTo(bgView).offset(-10)
        }
        
        dateLabel = UILabel()
        dateLabel.textColor = Color.gray
        dateLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        bgView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.bottom.equalTo(bgView).offset(-05)
        }
        
        infoLabel = UILabel()
        infoLabel.textColor = Color.gray
        infoLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        infoLabel.numberOfLines = 0
        bgView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(titleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(05)
            make.bottom.equalTo(dateLabel.snp.top).offset(-10)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
