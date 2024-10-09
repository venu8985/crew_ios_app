//
//  SubCategoryViewController.swift
//  Crew
//
//  Created by Rajeev on 02/03/21.
//



import UIKit



//extension UIApplication {
//    var statusBarView1: UIView? {
////        if responds(to: Selector(("statusBarWindow.statusBar"))) {
////            return value(forKey: "statusBarWindow.statusBar") as? UIView
////        }
//        return value(forKey: "statusBarWindow.statusBar") as? UIView
//    }
//}

extension UIApplication {
    var statusBarUIView: UIView? {
        if #available(iOS 13.0, *) {
            let tag = 38482458385
            if let statusBar = self.keyWindow?.viewWithTag(tag) {
                return statusBar
            } else {
                let statusBarView = UIView(frame: UIApplication.shared.statusBarFrame)
                statusBarView.tag = tag

                self.keyWindow?.addSubview(statusBarView)
                return statusBarView
            }
        } else {
            if responds(to: Selector(("statusBar"))) {
                return value(forKey: "statusBar") as? UIView
            }
        }
        return nil
    }
}


class SubCategoryViewController: UIViewController {
    
    var childrenData = [Children]()
    var selectedChildrenData = [Children]()
    var filterChildrenData = [Children]()

//    var selectedCategoriesArray = [String]()
//    var categoriesArray = [String]()
    
    var tableView : UITableView!
    var delegate : SubcategoriesDelegate!
    var isSearch = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
//        for i in 0..<100{
//            categoriesArray.append("Category#\(i)")
//        }
//
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("Search Sub-Category", comment: "")
        searchBar.searchBarStyle = .minimal
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view)
        }
        
        tableView = UITableView()
        tableView.frame = self.view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.register(ScTVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(self.view)
        }
        
        self.navigationBarItems()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.isTranslucent = false
//        self.navigationController?.navigationBar.isHidden = false
        UIApplication.shared.statusBarUIView?.backgroundColor = .white
    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Sub-Category", comment: "")
        
        let containView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        let backButton = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))

        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.setImage(UIImage(named: "back-R"), for: .normal)
        }else{
            backButton.setImage(UIImage(named: "back"), for: .normal)
        }
        
//        self.navigationController?.navigationBar.barTintColor = .white
//        self.navigationController?.navigationBar.isTranslucent = false
        
        
        
        
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
    
}

extension SubCategoryViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return filterChildrenData.count
        }else{
            return childrenData.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScTVCell
        
        cell.separatorInset = .zero
        let children : Children!
        if isSearch{
            cell.titleLabel.text = filterChildrenData[indexPath.row].name
            children = childrenData[indexPath.row]
        }else{
            cell.titleLabel.text = childrenData[indexPath.row].name
            children = childrenData[indexPath.row]
        }

        
        if selectedChildrenData.contains(where: { child in child.id == children.id }) {
            let tickImage = UIImage(named: "green_tick")
            cell.tickImageView.image = tickImage
        } else {
            let tickImage = UIImage(named: "gray_tick")
            cell.tickImageView.image = tickImage
        }
        

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let children : Children!
        if filterChildrenData.count == 0{
            children = childrenData[indexPath.row]
        }else{
            children = filterChildrenData[indexPath.row]
        }
        
        
        if selectedChildrenData.contains(where: { child in child.id == children.id }) {
            
            if let index = selectedChildrenData.firstIndex(where: { child in child.id == children.id }){
                selectedChildrenData.remove(at: index)
            }
            
        } else {
            selectedChildrenData.append(children)
        }
                
        delegate.subCategories(selectedChildrenData)
        
        tableView.reloadData()
    }
    
}


class ScTVCell : UITableViewCell {
    
    let tickImageView = UIImageView()
    let titleLabel = UILabel()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        self.backgroundColor=UIColor.clear
        
        
        titleLabel.font = UIFont.systemFont(ofSize: 12.0)
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).offset(10)
            make.centerY.equalTo(self.contentView)
        }
        
        
        let tickImage = UIImage(named: "gray_tick")
        
        tickImageView.contentMode = .scaleAspectFit
        tickImageView.image = tickImage
        self.contentView.addSubview(tickImageView)
        
        tickImageView.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.contentView).inset(10)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(20)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.equalTo(titleLabel)
            make.trailing.equalTo(tickImageView)
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.height.equalTo(0.5)
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension SubCategoryViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = (searchText.count == 0) ? false : true

        if let searchText =  searchBar.text{
            if searchText.count>0{
                filterChildrenData = self.childrenData.filter { ($0.name!).range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
            }else{
                filterChildrenData.removeAll()
            }
        }
        tableView.reloadData()
    }
        
}
