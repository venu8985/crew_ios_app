//
//  PaymentsViewController.swift
//  Crew
//
//  Created by Rajeev on 21/04/21.
//

import UIKit

class PaymentsViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    var paginationCount = 0
    var lastPage : Int!
    var refreshControl : UIRefreshControl!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
                
        navigationBarItems()
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        self.view.addSubview(tableView)
        tableView.register(NotificationTVcell.self, forCellReuseIdentifier: "NotificationCell")
        
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        
        fetchAllPayments()
    }
    
    @objc func paginationAction(){
        refreshControl.endRefreshing()
        fetchAllPayments()
    }
    
    @objc func fetchAllPayments(){
        
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
        
        WebServices.postRequest(url: Url.paymentsList, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let paymentsList = try decoder.decode(PaymentsList.self, from: data)

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            } catch let error {
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                print(error)
            }
        }
        
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Payments", comment: "")
        self.view.backgroundColor = .white
        
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

extension PaymentsViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12//notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell") as! NotificationTVcell
        cell.selectionStyle = .none    
        return cell
        
    }
    
}
