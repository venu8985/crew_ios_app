//
//  ExpireViewController.swift
//  Crew
//
//  Created by Rajeev on 06/04/21.
//

import UIKit
import SafariServices

class ExpireViewController: UIViewController,OPPCheckoutProviderDelegate {
    
    var checkoutId : String! {
        didSet{
            intiatePayment()
        }
    }
    
    var safariVC : SFSafariViewController!
    //Payment
    let provider = OPPPaymentProvider(mode: OPPProviderMode.test)
    var checkoutProvider : OPPCheckoutProvider!
    var transaction : OPPTransaction!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        let imageView = UIImageView()
        imageView.image = UIImage(named: "RedTick")
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.height.equalTo(100)
        }
        
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        
        let statusLabel = UILabel()
        statusLabel.text = "Your account has been expired..!"
        statusLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 15)
        statusLabel.textAlignment = .center
        statusLabel.numberOfLines = 0
        self.view.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
    
        let payNowButton = UIButton()
        payNowButton.setTitle(NSLocalizedString("Pay Now", comment: ""), for: .normal)
        payNowButton.backgroundColor = Color.red
        payNowButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        payNowButton.addTarget(self, action: #selector(self.paynowAction), for: .touchUpInside)
        self.view.addSubview(payNowButton)
        
        payNowButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.top.equalTo(statusLabel.snp.bottom).offset(30)
            make.leading.trailing.equalTo(self.view).inset(30)
        }
        
        payNowButton.layer.cornerRadius = 5.0
        payNowButton.clipsToBounds = true
        
        
        
        self.navigationBarItems()
    }
    
    @objc func paynowAction(){
        
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
                    self.checkoutId = response.data?.id
                }
                catch let error {
                    print("error \(error.localizedDescription)")
                }
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Couldn't intiate payment right now", comment: ""))
            }
        }
    }
    
    
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Expired", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        
    }
    
    
    func intiatePayment(){
        
        self.checkoutProvider = self.configureCheckoutProvider(checkoutID: self.checkoutId)
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
