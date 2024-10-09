//
//  PaymentSuccessViewController.swift
//  CrewService
//
//  Created by Gaurav Gudaliya on 21/09/23.
//  Copyright © 2023 Gaurav Gudaliya R. All rights reserved.
//

import UIKit

class PaymentSuccessViewController: UIViewController {

    @IBOutlet weak var btnViewDetail: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.btnViewDetail.action = {
            self.dismiss(animated: true)
        }
    }
}
