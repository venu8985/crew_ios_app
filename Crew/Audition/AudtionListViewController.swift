//
//  AudtionListViewController.swift
//  Crew
//
//  Created by Rajeev on 20/04/21.
//

import UIKit

class AudtionListViewController: UIViewController, UITableViewDataSource,UITableViewDelegate {

    var auditions = [Audtions]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        navigationBarItems()
        
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(AudtionResourceTVCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalToSuperview()
        }
        
    }
        
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    

    func navigationBarItems() {
        
        self.title = NSLocalizedString("Audition Requests", comment: "")
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
    
    //MARK : Tableview datasource,delegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return auditions.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! AudtionResourceTVCell
        
        let audition = auditions[indexPath.row]
        cell.nameLabel.text = audition.name
        cell.titleLabel.text = audition.child_category
        let imageUrl = Url.providers + (audition.profile_image ?? "")
        cell.profileImage.sd_setImage(with: URL(string: imageUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)

        if audition.status == "Accepted"{
            cell.statusLabel.text = NSLocalizedString("Accepted", comment: "")
            cell.statusLabel.textColor = Color.green
        }
        else {
            cell.statusLabel.text = NSLocalizedString(audition.status ?? "", comment: "")
            cell.statusLabel.textColor = Color.red
        }
        
        return cell
    }

}


class AudtionResourceTVCell : UITableViewCell {
    
    var profileImage : UIImageView!
    var titleLabel : UILabel!
    var nameLabel : UILabel!
    var statusLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        profileImage = UIImageView()
//        profileImage.image = UIImage(named: "tom-hardy")
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
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            nameLabel.textAlignment = .right
            titleLabel.textAlignment = .right
        }else{
            nameLabel.textAlignment = .left
            titleLabel.textAlignment = .left
        }


        statusLabel = UILabel()
        statusLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        statusLabel.textColor = UIColor.darkGray
        self.contentView.addSubview(statusLabel)
        
        statusLabel.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-05)
            make.width.equalTo(70)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
