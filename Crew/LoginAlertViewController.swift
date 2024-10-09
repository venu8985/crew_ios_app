//
//  LoginAlertViewController.swift
//  Crew
//
//  Created by Rajeev on 23/04/21.
//

import UIKit

class LoginAlertViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        
        let bgView = UIView()
        bgView.backgroundColor = UIColor.white
        self.view.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.height.equalTo(370)
        }
        

        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("   Login Alert", comment: "")
        titleLabel.font = UIFont(name: "AvenirLTStd-Book", size: 20)
        bgView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(5)
            make.leading.equalTo(bgView).offset(5)
            make.height.equalTo(44)
            make.trailing.equalTo(bgView).inset(50)
            
        }
        
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        bgView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(0.5)
        }
        
        let iconView = UIImageView()
        iconView.image = UIImage(named: "login_alert")
        bgView.addSubview(iconView)
        
        iconView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineView).offset(30)
            make.width.height.equalTo(50)
        }
        
        let infoLabel = UILabel()
        infoLabel.text = NSLocalizedString("You have to login to access more features.", comment: "")
        infoLabel.numberOfLines = 0
        infoLabel.textAlignment = .center
        infoLabel.font = UIFont(name: "Avenir Medium", size: 17)
        bgView.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(iconView.snp.bottom).offset(10)
            make.centerX.equalTo(iconView)
            make.width.equalToSuperview().dividedBy(1.5)
        }
        let infoLabel1 = UILabel()
        infoLabel1.textColor = Color.gray
        infoLabel1.text = NSLocalizedString("Please login to get more features", comment: "")
        infoLabel1.numberOfLines = 0
        infoLabel1.textAlignment = .center
        infoLabel1.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        bgView.addSubview(infoLabel1)
        
        infoLabel1.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(10)
            make.centerX.equalTo(iconView)
            make.width.equalToSuperview().dividedBy(1.5)
        }
        	
        
        let closeButton = UIButton()
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 25)
        closeButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
        bgView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.trailing.top.equalTo(bgView)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(titleLabel)
        }
        
        
        let loginButton = UIButton()
        loginButton.backgroundColor = Color.red
        loginButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        loginButton.setTitle(NSLocalizedString("Login", comment: ""), for: .normal)
        loginButton.addTarget(self, action: #selector(self.loginButtonAction), for: .touchUpInside)
        bgView.addSubview(loginButton)
        
        loginButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(bgView).inset(20)
            make.height.equalTo(40)
        }
        loginButton.layer.cornerRadius = 5.0
        loginButton.clipsToBounds = true
        
        
    }
    
    @objc func dismissVC() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func loginButtonAction(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginNav")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
