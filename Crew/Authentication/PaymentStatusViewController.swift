//
//  PaymentStatusViewController.swift
//  Crew
//
//  Created by Rajeev on 05/04/21.
//

import UIKit

class PaymentStatusViewController: UIViewController {

    var statusString : String!
    var isSuccess : Bool!
    var dismissHandler:(()->Void)?
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        let imageView = UIImageView()
        if isSuccess{
            imageView.image = UIImage(named: "GreenTick")
        }else{
            imageView.image = UIImage(named: "RedTick")
        }
        imageView.contentMode = .scaleAspectFit
        self.view.addSubview(imageView)
        
        imageView.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.width.height.equalTo(100)
        }
        
        imageView.layer.cornerRadius = 50.0
        imageView.clipsToBounds = true
        
        let statusLabel = UILabel()
        statusLabel.text = statusString
        statusLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 15)
        statusLabel.textAlignment = .center
        self.view.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(20)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if self.isModal{
                self.dismiss(animated: false){
                    self.dismissHandler?()
                }
            }else{
                self.navigationController?.popToRootViewController(animated: false)
            }
            NotificationCenter.default.post(name: Notification.dismissAuth, object: nil)
            NotificationCenter.default.post(name: Notification.dashboard, object: nil)
            NotificationCenter.default.post(name: Notification.profile, object: nil)
        }
        self.navigationBarItems()
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Success", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        
    }
    

}
