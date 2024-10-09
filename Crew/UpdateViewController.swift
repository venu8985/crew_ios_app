//
//  UpdateViewController.swift
//  Crew
//
//  Created by Rajeev Pulleti on 21/06/21.
//

import UIKit

class UpdateViewController: UIViewController {

    var updateString : String?
    var versionString : String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        let bgImageView = UIImageView(image: UIImage(named: "bg_update"))
        bgImageView.contentMode = .scaleAspectFill
        self.view.addSubview(bgImageView)
        bgImageView.snp.makeConstraints { make in
            make.leading.trailing.top.equalTo(self.view)
            make.height.equalTo(self.view).dividedBy(2)
        }
        
        
        let titleLabel = UILabel()
        titleLabel.font = UIFont(name: "Avenir Heavy", size: 20)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        titleLabel.text = NSLocalizedString("Launched New Features", comment: "")
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(bgImageView.snp.bottom).offset(50)
        }
        
        let infoLabel = UILabel()
        infoLabel.font = UIFont(name: "AvenirLTStd-Light", size: 13)
        infoLabel.textColor = .gray
        infoLabel.textAlignment = .center
        infoLabel.text = NSLocalizedString("Please update the surveillant", comment: "")
        self.view.addSubview(infoLabel)
        
        infoLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
        }
        
        let whatsnewString = NSLocalizedString("what's new in v", comment: "")
        let versionLabel = UILabel()
        versionLabel.font = UIFont(name: "AvenirLTStd-Light", size: 13)
        versionLabel.textColor = .gray
        versionLabel.textAlignment = .center
        versionLabel.text = "\(whatsnewString) \(versionString ?? "")"
        self.view.addSubview(versionLabel)
        
        versionLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(infoLabel.snp.bottom).offset(25)
        }
        
        
        let updatesLabel = UILabel()
        updatesLabel.font = UIFont(name: "AvenirLTStd-Light", size: 13)
        updatesLabel.textColor = .darkGray
        updatesLabel.textAlignment = .center
//        updatesLabel.text = updateString
        updatesLabel.numberOfLines = 0
        self.view.addSubview(updatesLabel)
        
        updatesLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(versionLabel.snp.bottom).offset(10)
        }
        
        let attributedString = NSMutableAttributedString(string: updateString ?? "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 6
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        updatesLabel.attributedText = attributedString
        updatesLabel.textAlignment = .center
        
        
        let updateButton = UIButton()
        updateButton.setTitle(NSLocalizedString("Update", comment: ""), for: .normal)
        updateButton.backgroundColor = Color.red
        updateButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        updateButton.addTarget(self, action: #selector(self.updateNowAction), for: .touchUpInside)
        self.view.addSubview(updateButton)
        
        updateButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.bottom.equalTo(self.view.snp.bottom).inset(20)
            make.leading.trailing.equalTo(self.view).inset(30)
        }
        
        updateButton.layer.cornerRadius = 5.0
        updateButton.clipsToBounds = true
    }
    
    @objc func updateNowAction(){
        
        if let url = URL(string: Url.appstoreUrl) {
            UIApplication.shared.open(url)
        }
                   
    }
 
}
