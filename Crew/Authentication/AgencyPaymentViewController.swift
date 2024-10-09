//
//  AgencyPaymentViewController.swift
//  Crew
//
//  Created by Rajeev on 18/03/21.
//

import UIKit
import SafariServices

class AgencyPaymentViewController: UIViewController,OPPCheckoutProviderDelegate {

    var walletView : UIView!
    var ccView : UIView!
    
    var walletTickImageView : UIImageView!
    var ccTickImageView : UIImageView!
    var supprt : Support?
    var amountString : String?
    var safariVC: SFSafariViewController?
    var checkoutId : String!
    //Payment
    let provider = OPPPaymentProvider(mode: OPPProviderMode.test)
    var checkoutProvider : OPPCheckoutProvider!
    var transaction : OPPTransaction!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.amountString = "\(NSLocalizedString("SAR", comment: "")) \(amountString ?? "")"
        // Do any additional setup after loading the view.
        
        navigationBarItems()
        
        self.view.backgroundColor = Color.litePurple
        
        
        
        let bottomView = UIView()
        bottomView.backgroundColor = .white
        self.view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(self.view).dividedBy(1.5)
        }
        
        let infoView = UIView()
        infoView.backgroundColor = .white
        self.view.addSubview(infoView)
        
        infoView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(100)
            make.bottom.equalTo(bottomView.snp.top).offset(50)
        }
        infoView.layer.cornerRadius = 10.0
//        infoView.clipsToBounds = true
        infoView.layer.borderWidth = 0.5
        infoView.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.25).cgColor
        
        
        infoView.layer.shadowColor = UIColor.darkGray.cgColor
        infoView.layer.shadowOpacity = 0.3
        infoView.layer.shadowOffset = CGSize.zero
        infoView.layer.shadowRadius = 6
        
        self.view.bringSubviewToFront(infoView)
        
        let paymentLabel = UILabel()
        paymentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 15)
        paymentLabel.numberOfLines = 0
        paymentLabel.textColor = UIColor.darkGray
        paymentLabel.textAlignment = .center
        infoView.addSubview(paymentLabel)
        
        
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 05
        paragraphStyle.alignment = .center
        let attrString = NSMutableAttributedString(string: "\(NSLocalizedString("Please Make the payment of ", comment: ""))\(amountString ?? "") \(NSLocalizedString("to continue with application", comment: ""))")
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        attrString.addAttribute(.foregroundColor, value:Color.red.withAlphaComponent(0.7), range:NSMakeRange(27, amountString!.count))
        attrString.addAttribute(.font, value:UIFont(name: "AvenirLTStd-Black", size: 14), range:NSMakeRange(27, amountString!.count))
        paymentLabel.attributedText = attrString
                
        paymentLabel.snp.makeConstraints { (make) in
            make.top.bottom.leading.trailing.equalTo(infoView).inset(10)
        }
        
        let paymentIcon = UIImageView()
        paymentIcon.contentMode = .scaleAspectFit
        paymentIcon.image = UIImage(named: "oh_snap")
        self.view.addSubview(paymentIcon)

        paymentIcon.snp.makeConstraints { (make) in
            make.width.height.equalTo(125)
            make.bottom.equalTo(infoView.snp.top).offset(-25)
            make.centerX.equalTo(self.view)
        }
        
        
        let supportLabel = UILabel()
        supportLabel.font = UIFont(name: "AvenirLTStd-Book", size: 15)
        supportLabel.numberOfLines = 0
        supportLabel.textColor = UIColor.darkGray
        supportLabel.textAlignment = .center
        bottomView.addSubview(supportLabel)
        
        paragraphStyle.lineSpacing = 07
        paragraphStyle.alignment = .center
        let attrString1 = NSMutableAttributedString(string: NSLocalizedString("If you face any issue while making the payment kindly contact support at", comment: ""))
        attrString1.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString1.length))
        attrString1.addAttribute(.font, value:UIFont(name: "AvenirLTStd-Book", size: 12), range:NSMakeRange(0, attrString1.length))
        supportLabel.attributedText = attrString1
        paymentLabel.font = UIFont(name: "AvenirLTStd-Book", size: 15)

        supportLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(infoView).inset(10)
            make.top.equalTo(infoView.snp.bottom).offset(25)
        }
        
        
        let phoneNumberLabel = UILabel()
        phoneNumberLabel.font = UIFont(name: "AvenirLTStd-Black", size: 13)
        phoneNumberLabel.text = "+966 567876545"//supprt?.mobile
        phoneNumberLabel.textColor = Color.red
        phoneNumberLabel.textAlignment = .center
        bottomView.addSubview(phoneNumberLabel)
        
        phoneNumberLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(supportLabel.snp.bottom).offset(15)
        }
        
        
        let writeUslabel = UILabel()
        writeUslabel.font = UIFont(name: "AvenirLTStd-Book", size: 15)
        writeUslabel.numberOfLines = 0
        writeUslabel.text = NSLocalizedString("or write us at", comment: "")
        writeUslabel.textColor = UIColor.darkGray
        writeUslabel.textAlignment = .center
        bottomView.addSubview(writeUslabel)
        
        writeUslabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(phoneNumberLabel.snp.bottom).offset(20)
        }
        
        let emailLabel = UILabel()
        emailLabel.font = UIFont(name: "AvenirLTStd-Black", size: 13)
        emailLabel.text = "support@crew.com"//supprt?.mobile
        emailLabel.textColor = Color.red
        emailLabel.textAlignment = .center
        bottomView.addSubview(emailLabel)
        
        emailLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(writeUslabel.snp.bottom).offset(10)
        }
        
        
        let payNowButton = UIButton()
        payNowButton.setTitle(NSLocalizedString("Pay Now", comment: ""), for: .normal)
        payNowButton.backgroundColor = Color.red
        payNowButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        payNowButton.addTarget(self, action: #selector(self.paynowAction), for: .touchUpInside)
        bottomView.addSubview(payNowButton)
        
        payNowButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.top.equalTo(emailLabel.snp.bottom).offset(20)
            make.leading.trailing.equalTo(infoView)
        }
        
        payNowButton.layer.cornerRadius = 5.0
        payNowButton.clipsToBounds = true
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Registration Payment", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.setImage(UIImage(named: ""), for: .normal)
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
//        backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func paynowAction(){
        // http://crew-sa.com/user/make-payment/{user_id}/{locale}
        print(Profile.shared.details?.id as Any)
        let userId = Profile.shared.details?.id ?? 0
        let locale = UserDefaults.standard.value(forKey: "Language") as? String ?? ""
            let vc = PaymentViewController()
            vc.paymentUrl = Url.baseUrl+"/user/make-payment/\(userId)/\(locale)"
            vc.completionHandler = { status in
                if status{
                    let vc = PaymentStatusViewController()
                    vc.isSuccess = true
                    vc.statusString = NSLocalizedString("Your payment has been processed...", comment: "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }else{
                    let vc = PaymentStatusViewController()
                    vc.isSuccess = false
                    vc.statusString = NSLocalizedString("Your payment has been failed...", comment: "")
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        
        
        
        /*
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "payment_mode" : "HyperPay"
        ]
        
        WebServices.postRequest(url: Url.payment, params: parameters, viewController: self) { success,data  in
            if success{
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(Payment.self, from: data)
                    self.payment(checkoutId: response.data?.id ?? "")
                }
                catch let error {
                    print("error \(error.localizedDescription)")
                }
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Couldn't intiate payment right now", comment: ""))
            }
        }
 */
    }
    

    
    func payment(checkoutId : String){
        
        self.checkoutId = checkoutId
        self.checkoutProvider = self.configureCheckoutProvider(checkoutID: checkoutId)
        self.checkoutProvider?.delegate = self
        self.checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
            DispatchQueue.main.async {
                self.handleTransactionSubmission(transaction: transaction, error: error)
            }
        }, cancelHandler: nil)
                
    }
    
    // MARK: - Payment helpers
    
    func handleTransactionSubmission(transaction: OPPTransaction?, error: Error?) {
        guard let transaction = transaction else {
            return
        }
        
        self.transaction = transaction
        if transaction.type == .synchronous {
            self.requestPaymentStatus()
        } else if transaction.type == .asynchronous {
            NotificationCenter.default.addObserver(self, selector: #selector(self.didReceiveAsynchronousPaymentCallback), name: NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
            self.safariVC = SFSafariViewController(url: self.transaction!.redirectURL!)
            self.topViewController()?.navigationController?.pushViewController(self.safariVC!, animated: true)
        } else {
            Banner().displayValidationError(string: NSLocalizedString("Invalid transaction", comment: ""))

        }
    }
    
    func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
    
    func configureCheckoutProvider(checkoutID: String) -> OPPCheckoutProvider? {
        let provider = OPPPaymentProvider.init(mode: .test)
        let checkoutSettings = self.configureCheckoutSettings()
        checkoutSettings.paymentBrands = ["VISA", "MASTER"]
        checkoutSettings.displayTotalAmount = true
        checkoutSettings.storePaymentDetails = .prompt
        return OPPCheckoutProvider.init(paymentProvider: provider, checkoutID: checkoutID, settings: checkoutSettings)
    }
    
    
    @objc func didReceiveAsynchronousPaymentCallback() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil)
        
        
        self.checkoutProvider?.dismissCheckout(animated: true) {
            DispatchQueue.main.async {
                self.requestPaymentStatus()
            }
        }
    }
        
    func requestPaymentStatus() {
        
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "payment_mode" : "HyperPay",
            "checkout_id" : self.checkoutId ?? ""
        ]
        
        WebServices.postRequest(url: Url.status, params: parameters, viewController: self) { success,data  in
            if success{
                do {
                    let decoder = JSONDecoder()
                    let response = try decoder.decode(PaymentDetails.self, from: data)
                    print("payment response")
                    DispatchQueue.main.async {
                        let vc = PaymentStatusViewController()
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
                catch let error {
                    print("error \(error.localizedDescription)")
                }
            }else{
                Banner().displayValidationError(string: "Error")
            }
        }
    }
    
    //MARK: payment settings
    
    func configureCheckoutSettings() -> OPPCheckoutSettings {
        let checkoutSettings = OPPCheckoutSettings.init()
        checkoutSettings.paymentBrands = ["VISA", "MASTER"]
        checkoutSettings.shopperResultURL = Url.scheme + "://result"
        
        checkoutSettings.theme.navigationBarBackgroundColor = Color.red
        checkoutSettings.theme.confirmationButtonColor = Color.red
        checkoutSettings.theme.accentColor = Color.red
        checkoutSettings.theme.cellHighlightedBackgroundColor = Color.red
        checkoutSettings.theme.sectionBackgroundColor = Color.red.withAlphaComponent(0.05)
        
        return checkoutSettings
    }    
    
    func application(_ application: UIApplication, shouldAllowExtensionPointIdentifier extensionPointIdentifier: UIApplication.ExtensionPointIdentifier) -> Bool {
        if (extensionPointIdentifier == UIApplication.ExtensionPointIdentifier.keyboard) {
            return false
        }
        return true
    }

}

//extension AppDelegate{
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        
//        var handler:Bool = false
//        if url.scheme?.caseInsensitiveCompare(Url.scheme) == .orderedSame {
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AsyncPaymentCompletedNotificationKey"), object: nil, userInfo: nil)
//            handler = true
//        }
//        return handler
//    }
//}
