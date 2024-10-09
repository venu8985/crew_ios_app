//
//  MyContractsViewController.swift
//  Crew
//
//  Created by Rajeev on 11/03/21.
//

import UIKit

class MyContractsViewController: UIViewController {

    var tableView : UITableView!
    var selectedIndex : Int!
    var paginationCount = 0
    var lastPage : Int!
    var contracts = [Contract]()
    var delegate : ContractDelegate!
    var refreshControl : UIRefreshControl!
    var noContractsLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBarItems()
        
        self.view.backgroundColor = .white
        
              
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = self.view.bounds
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(ContractTVCell.self, forCellReuseIdentifier: "cell")
        
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        
        fetchContracts()
        
        noContractsLabel = UILabel()
        noContractsLabel.text = NSLocalizedString("No contracts found", comment: "")
        noContractsLabel.textAlignment = .center
        noContractsLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.view.addSubview(noContractsLabel)
        noContractsLabel.isHidden = true
        noContractsLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
        
    }
    
    @objc func paginationAction(){
        refreshControl.endRefreshing()
        fetchContracts()
    }
    
    func fetchContracts(){
        
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
        
        WebServices.postRequest(url: Url.myContracts, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let contractsResponse = try decoder.decode(MyContracts.self, from: data)
                self.lastPage = contractsResponse.data?.last_page
                if let contracts = contractsResponse.data?.data{
                    self.contracts.append(contentsOf: contracts)
                    self.tableView.reloadData()
                }
                
                if self.contracts.count>0{
                    self.tableView.isHidden = false
                    self.noContractsLabel.isHidden = true
                }else{
                    self.tableView.isHidden = true
                    self.noContractsLabel.isHidden = false
                }
                
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("My Contracts", comment: "")
        
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
        if delegate != nil{
            delegate.noContractSelected()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension MyContractsViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contracts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ContractTVCell
        
        cell.selectionStyle = .none
        
        cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
        
        let contract = self.contracts[indexPath.row]
        
        cell.contractNameLabel.text = contract.contract_name
        cell.contractIdlabel.text = contract.contract_number
        
        if let dateString = contract.created_at {
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
            
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                cell.dateLabel.textAlignment = .left
            }
            else{
                cell.dateLabel.textAlignment = .right
            }
           
        }
        
        
        if let index = selectedIndex{
            if index == indexPath.row{
                cell.bgView.layer.borderColor = UIColor.red.cgColor
            }
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil{
            selectedIndex = indexPath.row
            tableView.reloadData()
            delegate.savedContract(contract: contracts[indexPath.row])
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}


class ContractTVCell: UITableViewCell {
    
    var bgView : UIView!
    var imgView : UIImageView!
    var contractIdlabel : UILabel!
    var contractNameLabel : UILabel!
    var dateLabel : UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        bgView = UIView()
        bgView.backgroundColor = .clear
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview().inset(10)
        }
        
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.cornerRadius = 5.0
        bgView.clipsToBounds = true
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "car_rental")
        self.contentView.addSubview(imgView)
        
        imgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.leading.equalTo(bgView).offset(10)
            make.centerY.equalTo(bgView)
        }
        
        dateLabel = UILabel()
        dateLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        dateLabel.textAlignment = .right
        dateLabel.textColor = Color.gray
        bgView.addSubview(dateLabel)
        
        dateLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView).offset(-10)
            make.top.equalTo(imgView).offset(05)
        }
        
        
        contractIdlabel = UILabel()
        contractIdlabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        contractIdlabel.textColor = Color.liteBlack
        bgView.addSubview(contractIdlabel)
        
        contractIdlabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(05)
            make.trailing.equalTo(dateLabel.snp.leading).offset(-05)
            make.top.equalTo(imgView).offset(05)
        }
        
        contractNameLabel = UILabel()
        contractNameLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 16)
        contractNameLabel.textColor = Color.liteBlack
        bgView.addSubview(contractNameLabel)
        
        contractNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imgView.snp.trailing).offset(05)
            make.top.equalTo(contractIdlabel.snp.bottom).offset(05)
        }
        
        
    
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

