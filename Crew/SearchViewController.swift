//
//  SearchViewController.swift
//  Crew
//
//  Created by Rajeev on 22/02/21.
//

import UIKit

class SearchViewController: UIViewController, UISearchBarDelegate,UIScrollViewDelegate{
    
    lazy var searchBar:UISearchBar = UISearchBar()
    var tableView : UITableView!
    var filterArray = [Category]()
    var isSearch = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.frame = CGRect(x: 10, y: 44, width: self.view.frame.size.width-20, height: 44)
        searchBar.placeholder = NSLocalizedString(" What are you looking for?", comment: "")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.returnKeyType = .done
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.searchTextField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        searchBar.searchTextField.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.view.addSubview(searchBar)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            searchBar.searchTextField.textAlignment = .right
        }else{
            searchBar.searchTextField.textAlignment = .left
        }
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.estimatedRowHeight = 25
//        tableView.rowHeight = UITableView.automaticDimension
        tableView.keyboardDismissMode = .onDrag
        tableView.keyboardDismissMode = .interactive
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        
        tableView.register(CategoryCell.self, forCellReuseIdentifier: "cell")
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(searchBar.snp.bottom)
        }
        
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = false
        
    }
        
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        self.navigationController?.navigationBar.isTranslucent = false
    }
    
    
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String)
    {
        if let searchText = searchBar.text{
            isSearch = (searchText.count == 0) ? false : true
            filterArray = (Categories.shared.list?.filter { $0.name.contains(searchText)})!
            tableView.reloadData()

        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.searchTextField.endEditing(true)
    }
    
}

extension SearchViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width-20, height: 25))
        label.text = NSLocalizedString("Browse Categories", comment: "")
        label.font = UIFont(name: "Avenir Heavy", size: 14.0)
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return filterArray.count
        }else{
            return Categories.shared.list?.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CategoryCell
        cell.selectionStyle = .none
        var category : Category!
        if isSearch{
            category = filterArray[indexPath.row]
        }else{
            category = Categories.shared.list?[indexPath.row]
        }
        
        cell.titleLabel?.text = category.name
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            cell.titleLabel.textAlignment = .right
        }else{
            cell.titleLabel.textAlignment = .left
        }
        
        let categoryUrl = Url.categories + category.image
        cell.imageview?.sd_setImage(with: URL(string: categoryUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        cell.imageview?.contentMode = .scaleAspectFit
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.tabBarController?.tabBar.isHidden = true
        
        let vc = SearchFilterViewController()
        if filterArray.count>0{
            vc.category = filterArray[indexPath.row]
        }else{
            vc.category = Categories.shared.list?[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

class CategoryCell : UITableViewCell {
    
    var imageview : UIImageView!
    var titleLabel : UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        imageview = UIImageView()
        imageview.contentMode = .scaleAspectFit
        self.contentView.addSubview(imageview)
        
        imageview.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalTo(self.contentView)
            make.width.height.equalTo(25)
        }
        
        titleLabel = UILabel()
        titleLabel.textColor = Color.liteBlack
        titleLabel.font =  UIFont(name: "AvenirLTStd-Book", size: 12)
        self.contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(imageview.snp.trailing).offset(10)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
