//
//  CountryCodesViewController.swift
//  Crew
//
//  Created by Rajeev on 15/03/21.
//

import UIKit
import SDWebImage

class CountriesViewController: UIViewController {
    
    var countryInfoArray = [CountryInfo]()
    var nationalityArray = [Nationality]()
    var nationalityFilterArray = [Nationality]()

    var countryInfoFilterArray = [CountryInfo]()
    var citiesArray = [City]()
    var citiesFilterArray = [City]()

    
    var tableView : UITableView!
    var countryCodeDelegate : countryCodeProtocol!
    //    var citiesArray = NSArray()
    var titleString : String!
    var countryId : Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.title = titleString
        
        self.view.backgroundColor = UIColor.white
        let searchBar = UISearchBar()
        searchBar.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        searchBar.delegate = self
        searchBar.returnKeyType = .done
        searchBar.placeholder = titleString //NSLocalizedString("Search Country code", comment: "")
   
        searchBar.searchBarStyle = .minimal
        if #available(iOS 13.0, *) {
            searchBar.searchTextField.font = UIFont(name: "AvenirLTStd-Book", size: 15.0)
        } else {
            // Fallback on earlier versions
        }
        self.view.addSubview(searchBar)
        
        searchBar.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(self.view.snp.topMargin)
        }
        
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorInset = .zero
        tableView.layoutMargins = .zero
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(CountryTVCell.self, forCellReuseIdentifier: "cell")
        
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.top.equalTo(searchBar.snp.bottom)
        }
        
        if titleString == NSLocalizedString("Search country", comment: "") || titleString == NSLocalizedString("Search country code", comment: ""){
            fetchCountries()
        }
        else if titleString == NSLocalizedString("Nationality", comment: "") {
            fetchNationalities()
        }
        else{
            fetchCities()
        }
        navigationBarItems()
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
    
    func fetchNationalities(){
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios"
        ]
        
        WebServices.postRequest(url: Url.nationalities, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let nationalityList = try decoder.decode(Nationalities.self, from: data)
                
                if success{
                    self.nationalityArray = nationalityList.data ?? [Nationality]()
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
    }
    
    func fetchCountries(){
        let parameters: [String: Any] = [
            
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios"
        ]
        
        WebServices.postRequest(url: Url.contryCodes, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let countryList = try decoder.decode(CountryCodes.self, from: data)
                
                if success{
                    self.countryInfoArray = countryList.data ?? [CountryInfo]()
                    self.tableView.reloadData()
                }
            } catch let error {
                print(error)
            }
        }
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
                    self.citiesArray = cityList.data ?? [City]()
                    self.tableView.reloadData()
                }
                
            } catch let error {
                print(error)
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
}

extension CountriesViewController : UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        if citiesFilterArray.count>0{
            return citiesFilterArray.count
        }
        else if citiesArray.count>0{
            return citiesArray.count
        }
        
        
        if countryInfoFilterArray.count>0{
            return countryInfoFilterArray.count
        }
        else if countryInfoArray.count>0{
            return countryInfoArray.count
        }
        
        if nationalityFilterArray.count>0{
            return nationalityFilterArray.count
        }
        else if nationalityArray.count>0{
            return nationalityArray.count
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CountryTVCell
        //        cell.textLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        
        //        let profilePicurl = Url. + (Profile.shared.details?.profile_image ?? "")
        //        cell?.imageView?.image.sd_setImage(with: URL(string: profilePicurl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
        //        cell?.imageView?.image.contentMode = .scaleAspectFill
        
        
        if citiesFilterArray.count>0{
            cell.countryLabel.text = citiesFilterArray[indexPath.row].name
        }
        else if citiesArray.count>0{
            cell.countryLabel?.text = citiesArray[indexPath.row].name
        }
        if nationalityFilterArray.count>0{
            cell.countryLabel.text = nationalityFilterArray[indexPath.row].nationality_name
        }
        else if nationalityArray.count>0{
            
            cell.countryLabel.text = nationalityArray[indexPath.row].nationality_name
        }
        else {
            let countryInfo : CountryInfo!
            
            if countryInfoFilterArray.count>0{
                countryInfo = countryInfoFilterArray[indexPath.row]
                
                let dial_code = countryInfo.dial_code ?? ""
                let name = countryInfo.name ?? ""
                if titleString == NSLocalizedString("Search country code", comment: ""){
                    cell.countryLabel?.text = "+\(dial_code)  \(name)"
                }else {
                    cell.countryLabel?.text = name
                }
                let flag = countryInfo.flag ?? ""
                let flagURL = Url.countryFlag + flag
                let placholderImage = UIImage(named: "flag")?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                cell.countryImageView?.sd_setImage(with: URL(string: flagURL), placeholderImage: placholderImage, options: [], progress: nil, completed: nil)
                
            }else if countryInfoArray.count>0{
                countryInfo = countryInfoArray[indexPath.row]
                
                let dial_code = countryInfo.dial_code ?? ""
                let name = countryInfo.name ?? ""
                if titleString == NSLocalizedString("Search country code", comment: ""){
                    cell.countryLabel?.text = "+\(dial_code)  \(name)"
                }else {
                    cell.countryLabel?.text = name
                }
                let flag = countryInfo.flag ?? ""
                let flagURL = Url.countryFlag + flag
                let placholderImage = UIImage(named: "flag")?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
                cell.countryImageView?.sd_setImage(with: URL(string: flagURL), placeholderImage: placholderImage, options: [], progress: nil, completed: nil)
            }
                        
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let countryInfo : CountryInfo!
        
        if citiesFilterArray.count>0{
            countryCodeDelegate.selectedCity?(cityName: citiesFilterArray[indexPath.row].name ?? "", cityId: citiesFilterArray[indexPath.row].id ?? 0)
        }
        else if citiesArray.count>0{
            countryCodeDelegate.selectedCity?(cityName: citiesArray[indexPath.row].name ?? "", cityId: citiesArray[indexPath.row].id ?? 0)
        }
        else if nationalityFilterArray.count>0{
            countryCodeDelegate.selectedNationality?(nationality: nationalityFilterArray[indexPath.row].nationality_name ?? "", id: nationalityFilterArray[indexPath.row].id ?? 0)
        }
        else if nationalityArray.count>0{
            countryCodeDelegate.selectedNationality?(nationality: nationalityArray[indexPath.row].nationality_name ?? "", id: nationalityArray[indexPath.row].id ?? 0)
        }
        else{
            
            if countryInfoFilterArray.count>0{
                countryInfo = countryInfoFilterArray[indexPath.row]
            }
            else{
                countryInfo = countryInfoArray[indexPath.row]
            }
            
            if titleString == NSLocalizedString("Search country", comment: "") {
                countryCodeDelegate.selectedCountry?(countryName: countryInfo.name ?? "", countryId: countryInfo.id ?? 0)
            }
            else {
                countryCodeDelegate.selectedCountryCode!(ccCode: countryInfo.dial_code ?? "")
            }
        }
        //                || titleString == NSLocalizedString("Search country code", comment: ""){
        //                countryCodeDelegate.selectedCountryCode!(ccCode: countryInfo.dial_code ?? "")
        //            }
        //            else { //if titleString == "Search country"
        //                let cityList = NSMutableArray()
        //
        //                for city in countryInfo.cities{
        //                    cityList.add(city)
        //                }
        //                countryCodeDelegate.selectedCountry?(countryName: countryInfo.name ?? "", countryId: countryInfo.id ?? 0, cities: cityList as NSArray)
        //            }
        //        }
        if self.isModal{
            self.dismiss(animated: true, completion: nil)
        }else{
            self.navigationController?.popViewController(animated: true)
        }
//        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CountriesViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if let searchText = searchBar.text{
            if countryInfoArray.count>0{
                countryInfoFilterArray = countryInfoArray.filter { ($0.name?.contains(searchText))! || ($0.dial_code?.contains(searchText))!}
            }
            else if citiesArray.count>0{
                citiesFilterArray = citiesArray.filter { ($0.name?.contains(searchText))! }
                print("\(citiesFilterArray)")
            }
            else if nationalityArray.count>0{
                nationalityFilterArray = nationalityArray.filter{ ($0.nationality_name?.contains(searchText))! }
            }
            tableView.reloadData()
        }
    }
    
}

class CountryTVCell : UITableViewCell{
    
    var countryLabel : UILabel!
    var countryImageView : UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        countryImageView = UIImageView()
        countryImageView.contentMode = .scaleAspectFit
        self.contentView.addSubview(countryImageView)
        
        countryImageView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.contentView).offset(05)
            make.centerY.equalTo(self.contentView)
            make.width.equalTo(30)
            make.height.equalTo(20)
        }
        
        countryLabel = UILabel()
        countryLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        self.contentView.addSubview(countryLabel)
        
        countryLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(countryImageView.snp.trailing).offset(10)
            make.centerY.equalTo(countryImageView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
