//
//  ProvidersViewController.swift
//  Crew
//
//  Created by Rajeev on 08/04/21.
//

import UIKit

class ProvidersViewController: UIViewController {

    var titleString : String!
    var tableView : UITableView!
    var resources : [ShootingResource]!
    var providers = [ResourcesData]()
    var agencies = [AgencyDetails]()
    var profileDelegate      : ProfileDelegate!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)

        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        self.view.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.height.equalTo(370)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = titleString
        titleLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 20)
        bgView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(5)
            make.leading.equalTo(bgView)
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
        
        

        
        tableView = UITableView()
//        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        self.view.addSubview(tableView)
        tableView.register(ResourceTVCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(05)
        }
        
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = Color.liteGray.cgColor
        tableView.layer.cornerRadius = 5.0
        
        
    }
    
    @objc func dismissVC(){
        self.dismiss(animated: true, completion: nil)
    }

}

extension ProvidersViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if providers.count>0{
            return providers.count
        }
        else if agencies.count>0{
            return agencies.count
        }
        return resources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResourceTVCell
        cell.selectionStyle = .none
        cell.selectImageView.isHidden = true
        cell.pendingLabel.isHidden = true

        
        if providers.count>0{
            let provider = providers[indexPath.row]
            let imageUrl = Url.providers + (provider.profile_image ?? "")
            cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = provider.name
            cell.titleLabel.text = provider.child_category
        }
        
        else if agencies.count>0{
            let agency = agencies[indexPath.row]
            let imageUrl = Url.userProfile + (agency.profile_image ?? "")
            cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = agency.status
            cell.titleLabel.text = agency.name
            cell.pendingLabel.isHidden = true
        }
        else{
            let provider = resources[indexPath.row]
            let imageUrl = Url.providers + (provider.profile_image ?? "")
            cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
            cell.nameLabel.text = provider.name
            cell.titleLabel.text = provider.child_category
        }

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        
        if Profile.shared.details?.is_agency=="Yes"{
            let provider = providers[indexPath.row]
            if let id = provider.id{
                profileDelegate.openProfileDetails(providerId: id)
            }
            
        }
    }
    
}
