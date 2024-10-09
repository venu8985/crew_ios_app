//
//  ResponseViewController.swift
//  Crew
//
//  Created by Rajeev on 02/04/21.
//

import UIKit

class ResponseViewController: UIViewController {
    
    var isSuccess : Bool!
    var requestNo : String!
    var errorMessage : String!
    @IBOutlet weak var statusImgView : UIImageView!
    @IBOutlet weak var statusLabel : UILabel!
    @IBOutlet weak var messageLabel : UILabel!
    @IBOutlet weak var detailInfoLabel : UILabel!
    @IBOutlet weak var homeButtn : UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // Do any additional setup after loading the view.
        messageLabel.textAlignment = .center
//        statusLabel.textAlignment = .center
        detailInfoLabel.textAlignment = .center
        
        if isSuccess {
            statusImgView.image = UIImage(named: "GreenTick")
            
            if requestNo != nil{
//                statusLabel.text = "\(NSLocalizedString("Your request number for further discussion", comment: "")) #\(requestNo ?? "")"
            }
            
        }else{
            
            if let error = errorMessage{
                messageLabel.text = error
            }
//            statusLabel.textColor = Color.red
            statusImgView.image = UIImage(named: "RedTick")
//            statusLabel.isHidden = true
            detailInfoLabel.isHidden = true
        }
        
    }
    
    @IBAction func homeButtonAction (_ sender : Any){

        self.navigationController?.popToRootViewController(animated: true)
        
    }
    
}
