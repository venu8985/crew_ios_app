//
//  PremiumMembershipViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 22/09/23.
//  Copyright © 2023 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PremiumMembershipViewController: UIViewController {

    @IBOutlet weak var btnUpgrede: UIButton!
    @IBOutlet weak var btnNoThanks: UIButton!
    @IBOutlet weak var lblDay: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var lblFree: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblAmount.text = (Profile.shared.details?.registration_fees ?? "")+" SAR"
        self.lblDay.text = ""
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.dateFormat = "yyyy-MM-dd"
        let expireDate = formatter.date(from: (Profile.shared.details?.expired_at ?? "")) ?? Date()
        
        let t = expireDate.toAgeDays()
        self.lblDay.text =  t>0 ? t.description : "0"
        self.btnNoThanks.isHidden = t <= 0
        
        if Profile.shared.details?.payment_status == "Paid",t<=0{
            lblFree.text = NSLocalizedString("of Subscription", comment: "")
        }
        formatter.dateFormat = "dd, MMM yyyy"
        self.lblDate.text = formatter.string(from: expireDate)
        self.btnNoThanks.applyUnderline()
        self.btnUpgrede.action = {
            let vc = UIStoryboard.instantiateViewController(withViewClass: PayNowViewController.self)
            vc.modalPresentationStyle = .overFullScreen
            vc.completionHandler = { status in
                if status{
                    let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
                    AppDelegate.shared.window?.rootViewController = VC
                    let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
                    IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig
                }
            }
            vc.modalPresentationStyle = .overFullScreen
            let navi = UINavigationController(rootViewController: vc)
            navi.isNavigationBarHidden = true
            navi.modalPresentationStyle = .overFullScreen
            self.present(navi, animated: true)
        }
        self.btnNoThanks.action = {
            let parameters: [String: Any] = [
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
            ]
            
            WebServices.getRequest(url: Url.activatetrial, params: parameters, viewController: self) { success,data  in
                do {
                    let decoder = JSONDecoder()
                    let profileResponse = try decoder.decode(CompleteProfile.self, from: data)
                    if let profileData = profileResponse.data{
                        UserDetailsCrud().saveProfile(profile: profileData) { _ in
                            Profile.shared.details = profileData
                        }
                        let VC = UIStoryboard.instantiateViewController(withViewClass: MainTabbarViewController.self)
                        AppDelegate.shared.window?.rootViewController = VC
                        let doneBarButtonConfig = IQBarButtonItemConfiguration(title: NSLocalizedString("Done", comment: ""), action: nil)
                        IQKeyboardManager.shared.toolbarConfiguration.doneBarButtonConfiguration = doneBarButtonConfig
                    }
                }catch let error {
                    print("error \(error.localizedDescription)")
                }
            }
        }
    }
}
