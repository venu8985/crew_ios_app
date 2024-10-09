//
//  ShootingResourcesViewController.swift
//  Crew
//
//  Created by Rajeev on 07/04/21.
//

import UIKit

class ShootingResourcesViewController: UIViewController {

    var selectedRows = [Int]()
    var providers : [ResourcesData]!
    var selectedResources = [ResourcesData]()

    var delegate : ResourceDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationBarItems()
        
        self.view.backgroundColor = .white
        let confirmButton = UIButton()
        confirmButton.setTitle(NSLocalizedString("Confirm", comment: ""), for: .normal)
        confirmButton.backgroundColor = Color.red
        confirmButton.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        confirmButton.addTarget(self, action: #selector(self.confirmButtonAction), for: .touchUpInside)
        self.view.addSubview(confirmButton)
        
        confirmButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        confirmButton.layer.cornerRadius = 5.0
        confirmButton.clipsToBounds = true
        
        
        let separtorLineView = UIView()
        separtorLineView.backgroundColor = Color.gray
        self.view.addSubview(separtorLineView)
        
        separtorLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalTo(confirmButton.snp.top).offset(-10)
        }
        
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(ResourceTVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.bottom.equalTo(separtorLineView).offset(-10)
        }
        
    }
    

    func navigationBarItems() {
        
        self.title = NSLocalizedString("Select resources", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.setImage(UIImage(named: "back-R"), for: .normal)
        }else{
            backButton.setImage(UIImage(named: "back"), for: .normal)
        }
        backButton.contentMode = UIView.ContentMode.scaleAspectFit
        backButton.clipsToBounds = true
        containView.addSubview(backButton)
        backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        
        let leftBarButton = UIBarButtonItem(customView: containView)
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 0);
        }else{
            backButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        }

    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }

    @objc func confirmButtonAction(){
        delegate.selected(resources: selectedResources)
        self.navigationController?.popViewController(animated: true)
    }

}

extension ShootingResourcesViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if providers != nil{
            return providers.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ResourceTVCell
        cell.selectionStyle = .none
        if selectedRows.contains(indexPath.row){
            cell.selectImageView.image = UIImage(named: "selected_tick")
        }else{
            cell.selectImageView.image = UIImage(named: "grey_tick(1)")
        }
        
        let provider = providers[indexPath.row]
        let imageUrl = Url.providers + (provider.profile_image ?? "")
        cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        cell.nameLabel.text = provider.name
        cell.titleLabel.text = provider.child_category
        

        if providers[indexPath.row].status == "Contract Accepted"{
            cell.selectImageView.isHidden = false
            cell.pendingLabel.isHidden = true
        }else {
            cell.selectImageView.isHidden = true
            cell.pendingLabel.isHidden = false
//            cell.pendingLabel.isHidden = true
            cell.pendingLabel.text = NSLocalizedString(providers[indexPath.row].status ?? "", comment: "")
            
            if providers[indexPath.row].status == "Job Done"{
                cell.pendingLabel.textColor = Color.green
            }else{
                cell.pendingLabel.textColor = Color.red
            }
            
            
        }
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            cell.nameLabel.textAlignment = .right
            cell.titleLabel.textAlignment = .right
        }else{
            cell.nameLabel.textAlignment = .left
            cell.titleLabel.textAlignment = .left
        }
        
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if providers[indexPath.row].status != "Contract Accepted"{
            return
        }
        
        if selectedRows.contains(indexPath.row){
            
            if let index = selectedRows.firstIndex(of: indexPath.row){
                selectedRows.remove(at: index)
            }
            
            let provider = providers[indexPath.row]
            if let providerIndex = selectedResources.firstIndex(where: { $0.id == provider.id }){
                selectedResources.remove(at: providerIndex)
            }
                        
        }else{
            selectedRows.append(indexPath.row)
            selectedResources.append(providers[indexPath.row])
        }
        tableView.reloadData()
    }
    
}


    class ResourceTVCell : UITableViewCell{
        
        var profileImage : UIImageView!
        var titleLabel : UILabel!
        var nameLabel : UILabel!
        var selectImageView : UIImageView!
        var pendingLabel : UILabel!

        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
          
            profileImage = UIImageView()
//            profileImage.image = UIImage(named: "tom-hardy")
            profileImage.contentMode = .scaleAspectFill
            self.contentView.addSubview(profileImage)
            
            profileImage.snp.makeConstraints { (make) in
                make.width.height.equalTo(60)
                make.leading.equalToSuperview().offset(30)
                make.centerY.equalToSuperview()
            }
            profileImage.layer.cornerRadius = 30
            profileImage.clipsToBounds = true
            
            titleLabel = UILabel()
            titleLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14)
            self.contentView.addSubview(titleLabel)
            
            titleLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(profileImage.snp.trailing).offset(10)
                make.top.equalTo(profileImage).offset(10)
                make.trailing.equalToSuperview().offset(-50)
                
            }
            
            nameLabel = UILabel()
            nameLabel.font = UIFont(name: "AvenirLTStd-Light", size: 14)
            nameLabel.textColor = Color.gray
            self.contentView.addSubview(nameLabel)
            
            nameLabel.snp.makeConstraints { (make) in
                make.leading.equalTo(profileImage.snp.trailing).offset(10)
                make.top.equalTo(titleLabel.snp.bottom).offset(05)
                make.trailing.equalToSuperview().offset(-50)
            }
            
            selectImageView = UIImageView()
            selectImageView.image = UIImage(named: "grey_tick(1)")
            selectImageView.contentMode = .scaleAspectFit
            self.contentView.addSubview(selectImageView)
            
            selectImageView.snp.makeConstraints { (make) in
                make.width.height.equalTo(25)
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-10)
            }
 
            pendingLabel = UILabel()
//            pendingLabel.text = NSLocalizedString("Pending", comment: "")
            pendingLabel.font = UIFont(name: "Avenir Medium", size: 14)
            pendingLabel.textColor = Color.red
            self.contentView.addSubview(pendingLabel)
            
            pendingLabel.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.trailing.equalToSuperview().offset(-10)
            }
            
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
