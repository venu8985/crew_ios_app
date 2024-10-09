//
//  AddMoneyViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 21/09/23.
//  Copyright © 2023 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class AddMoneyViewController: UIViewController {

    @IBOutlet weak var btnPaynow: UIButton!
    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var txtAmount: UITextField!
    var completionHandler:((Bool)->Void)?
    var isPaying = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            self.txtAmount.textAlignment = .right
        }else{
            self.txtAmount.textAlignment = .left
        }
        if isPaying{
            self.txtAmount.text = UserDefaults.standard.string(forKey: "agency_proposal_fees")
        }
        self.btnPaynow.action = {
            if let t = Int(self.txtAmount.text ?? "0"),t>=1{
               
            }else{
                Banner().displayValidationError(string: NSLocalizedString("Please enter the valid amount", comment: ""))
                return
            }
            let userId = Profile.shared.details?.id ?? 0
            let locale = UserDefaults.standard.value(forKey: "Language") as? String ?? ""
            let vc = PaymentViewController()
            vc.paymentUrl = Url.baseUrl+"/user/add-amount-wallet/\(userId)/\(self.txtAmount.text!)/\(locale)"
            vc.completionHandler = { status in
                self.completionHandler?(status)
                if status{
                    let vc = PaymentStatusViewController()
                    vc.isSuccess = true
                    vc.statusString = NSLocalizedString("Your payment has been processed...", comment: "")
                    vc.dismissHandler = {
                        self.dismiss(animated: false)
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    self.present(vc, animated: false)
                    
                }else{
                    let vc = PaymentStatusViewController()
                    vc.isSuccess = false
                    vc.statusString = NSLocalizedString("Couldn't intiate payment right now", comment: "")
                    vc.dismissHandler = {
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
