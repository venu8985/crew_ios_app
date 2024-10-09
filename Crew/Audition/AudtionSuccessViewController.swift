//
//  AudtionSuccessViewController.swift
//  Crew
//
//  Created by Rajeev on 19/04/21.
//

import UIKit

class AudtionSuccessViewController: UIViewController {

    @IBOutlet weak var backHomeButton : UIButton!
    @IBOutlet weak var infoLabel : UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.isHidden = true
        
        backHomeButton.layer.cornerRadius = 5.0
        backHomeButton.clipsToBounds = true
        infoLabel.text = NSLocalizedString("Your request has been sent to the resources", comment: "")
        backHomeButton.setTitle(NSLocalizedString("Back to home", comment: ""), for: .normal)
    }
 
    @IBAction func back2Home (_ sender : Any){
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.popToRootViewController(animated: true)

    }
    

}
