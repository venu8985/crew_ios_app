//
//  RequestsViewController.swift
//  Crew
//
//  Created by Rajeev on 13/04/21.
//

import UIKit

class RequestsViewController: UIViewController {
    
    var paginationCount = 0
    var lastPage : Int!
    
    var awardPaginationCount = 0
    var awardLastPage : Int!
    
    var tableView : UITableView!
    var requests = [AgencyRequest]()
    var segment : UISegmentedControl!
    var refreshControl = UIRefreshControl()
    var bottomRefreshControl = UIRefreshControl()

    var listIndex : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.navigationBarItems()
        
        let items = [NSLocalizedString("Requests", comment: ""),
                    NSLocalizedString("Awarded", comment: "")]
        segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        let font = UIFont.systemFont(ofSize: 12)
        segment.addTarget(self, action: #selector(self.segmentedControlValueChanged), for: .valueChanged)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        segment.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .selected)
        
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: Color.red], for: .selected)
        segment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.darkGray], for: .normal)
        self.view.addSubview(segment)
        
        segment.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(25)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        listIndex = 0
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(RequestTVCell.self, forCellReuseIdentifier: "cell")

        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-10)
            make.top.equalTo(segment.snp.bottom).offset(10)
        }
        
        refreshControl.attributedTitle = NSAttributedString(string: "")
        refreshControl.addTarget(self, action: #selector(self.refresh(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl) // not required when using UITableViewController

        
        
        bottomRefreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        bottomRefreshControl.triggerVerticalOffset = 50.0
        bottomRefreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        tableView.bottomRefreshControl = bottomRefreshControl
        
        navigationBarItems()
 
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadNewRequests), name: Notification.agencyRequests, object: nil)
        
    }
    
    @objc func loadNewRequests(){
        self.requests.removeAll()
        if listIndex == 0{
            loadRequests()
        }else{
            loadAwardRequests()
        }
    }
    
    @objc func paginationAction(){
        
        if listIndex == 0{
            fetchRequests()
        }else{
            fetchAwardRequests()
        }
        
        bottomRefreshControl.endRefreshing()
    }
    
    
    @objc func refresh(_ sender: AnyObject) {
        // Code to refresh table view
        refreshControl.endRefreshing()
        requests = [AgencyRequest]()
        if listIndex == 0{
            loadRequests()
        }else{
            loadAwardRequests()
        }
    }
    
    @objc func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        requests = [AgencyRequest]()

        if sender.selectedSegmentIndex == 0 {
            listIndex = 0
            loadRequests()
            
        }else if sender.selectedSegmentIndex == 1{
            listIndex = 1
            loadAwardRequests()
        }
    }
    
    @objc func loadAwardRequests(){
        awardPaginationCount = 0
        fetchAwardRequests()
    }
    
    func fetchAwardRequests(){
        
        if awardLastPage == awardPaginationCount{
            return
        }
        
        awardPaginationCount += 1
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "page" : "\(awardPaginationCount)"
        ]

        WebServices.postRequest(url: Url.awardRequests, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getAgencyRequests = try decoder.decode(AgencyRequests.self, from: data)
                self.awardLastPage = getAgencyRequests.data?.last_page
                if let requests = getAgencyRequests.data?.data{
                    self.requests.append(contentsOf: requests)
                    self.tableView.reloadData()
                }
                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    @objc func loadRequests(){
        paginationCount = 0
        fetchRequests()
    }
    
    func fetchRequests(){
        
        if lastPage == paginationCount{
            return
        }
        
        paginationCount += 1
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "page" : "\(paginationCount)"
        ]

        WebServices.postRequest(url: Url.agencyRequests, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let getAgencyRequests = try decoder.decode(AgencyRequests.self, from: data)
                self.lastPage = getAgencyRequests.data?.last_page
                if let requests = getAgencyRequests.data?.data{
                    self.requests.append(contentsOf: requests)
                    self.tableView.reloadData()
                }
                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
    func navigationBarItems() {
        self.title = NSLocalizedString("Requests", comment: "")
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
        self.loadNewRequests()
    }
}

extension RequestsViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RequestTVCell
        
        cell.selectionStyle = .none
        if  requests.count>indexPath.row{
            let request = requests[indexPath.row]
            cell.projectNameTextfield.text = request.name
            let location = "  \(request.city_name),\(request.country_name)"
            cell.locationButton.setTitle(location, for: .normal)
            
            
            if request.status == "Proposal Generated"{
                cell.statusLabel.text = NSLocalizedString(request.status , comment: "")
                cell.statusLabel.textColor = Color.green
                cell.dotView.backgroundColor = Color.green
            }else{
                cell.statusLabel.text = NSLocalizedString(request.status , comment: "")
                cell.statusLabel.textColor = Color.red
                cell.dotView.backgroundColor = Color.red
            }
            
            
            let budgetString = request.budget
            let budgetFloat = Float(budgetString)
            let budget = Int(budgetFloat ?? 0)
            cell.budgetLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(budget)"
            
            
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let startDate = dateFormatter.date(from: request.start_at )
            let endDate = dateFormatter.date(from: request.end_at )
            
            dateFormatter.dateFormat = "dd MMM yyyy"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            if let date = startDate{
                let dateString = dateFormatter.string(from: date)
                cell.startLabel.text = dateString
            }
            if let date = endDate{
                let dateString = dateFormatter.string(from: date)
                cell.stopLabel.text = dateString
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = RequestDetailsViewController()
        vc.hire_agency_id = requests[indexPath.row].id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


class RequestTVCell: UITableViewCell {
    
    var projectNameTextfield : FloatingTextfield!
    var startLabel : UILabel!
    var stopLabel : UILabel!
    var budgetLabel : UILabel!
    var locationButton : UIButton!
    var statusLabel : UILabel!
    var dotView : UIView!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        projectNameTextfield = FloatingTextfield()
        projectNameTextfield.placeholderFont = UIFont(name: "AvenirLTStd-Book", size: 12)
        projectNameTextfield.placeholder = NSLocalizedString("Project Name", comment: "")
        projectNameTextfield.backgroundColor = .white
        projectNameTextfield.leftPadding = 10
        projectNameTextfield.rightPadding = 35
        projectNameTextfield.keyboardType = .numberPad
        projectNameTextfield.font = UIFont(name: "Avenir Medium", size: 12)
        self.contentView.addSubview(projectNameTextfield)
        
        projectNameTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.contentView).inset(20)
            make.top.equalTo(self.contentView).offset(15)
            make.height.equalTo(46)
        }
        
        projectNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        projectNameTextfield.layer.cornerRadius = 5.0
        projectNameTextfield.layer.borderWidth = 0
        projectNameTextfield.clipsToBounds = true
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            projectNameTextfield.textAlignment = .right
            projectNameTextfield.titleLabel.textAlignment = .right
        }else{
            projectNameTextfield.textAlignment = .left
            projectNameTextfield.titleLabel.textAlignment = .left
        }
        
        
        statusLabel = UILabel()
        statusLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        statusLabel.textColor = Color.red
        
        self.contentView.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.top.trailing.equalTo(projectNameTextfield)
        }
        self.contentView.bringSubviewToFront(statusLabel)
        
        dotView = UIView()
        self.contentView.addSubview(dotView)
        
        dotView.snp.makeConstraints { (make) in
            make.width.height.equalTo(08)
            make.trailing.equalTo(statusLabel.snp.leading).offset(-4)
            make.top.equalTo(statusLabel)
        }
        dotView.layer.cornerRadius = 4.0
        dotView.clipsToBounds = true
        
        let lineView = UIView()
        lineView.frame = CGRect(x: 30, y: 55, width: self.contentView.frame.size.width, height: 0.25)
        self.contentView.addSubview(lineView)
//        lineView.backgroundColor = .green
        drawDottedLine(start: CGPoint(x: lineView.bounds.minX, y: lineView.bounds.minY), end: CGPoint(x: lineView.bounds.maxX, y: lineView.bounds.minY), view: lineView)

        
        let dateTimelineButton = UIButton()
        dateTimelineButton.setTitleColor(UIColor.red, for: .normal)
        dateTimelineButton.setTitle(NSLocalizedString("  Dates / Timeline ", comment: ""), for: .normal)
        dateTimelineButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        let dateImage = UIImage(named: "date_timeline")
        //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        dateTimelineButton.setImage(dateImage, for: .normal)
        dateTimelineButton.isUserInteractionEnabled = false
        self.contentView.addSubview(dateTimelineButton)
        
        dateTimelineButton.snp.makeConstraints { (make) in
            make.leading.equalTo(lineView).offset(5)
            make.top.equalTo(lineView.snp.bottom).offset(15)
            
        }
        
        
        let startButton = StartStopButton()
        startButton.isUserInteractionEnabled = false
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        startButton.setTitle(NSLocalizedString("Start   ", comment: ""), for: .normal)
        self.contentView.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-14)
            make.top.equalTo(dateTimelineButton.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
//        startButton.imageEdgeInsets = UIEdgeInsets(top: 04, left: 30, bottom: 04, right: 36)
        
        
        let stopButton = StartStopButton()
        stopButton.isUserInteractionEnabled = false
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        stopButton.setTitle(NSLocalizedString("Stop    ", comment: ""), for: .normal)
        self.contentView.addSubview(stopButton)
        
        stopButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-14)
            make.top.equalTo(startButton.snp.bottom).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(80)
        }
//        stopButton.imageEdgeInsets = UIEdgeInsets(top: 05, left: 31, bottom: 03, right: 35);
        
        
        let lineView1 = UIView()
        lineView1.backgroundColor = .lightGray
        self.contentView.addSubview(lineView1)
        
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
        self.contentView.addSubview(startLabel)
        
        startLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startButton)
            make.leading.equalTo(startButton.snp.trailing).offset(-10)
        }
        
        
        stopLabel = UILabel()
        stopLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.contentView.addSubview(stopLabel)
        
        stopLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stopButton)
            make.leading.equalTo(stopButton.snp.trailing).offset(-10)
        }
        
           
        budgetLabel = UILabel()
        budgetLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.contentView.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startLabel)
            make.leading.equalTo(startLabel.snp.trailing).offset(45)
        }
        
        let projectBudgetButton = UIButton()
        projectBudgetButton.setTitleColor(UIColor.red, for: .normal)
        projectBudgetButton.setTitle(NSLocalizedString("  Project Budget ", comment: ""), for: .normal)
        projectBudgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        let budgetImage = UIImage(named: "project_budget")
            //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        projectBudgetButton.setImage(budgetImage, for: .normal)
        projectBudgetButton.isUserInteractionEnabled = false
        self.contentView.addSubview(projectBudgetButton)
        
        projectBudgetButton.snp.makeConstraints { (make) in
            make.leading.equalTo(startLabel.snp.trailing).offset(45)
            make.top.equalTo(dateTimelineButton)
            make.width.equalTo(120)
        }

        
        let lineView3 = UIView()
        lineView3.backgroundColor = Color.gray
        self.contentView.addSubview(lineView3)
        
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
        locationButton.setTitleColor(UIColor.gray, for: .normal)
        locationButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        locationButton.setImage(locationImage, for: .normal)
//        locationButton.contentHorizontalAlignment = .left
//        locationButton.semanticContentAttribute = .forceRightToLeft
        self.contentView.addSubview(locationButton)
        
        locationButton.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(lineView3)
            make.top.equalTo(lineView3.snp.bottom).offset(10)
        }
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            locationButton.contentHorizontalAlignment = .right
        }else{
            locationButton.contentHorizontalAlignment = .left
        }
        
        let bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView).inset(5)
        }
        bgView.layer.cornerRadius = 5.0
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = Color.gray.cgColor
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
