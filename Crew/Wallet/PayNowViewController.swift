//
//  PayNowViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 22/09/23.
//  Copyright © 2023 Gaurav Gudaliya R. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class PayNowViewController: UIViewController {

    @IBOutlet weak var btnPaynow: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblAmount: UILabel!
    var completionHandler:((Bool)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblAmount.text = (Profile.shared.details?.registration_fees ?? "")+" SAR"
        self.btnPaynow.action = {
            let userId = Profile.shared.details?.id ?? 0
            let locale = UserDefaults.standard.value(forKey: "Language") as? String ?? ""
            let vc = PaymentViewController()
            vc.paymentUrl = Url.baseUrl+"/user/make-payment/\(userId)/\(locale)"
            vc.completionHandler = { status in
                
                if status{
                    let vc = PaymentStatusViewController()
                    vc.isSuccess = true
                    vc.statusString = NSLocalizedString("Your payment has been processed...", comment: "")
                    vc.dismissHandler = {
                        self.completionHandler?(status)
                        self.dismiss(animated: false)
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false)
                }else{
                    let vc = PaymentStatusViewController()
                    vc.isSuccess = false
                    vc.statusString = NSLocalizedString("Couldn't intiate payment right now", comment: "")
                    vc.dismissHandler = {
                        self.completionHandler?(status)
                        self.dismiss(animated: false)
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false)
                }
            }
            self.navigationController?.pushViewController(vc, animated: true)
        }
        self.btnClose.action = {
            self.dismiss(animated: true)
        }
    }
}
