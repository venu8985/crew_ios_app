//
//  ProposalWalletViewController.swift
//  Crew
//
//  Created by Gaurav Gudaliya on 29/09/23.
//

import UIKit

class ProposalWalletViewController: UIViewController {

    @IBOutlet var lblAmount : UILabel!
    @IBOutlet var btnAdd : UIButton!
    @IBOutlet var btnCancel : UIButton!
    @IBOutlet var lblDesscription : UILabel!
    var proposalId = 0
    var completionHandler:((Bool)->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btnCancel.applyUnderline()
        self.btnCancel.action = {
            self.completionHandler?(false)
            self.dismiss(animated: true)
        }
        self.btnAdd.action = {
            func payFee(){
                let parameters: [String: Any] = [
                    "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                    "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                    "device_id": UIDevice.current.identifierForVendor!.uuidString,
                    "device_type" : "ios",
                    "proposal_id" : self.proposalId,
                ]

                WebServices.postRequest(url: Url.payproposal, params: parameters, viewController: self) { success,data  in
                    do {
                        self.completionHandler?(true)
                        self.dismiss(animated: true)
                    }catch let error {
                        print("error \(error.localizedDescription)")
                    }
                }
            }
            if let amount = Double(Profile.shared.details?.wallet_amount ?? "0"),let fee = Double(UserDefaults.standard.string(forKey: "agency_proposal_fees") ?? "0"),amount >= fee{
                payFee()
            }else{
                    let vc = UIStoryboard.instantiateViewController(withViewClass: AddMoneyViewController.self)
                    vc.isPaying = true
                    vc.completionHandler = { status in
                        self.updateProfileDetails()
                    }
                    vc.modalPresentationStyle = .overFullScreen
                    let navi = UINavigationController(rootViewController: vc)
                    navi.isNavigationBarHidden = true
                    navi.modalPresentationStyle = .overFullScreen
                    self.present(navi, animated: true)
            }
        }
        self.lblAmount.text = (Profile.shared.details?.wallet_amount ?? "0")+" "+"SAR"
        self.lblDesscription.text = String(format: NSLocalizedString("There is a fee of %@ SAR applicable for creating a proposal, please make sure that your wallet has sufficient balance to deduct proposal fee.\n\nIn case, you don’t have wallet balance please pay from your card.", comment: ""), UserDefaults.standard.string(forKey: "agency_proposal_fees") ?? "0")
        self.updateProfileDetails()
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
                    }
                    self.lblAmount.text = (Profile.shared.details?.wallet_amount ?? "0")+" "+"SAR"
                    self.lblDesscription.text = String(format: NSLocalizedString("There is a fee of %@ SAR applicable for creating a proposal, please make sure that your wallet has sufficient balance to deduct proposal fee.\n\nIn case, you don’t have wallet balance please pay from your card.", comment: ""), UserDefaults.standard.string(forKey: "agency_proposal_fees") ?? "0")
                }
            }catch let error {
                print("error \(error.localizedDescription)")
            }
        }
    }
}
