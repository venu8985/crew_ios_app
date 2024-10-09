//
//  WalletViewController.swift
//  Crew
//
//  Created by Gaurav Gudaliya on 29/09/23.
//

import UIKit

class WalletViewController: UIViewController {

    @IBOutlet var tableView : UITableView!
    @IBOutlet var lblAmount : UILabel!
    var paginationCount = 0
    var lastPage : Int!
    var refreshControl : UIRefreshControl!
    @IBOutlet var btnAdd : UIButton!
    
    var list:[Payments] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBarItems()
        
        tableView.delegate = self
        tableView.dataSource = self
    
        refreshControl = UIRefreshControl.init(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        refreshControl.triggerVerticalOffset = 50.0
        refreshControl.addTarget(self, action: #selector(paginationAction), for: .valueChanged)
        tableView.bottomRefreshControl = refreshControl
        
        fetchAllPayments()
        self.btnAdd.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: AddMoneyViewController.self)
            vc.completionHandler = { status in
                if status{
                    self.updateProfileDetails()
                    self.paginationCount = 0
                    self.fetchAllPayments()
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            let navi = UINavigationController(rootViewController: vc)
            navi.isNavigationBarHidden = true
            navi.modalPresentationStyle = .overFullScreen
            self.present(navi, animated: true)
        }
        self.lblAmount.text = (Profile.shared.details?.wallet_amount ?? "0")+" "+"SAR"
        self.updateProfileDetails()
        // Do any additional setup after loading the view.
    }
    @objc func paginationAction(){
        refreshControl.endRefreshing()
        fetchAllPayments()
    }
    @objc func updateProfileDetails(){
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        
        WebServices.postRequest(url: Url.getProfile, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let profileResponse = try decoder.decode(CompleteProfile.self, from: data)
                if let profileData = profileResponse.data{
                    if profileData.name == nil { return }
                    UserDetailsCrud().saveProfile(profile: profileData) { _ in
                        Profile.shared.details = profileData
                        self.lblAmount.text = (profileData.wallet_amount ?? "0")+" "+"SAR"
                    }
                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
        }
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
                self.lastPage = paymentsList.data?.last_page
                
                if self.paginationCount == 1{
                    self.list = []
                }
                if let profiles = paymentsList.data?.data{
                    self.list.append(contentsOf: profiles)
                }
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
        
        self.title = NSLocalizedString("Wallet", comment: "")
        self.view.backgroundColor = .white
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.setImage(UIImage(named: "back-R")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        }else{
            backButton.setImage(UIImage(named: "back")?.withTintColor(.white, renderingMode: .alwaysTemplate), for: .normal)
        }
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        backButton.tintColor = .white
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
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.barTintColor = UIColor(hexString: "#333333")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.black]
        self.navigationController?.navigationBar.barTintColor = .white
    }
}
extension WalletViewController : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count//notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletTableviewCell") as! WalletTableviewCell
        if let dateString = self.list[indexPath.row].created_at {
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
            cell.lblDate.text = relativeDate
            
        }
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            cell.lblType.textAlignment = .right
            cell.lblDate.textAlignment = .right
        }else{
            cell.lblType.textAlignment = .left
            cell.lblDate.textAlignment = .left
        }
        if (self.list[indexPath.row].txn_type ?? "") == "Debit"{
            cell.lblAmount.text = " - "+(self.list[indexPath.row].amount ?? "")+" SAR"
            cell.lblType.text = NSLocalizedString("Used for Proposal", comment: "")
            cell.typeImg.image = UIImage(named: "arrow_outward 1")
            cell.lblAmount.textColor = UIColor(hexString: "#D70226")
        }else if (self.list[indexPath.row].txn_type ?? "") == "Credit"{
            cell.lblAmount.text = " + "+(self.list[indexPath.row].amount ?? "")+" SAR"
            cell.lblType.text = NSLocalizedString("Deposit to wallet", comment: "")
            cell.typeImg.image = UIImage(named: "arrow_outward")
            cell.lblAmount.textColor = UIColor(hexString: "#16C083")
        }else{
            cell.lblAmount.text = " - "+(self.list[indexPath.row].amount ?? "")+" SAR"
            cell.lblType.text = NSLocalizedString("Refunded to wallet", comment: "")
            cell.typeImg.image = UIImage(named: "arrow_outward 1")
            cell.lblAmount.textColor = UIColor(hexString: "#D70226")
        }
        cell.selectionStyle = .none
        return cell
        
    }
    
}
class WalletTableviewCell:UITableViewCell{
    @IBOutlet var typeImg : UIImageView!
    @IBOutlet var lblAmount : UILabel!
    @IBOutlet var lblType : UILabel!
    @IBOutlet var lblDate : UILabel!
}
