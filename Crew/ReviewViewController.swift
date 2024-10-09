//
//  ReviewViewController.swift
//  Crew
//
//  Created by Rajeev on 12/04/21.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet weak var imageView : UIImageView!
    @IBOutlet weak var titleLabel : UILabel!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var infoLabel : UILabel!
    @IBOutlet weak var backButton : UIButton!

    var profileStatus : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        self.navigationController?.navigationBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountVerified), name: Notification.verified, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.accountRejected), name: Notification.rejected, object: nil)

        if let status = profileStatus{
            if status == "Rejected"{
                accountRejected()
            }
        }
        
    }
    @objc func accountVerified(){
        messageLabel.isHidden = true
        infoLabel.isHidden = true
        backButton.isHidden = true
        titleLabel.text = NSLocalizedString("Account verified", comment: "")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func accountRejected(){
        imageView.image = UIImage(named: "RedTick")
        messageLabel.isHidden = true
        infoLabel.isHidden = true
        backButton.isHidden = true
        titleLabel.text = NSLocalizedString("Account Rejected", comment: "")
        titleLabel.textColor = Color.red
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            UserDefaults.standard.removeObject(forKey: "isExistingUser")
            self.navigationController?.popToRootViewController(animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
    }
    

    @IBAction func backAction(_ sender: Any) {
        UserDefaults.standard.removeObject(forKey: "isExistingUser")
        self.navigationController?.popToRootViewController(animated: true)
    }
    

}
