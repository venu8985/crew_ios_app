//
//  CitiesMultiSelectViewController.swift
//  Crew
//
//  Created by Rajeev Pulleti on 28/06/21.
//

import UIKit

class CitiesMultiSelectViewController: UIViewController {
    
    
    var tableView : UITableView!
    var isSearch = false
    var countryId : Int!
    var citiesProtocol : MulticitiesProtocol!
    
    var cities         = [City]()
    var selectedCities = [City]()
    var filteredCities = [City]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        searchBar.delegate = self
        searchBar.placeholder = NSLocalizedString("Search", comment: "")
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
        fetchCities()
    }
    
    
    func fetchCities(){
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
            "country_id" : countryId ?? 0
        ]
        
        WebServices.postRequest(url: Url.cities, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let cityList = try decoder.decode(Cities.self, from: data)
                
                if success{
                    DispatchQueue.main.async {
                        self.cities = cityList.data ?? [City]()
                        self.tableView.reloadData()
                    }
                }
                
            } catch let error {
                print(error)
            }
        }
    }
    func navigationBarItems() {
        
        
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
    
}

extension CitiesMultiSelectViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearch{
            return filteredCities.count
        }else{
            return cities.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ScTVCell
        
        cell.separatorInset = .zero
        let city : City!
        if isSearch{
            
            city = filteredCities[indexPath.row]
            cell.titleLabel.text = city.name
            
        }else{
            city = cities[indexPath.row]
            cell.titleLabel.text = city.name
        }
        
        
        if selectedCities.contains(where: { child in child.id == city.id }) {
            let tickImage = UIImage(named: "green_tick")
            cell.tickImageView.image = tickImage
        } else {
            let tickImage = UIImage(named: "gray_tick")
            cell.tickImageView.image = tickImage
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let city : City!
        
        if isSearch{
            city = filteredCities[indexPath.row]
        }else{
            city = cities[indexPath.row]
        }
        
        if selectedCities.contains(where: { child in child.id == city.id }) {
            
            if let index = selectedCities.firstIndex(where: { child in child.id == city.id }){
                selectedCities.remove(at: index)
            }
            
        }else{
            selectedCities.append(city)
        }
        
        citiesProtocol.selectedCities(selectedCities)
        
        //        delegate.subCategories(selectedChildrenData)
        
        tableView.reloadData()
    }
    
}


extension CitiesMultiSelectViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearch = (searchText.count == 0) ? false : true
        
        if let searchText =  searchBar.text{
            if searchText.count>0{
                filteredCities = self.cities.filter { ($0.name!).range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive]) != nil }
            }else{
                filteredCities.removeAll()
            }
        }
        tableView.reloadData()
    }
    
}

protocol MulticitiesProtocol {
    func selectedCities(_ cities : [City])
}
