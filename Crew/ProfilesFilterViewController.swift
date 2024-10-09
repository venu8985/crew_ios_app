//
//  ProfilesFilterViewController.swift
//  Crew
//
//  Created by Rajeev on 24/02/21.
//

import UIKit
import TTRangeSlider
import Cosmos

class ProfilesFilterViewController: UIViewController {
    
    var categoryIconsArray = [String]()
    var categories = [CategoryData]()
    var childrenData = [Children]()
    var countryData  = [CountryData]()
    var cities  = [City]()
    
    var selectedCategoryIndex : Int!
    var categoriessCollectionView : UICollectionView!
    var scCategoriessCollectionView : UICollectionView!

    var selectedCountryIndex : Int!
    var countryId : Int!
    var category_id : Int!
    var cityCollectionView : UICollectionView!

    var subCategoriesArray = [Children]()

    var minPriceLabel : UILabel!
    var maxPriceLabel : UILabel!
    var slider : TTRangeSlider!
    var filterDelegate : FilterDelegate?
    //static ui
    var categoriesLabel    : UILabel!
    var lineView           : UIView!
    var subCategoryButton  : UIButton!
    var subCategory2Button : UIButton!
    var scLineView         : UIView!
    var priceLabel         : UILabel!
    var ratingLabel        : UILabel!
    var ratingsView        : CosmosView!
    var lineView2          : UIView!
    var countriesLabel     : UILabel!
    var lineView3          : UIView!
    var lineView1          : UIView!
    var clearButton        : UIButton!
    var cityLabel          : UILabel!
    var scrollView         : UIScrollView!
    var countryNameLabel   : UILabel!
    var removeButton       : UIButton!
    var addCitiesButton    : UIButton!
    var changeButton       : UIButton!
    var maxPrice : Float!
    var minPrice : Float!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBarItems()
        self.view.backgroundColor = .white
        
        scrollView = UIScrollView()
        scrollView.frame = self.view.bounds
        self.view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 650)
                
        
        //MARK: categories UI
        categoriesLabel = UILabel()
        categoriesLabel.text = NSLocalizedString("Category", comment: "")
        categoriesLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(categoriesLabel)

        categoriesLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalToSuperview().offset(10)
        }
    

        let layout1: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout1.itemSize = CGSize(width: 80, height: 85)
        categoriessCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout1)
        categoriessCollectionView.dataSource = self
        categoriessCollectionView.delegate = self
        categoriessCollectionView.tag = 1
        layout1.minimumLineSpacing = 0
        layout1.minimumInteritemSpacing = 0
        categoriessCollectionView.register(CategoriesCVCell.self, forCellWithReuseIdentifier: "CategoriesCVCell")
        categoriessCollectionView.showsHorizontalScrollIndicator = false
        categoriessCollectionView.backgroundColor = UIColor.clear
        layout1.scrollDirection = .horizontal
        scrollView.addSubview(categoriessCollectionView)

        categoriessCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(85)
            make.top.equalTo(categoriesLabel.snp.bottom).offset(10)
        }

        
        lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        scrollView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(categoriessCollectionView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
       
        
        let addImage = UIImage(named: "plus")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            
        subCategoryButton = UIButton()
        subCategoryButton.setTitle(NSLocalizedString(" Sub Category", comment: ""), for: .normal)
        subCategoryButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14.0)
        subCategoryButton.setTitleColor(.red, for: .normal)
        subCategoryButton.setImage(addImage, for: .normal)
        subCategoryButton.addTarget(self, action: #selector(self.subCategoryAction), for: .touchUpInside)
        scrollView.addSubview(subCategoryButton)
        
        subCategoryButton.snp.makeConstraints { (make) in
            make.leading.equalTo(categoriessCollectionView)
            make.top.equalTo(lineView.snp.bottom).offset(05)
            make.height.equalTo(40)
        }
        
        
        subCategory2Button = UIButton()
        subCategory2Button.setTitle(NSLocalizedString(" Add ", comment: ""), for: .normal)
        subCategory2Button.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        subCategory2Button.setTitleColor(.red, for: .normal)
        subCategory2Button.setImage(addImage, for: .normal)
        subCategory2Button.addTarget(self, action: #selector(self.subCategoryAction), for: .touchUpInside)
        scrollView.addSubview(subCategory2Button)
        
        subCategory2Button.snp.makeConstraints { (make) in
            make.trailing.equalTo(categoriessCollectionView)
            make.top.equalTo(lineView.snp.bottom).offset(05)
            make.height.equalTo(40)
        }
        
        subCategory2Button.isHidden = true
        

        let scLayout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        scLayout.itemSize = CGSize(width: 80, height: 60)
        scCategoriessCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: scLayout)
        scCategoriessCollectionView.dataSource = self
        scCategoriessCollectionView.delegate = self
        scCategoriessCollectionView.tag = 4
        scLayout.minimumLineSpacing = 0
        scLayout.minimumInteritemSpacing = 0
        scCategoriessCollectionView.register(ScCVCell.self, forCellWithReuseIdentifier: "scCategoriesCVCell")
        scCategoriessCollectionView.showsHorizontalScrollIndicator = false
        scCategoriessCollectionView.backgroundColor = UIColor.clear
        scLayout.scrollDirection = .horizontal
        scrollView.addSubview(scCategoriessCollectionView)

        scCategoriessCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(0)
            make.top.equalTo(subCategoryButton.snp.bottom)
        }

//        scCategoriessCollectionView.isHidden = true

        
        scLineView = UIView()
        scLineView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        scrollView.addSubview(scLineView)
        
        scLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(scCategoriessCollectionView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        
        //MARK: Price Range UI
        priceLabel = UILabel()
        priceLabel.text = NSLocalizedString("Price", comment: "")
        priceLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(priceLabel)

        priceLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(scLineView.snp.bottom).offset(10)
        }
        
        slider = TTRangeSlider()
//        slider.minValue = 0
//        slider.maxValue = 100
        slider.tintColor = .gray
        slider.handleColor = .red
        slider.handleDiameter = 18.0
        slider.selectedHandleDiameterMultiplier = 1.0
        slider.lineHeight = 5.0
        slider.tintColorBetweenHandles = .red
        slider.addTarget(self,
                         action: #selector(didChangeSliderValue(senderSlider:)),
                         for: .valueChanged)
        scrollView.addSubview(slider)
        
        slider.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(44)
            make.top.equalTo(priceLabel.snp.bottom).offset(10)
        }
        
        
        minPriceLabel = UILabel()
//        minPriceLabel.text = "SAR 500"
        minPriceLabel.font = UIFont.systemFont(ofSize: 12.0)
        scrollView.addSubview(minPriceLabel)

        minPriceLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self.view).offset(15)
            make.top.equalTo(slider.snp.bottom)
        }
        
        maxPriceLabel = UILabel()
//        maxPriceLabel.text = "SAR 50,000"
        maxPriceLabel.font = UIFont.systemFont(ofSize: 12.0)
        scrollView.addSubview(maxPriceLabel)

        maxPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self.view).inset(10)
            make.top.equalTo(slider.snp.bottom)
        }
        lineView1 = UIView()
        lineView1.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        scrollView.addSubview(lineView1)
        
        lineView1.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(maxPriceLabel.snp.bottom).offset(15)
            make.height.equalTo(1)
        }
        
        //MARK: Rating UI
        
        ratingLabel = UILabel()
        ratingLabel.text = NSLocalizedString("Rating", comment: "")
        ratingLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(ratingLabel)

        ratingLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(minPriceLabel.snp.bottom).offset(30)
        }
        
        
        ratingsView = CosmosView()
        if FilterOptions.shared.rating != nil{
            ratingsView.rating = FilterOptions.shared.rating
//
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                ratingsView.transform = CGAffineTransform(scaleX: -1, y: 1)
            }
            
        }else{
            ratingsView.rating = 0.0
        }
        ratingsView.settings.totalStars = 5
        ratingsView.settings.starSize = 40
        ratingsView.settings.filledColor = .red
        ratingsView.settings.emptyBorderColor = .red
        
        ratingsView.didFinishTouchingCosmos = { rating in
            self.updatefilters(value: rating, key: "rating")
            FilterOptions.shared.rating = rating
            
            
        }
        ratingsView.didTouchCosmos = { rating in
//            self.updatefilters(value: rating, key: "rating")
//            FilterOptions.shared.rating = rating
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                self.ratingsView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
        scrollView.addSubview(ratingsView)
        
        ratingsView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.height.equalTo(44)
            make.top.equalTo(ratingLabel.snp.bottom).offset(10)
        }
        
        
        lineView2 = UIView()
        lineView2.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        scrollView.addSubview(lineView2)
        
        lineView2.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(ratingsView.snp.bottom).offset(10)
            make.height.equalTo(1)
        }
        
        
        //MARK: Country UI

        countriesLabel = UILabel()
        countriesLabel.text = NSLocalizedString("Country", comment: "")
        countriesLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(countriesLabel)
        
        countriesLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(ratingsView.snp.bottom).offset(25)
        }
        
        
        countryNameLabel = UILabel()
        countryNameLabel.textAlignment = .center
        countryNameLabel.textColor = .darkGray
        countryNameLabel.font = UIFont.systemFont(ofSize: 10)
        scrollView.addSubview(countryNameLabel)
        
        countryNameLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(countriesLabel)
            make.top.equalTo(countriesLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(100)
        }
        countryNameLabel.numberOfLines = 0
        countryNameLabel.isHidden = true
        
        countryNameLabel.numberOfLines = 0
        countryNameLabel.layer.borderColor = UIColor.lightGray.cgColor
        countryNameLabel.layer.borderWidth = 1.0
        countryNameLabel.layer.cornerRadius = 5.0
        countryNameLabel.clipsToBounds = true
        
        let skipImage = UIImage(named: "skip")//?.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
        
        removeButton = UIButton()
        removeButton.setTitle(NSLocalizedString(" Remove", comment: ""), for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        removeButton.setTitleColor(.gray, for: .normal)
        removeButton.setImage(skipImage, for: .normal)
        removeButton.addTarget(self, action: #selector(self.removeButtonAction), for: .touchUpInside)
        scrollView.addSubview(removeButton)
        
        removeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(countryNameLabel)
            make.top.equalTo(countryNameLabel.snp.bottom).offset(05)
            make.height.equalTo(30)
        }
        removeButton.isHidden = true
        
        changeButton = UIButton()
        changeButton.setTitle(NSLocalizedString("Change?", comment: ""), for: .normal)
        changeButton.addTarget(self, action: #selector(self.changeButtonAction), for: .touchUpInside)
        changeButton.setTitleColor(Color.red, for: .normal)
        changeButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        scrollView.addSubview(changeButton)
        
        changeButton.snp.makeConstraints { make in
            make.top.equalTo(ratingsView.snp.bottom).offset(25)
            make.trailing.equalTo(self.view).offset(-10)
        }
        
        
//        let layout2: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout2.itemSize = CGSize(width: 80, height: 40)
//        countriesCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout2)
//        countriesCollectionView.dataSource = self
//        countriesCollectionView.delegate = self
//        countriesCollectionView.tag = 2
//        layout2.minimumLineSpacing = 0
//        layout2.minimumInteritemSpacing = 0
//        countriesCollectionView.register(ScCVCell.self, forCellWithReuseIdentifier: "CVCell")
//        countriesCollectionView.showsHorizontalScrollIndicator = false
//        countriesCollectionView.backgroundColor = UIColor.clear
//        layout2.scrollDirection = .horizontal
//        scrollView.addSubview(countriesCollectionView)
//
//        countriesCollectionView.snp.makeConstraints { (make) in
//            make.leading.equalTo(self.view).offset(10)
//            make.trailing.equalTo(self.view).inset(10)
//            make.height.equalTo(44)
//            make.top.equalTo(countriesLabel.snp.bottom).offset(10)
//        }
        
        lineView3 = UIView()
        lineView3.backgroundColor = UIColor.lightGray.withAlphaComponent(0.25)
        scrollView.addSubview(lineView3)
        
        lineView3.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(removeButton.snp.bottom).offset(13)
            make.height.equalTo(1)
        }
  
        //MARK: City UI
        cityLabel = UILabel()
        cityLabel.text = NSLocalizedString("City", comment: "")
        cityLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(cityLabel)
        
        cityLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(lineView3.snp.bottom).offset(25)
        }
        
        
        addCitiesButton = UIButton()
        addCitiesButton.setTitle(NSLocalizedString(" Add cities", comment: ""), for: .normal)
        addCitiesButton.setImage(addImage, for: .normal)
        addCitiesButton.addTarget(self, action: #selector(self.addCitiesAction), for: .touchUpInside)
        addCitiesButton.setTitleColor(Color.red, for: .normal)
        addCitiesButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        scrollView.addSubview(addCitiesButton)
        
        addCitiesButton.snp.makeConstraints { make in
            make.top.equalTo(lineView3.snp.bottom).offset(25)
            make.trailing.equalTo(self.view).offset(-10)
        }
        addCitiesButton.isHidden = true
        
        let layout3: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout3.itemSize = CGSize(width: 80, height: 60)
        cityCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout3)
        cityCollectionView.dataSource = self
        cityCollectionView.delegate = self
        cityCollectionView.tag = 3
        layout3.minimumLineSpacing = 0
        layout3.minimumInteritemSpacing = 0
        cityCollectionView.register(ScCVCell.self, forCellWithReuseIdentifier: "CVCell1")
        cityCollectionView.showsHorizontalScrollIndicator = false
        cityCollectionView.backgroundColor = UIColor.clear
        layout3.scrollDirection = .horizontal
        scrollView.addSubview(cityCollectionView)

        cityCollectionView.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(85)
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
        }
 
        
        
        
        let applyButton = UIButton()
        applyButton.setTitle(NSLocalizedString("Apply", comment: ""), for: .normal)
        applyButton.backgroundColor = Color.red
        applyButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        applyButton.addTarget(self, action: #selector(self.applyButtonAction), for: .touchUpInside)
        self.view.addSubview(applyButton)
        
        applyButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(15)
        }
        
        applyButton.layer.cornerRadius = 5.0
        applyButton.clipsToBounds = true
        
         
        
 
        minPriceLabel.isHidden = true
        maxPriceLabel.isHidden = true
        slider.isHidden = true
        categoriesLabel.isHidden = true
        lineView.isHidden = true
        subCategoryButton.isHidden = true
        subCategory2Button.isHidden = true
        scLineView.isHidden = true
        priceLabel.isHidden = true
        ratingLabel.isHidden = true
        ratingsView.isHidden = true
        lineView2.isHidden = true
        countriesLabel.isHidden = true
        lineView3.isHidden = true
        lineView1.isHidden = true
        cityLabel.isHidden = true
        cityCollectionView.isHidden = true
        changeButton.isHidden = true
        
        fetchFilters()
    }
 
    @objc func addCitiesAction(){
        
        let ccVC = CitiesMultiSelectViewController()
        ccVC.countryId = self.countryId
        ccVC.citiesProtocol = self
        self.navigationController?.pushViewController(ccVC, animated: true)
    }
    
    @objc func applyButtonAction(){
        
        print(FilterOptions.shared.filters)
        
       filterDelegate?.applyFilters(filters: FilterOptions.shared.filters)
       self.navigationController?.popViewController(animated: true)
    }
    
    @objc func changeButtonAction(){
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country", comment: "")//"Search country"
        ccVC.countryCodeDelegate = self
        self.navigationController?.pushViewController(ccVC, animated: true)
    }
    
    @objc func removeButtonAction(){
        FilterOptions.shared.cities = nil
        FilterOptions.shared.countryId = nil
        FilterOptions.shared.countryName = nil
        
        countryNameLabel.isHidden = true
        removeButton.isHidden = true
        cityCollectionView.isHidden = true
        cityLabel.isHidden = true
        addCitiesButton.isHidden = true
    }
    
    func fetchFilters(){
        
        let parameters: [String: Any] = [
            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id": UIDevice.current.identifierForVendor!.uuidString,
            "device_type" : "ios",
        ]
        
        WebServices.postRequest(url: Url.filters, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let filters = try decoder.decode(Filter.self, from: data)

                DispatchQueue.main.async {
                    
                    self.categories = filters.data.categories
                    self.updatefilters(value: self.category_id!, key: "category_id")
                    
                    // selected filter options
                    var catIds = Array<Int>()
                    for cat in self.categories{
                        catIds.append(cat.id ?? 0)
                    }
                    self.selectedCategoryIndex = catIds.firstIndex(of: self.category_id)
                    
                    let category = self.categories[self.selectedCategoryIndex]
                    if let childCats = category.children{
                        self.childrenData = childCats
                    }
                    
                    if FilterOptions.shared.subCategoriesArray != nil{
                        self.subCategoriesArray = FilterOptions.shared.subCategoriesArray
                        
                        self.subCategoryButton.setTitleColor(.red, for: .normal)
                        let addImage = UIImage(named: "plus")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
                        self.subCategoryButton.setImage(addImage, for: .normal)
                        
                        self.scCategoriessCollectionView.snp.remakeConstraints { (make) in
                            make.leading.equalTo(self.view).offset(10)
                            make.trailing.equalTo(self.view).inset(10)
                            make.height.equalTo(65)
                            make.top.equalTo(self.subCategoryButton.snp.bottom)
                        }
                        self.scCategoriessCollectionView.reloadData()
                        self.subCategoryButton.isHidden = true
                        self.subCategory2Button.isHidden = false
                        self.scCategoriessCollectionView.isHidden = false
                    }
                    
                    if FilterOptions.shared.countryId != nil && FilterOptions.shared.countryName != nil{
                        self.countryNameLabel.text = "  \(FilterOptions.shared.countryName ?? "")  "
                        self.countryId = FilterOptions.shared.countryId
                        self.countryNameLabel.isHidden = false
                        self.removeButton.isHidden = false
                        self.cityLabel.isHidden = false
                        self.addCitiesButton.isHidden = false
                        self.cityCollectionView.isHidden = false
                        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 850)
                    }
               
                    
                    self.categoriessCollectionView.reloadData()
                   
                    self.minPriceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(filters.data.minPrice ?? "")"
                    self.maxPriceLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(filters.data.maxPrice ?? "")"
                    
                    self.minPrice = Float(filters.data.minPrice ?? "0") ?? 0.00
                    self.maxPrice = Float(filters.data.maxPrice ?? "0") ?? 0.00
                 
                    self.slider.minValue = self.minPrice
                    self.slider.maxValue = self.maxPrice
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        self.slider.selectedMinimum = self.minPrice
                        self.slider.selectedMaximum = self.maxPrice
                    }
                    
                    if let countries = filters.data.country{
                        self.countryData = countries
//                        self.countriesCollectionView.reloadData()
                    }
                     
                    if FilterOptions.shared.cities != nil{
                        self.cities = FilterOptions.shared.cities
                        self.cityCollectionView.isHidden = false
                        self.cityCollectionView.reloadData()
                        
                        var cityId = [Int]()
                        for i in self.cities{
                            if let id = i.id{
                                cityId.append(id)
                            }
                        }
                        self.updatefilters(value: cityId, key: "city")
                    }
                    
                    self.minPriceLabel.isHidden      = false
                    self.maxPriceLabel.isHidden      = false
                    self.slider.isHidden             = false
                    self.categoriesLabel.isHidden    = false
                    self.lineView.isHidden           = false
                    self.subCategoryButton.isHidden  = false
                    self.scLineView.isHidden         = false
                    self.priceLabel.isHidden         = false
                    self.ratingLabel.isHidden        = false
                    self.ratingsView.isHidden        = false
                    self.lineView2.isHidden          = false
                    self.countriesLabel.isHidden     = false
                    self.lineView3.isHidden          = false
                    self.lineView1.isHidden          = false
                    self.changeButton.isHidden       = false

                }
                
            } catch let error {
                Banner().displayValidationError(string: NSLocalizedString("Error", comment: ""))
                print(error)
            }
        }
        
    }
    
//    func fetchCities(){
//        let parameters: [String: Any] = [
//
//            "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
//            "locale" : "en",
//            "device_id": UIDevice.current.identifierForVendor!.uuidString,
//            "device_type" : "ios",
//            "country_id" : countryId ?? 0
//        ]
//
//        WebServices.postRequest(url: Url.cities, params: parameters, viewController: self) { success,data  in
//            do {
//                let decoder = JSONDecoder()
//                let cityList = try decoder.decode(Cities.self, from: data)
//
//                if success{
//                    self.cities = cityList.data ?? [City]()
//
//                    DispatchQueue.main.async {
//                        if self.cities.count>0{
//                            self.cityLabel.isHidden              = false
//                            self.cityCollectionView.isHidden     = false
//                            self.cityCollectionView.reloadData()
//                            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 850)
//
//                            let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
//                            self.scrollView.setContentOffset(bottomOffset, animated: true)
//                        }
//                    }
//                }
//
//            } catch let error {
//                print(error)
//            }
//        }
//    }
    
    @objc func subCategoryAction(){
        
        if childrenData.count == 0 {
            Banner().displayValidationError(string: NSLocalizedString("Please select any category", comment: ""))
            return
        }
        
        let vc = SubCategoryViewController()
        vc.delegate = self
        vc.childrenData = childrenData
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    @objc func didChangeSliderValue(senderSlider:TTRangeSlider) {
        print("Min : \(senderSlider.selectedMinimum) max : \(senderSlider.selectedMaximum)")
        
        updatefilters(value: senderSlider.selectedMinimum, key: "minPrice")
        updatefilters(value: senderSlider.selectedMaximum, key: "maxPrice")

    }
    
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Filter", comment: "")
        
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
        
        
        //Create new button
        let containView1 = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        clearButton = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 40))
        clearButton.setTitle(NSLocalizedString("Clear", comment: ""), for: .normal)
        clearButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        clearButton.setTitleColor(Color.red, for: .normal)
        clearButton.contentMode = UIView.ContentMode.scaleAspectFit
        clearButton.clipsToBounds = true
        clearButton.contentHorizontalAlignment = .trailing
        containView1.addSubview(clearButton)
        clearButton.addTarget(self, action:#selector(self.clearFilters), for: .touchUpInside)
        let rightBarButton = UIBarButtonItem(customView: containView1)
        self.navigationItem.rightBarButtonItem = rightBarButton
        clearButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 20);
        clearButton.isHidden = true
    }
    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func clearFilters(){
        
        FilterOptions.shared.rating = nil
        FilterOptions.shared.countryId = nil
        FilterOptions.shared.countryName = nil
        
        countryNameLabel.isHidden = true
        removeButton.isHidden = true
        cityCollectionView.isHidden = true
        cityLabel.isHidden = true
        addCitiesButton.isHidden = true
        
        ratingsView.rating = 0.0
        selectedCountryIndex = nil
        selectedCategoryIndex = nil
        FilterOptions.shared.cities = nil
        subCategoriesArray = [Children]()
        FilterOptions.shared.subCategoriesArray = subCategoriesArray
        
        childrenData = [Children]()
        categoriessCollectionView.reloadData()
        scCategoriessCollectionView.reloadData()
        
        if (minPrice != nil){
            self.slider.selectedMinimum = minPrice
        }else{
            self.slider.selectedMinimum = self.slider.minValue
        }
        if (maxPrice != nil){
            self.slider.selectedMaximum = maxPrice
        }else{
            self.slider.selectedMaximum = self.slider.minValue
        }
        
        subCategory2Button.isHidden = true
        subCategoryButton.isHidden = false
        
        subCategoryButton.setTitleColor(.red, for: .normal)
        let addImage = UIImage(named: "plus")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        subCategoryButton.setImage(addImage, for: .normal)
        
        FilterOptions.shared.filters.removeAllObjects()
        
        scCategoriessCollectionView.snp.remakeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.trailing.equalTo(self.view).inset(10)
            make.height.equalTo(0)
            make.top.equalTo(subCategoryButton.snp.bottom)
        }
        
    }
}


extension ProfilesFilterViewController : UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 08
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView.tag == 3{
            return cities.count
        }
        
        if collectionView.tag == 4{
            return subCategoriesArray.count
        }
        
        if collectionView.tag == 2{
            return countryData.count
        }
        
        
        if collectionView.tag == 1{
            return categories.count
        }
        return 04
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView.tag == 1{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoriesCVCell", for: indexPath) as! CategoriesCVCell
            
            let category = categories[indexPath.row]
            let categoryUrl = Url.categories + (category.image ?? "")
            cell.imageview.sd_setImage(with: URL(string: categoryUrl), placeholderImage: placeHolderImage, options: [], progress: nil, completed: nil)
//            cell.imageview.image = UIImage(named: categoryIconsArray[indexPath.row])
            cell.titleLabel.text = category.name
            
            
            
            if let selectedIndex = selectedCategoryIndex{
                
                if selectedIndex == indexPath.row{
                    cell.bgView.layer.borderColor = UIColor.red.cgColor
                    cell.bgView.layer.borderWidth = 1.0
                }else{
                    cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
                    cell.bgView.layer.borderWidth = 0.5
                }
            }else{
                cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
                cell.bgView.layer.borderWidth = 0.5
            }
            
            return cell
            
        }
        else if collectionView.tag == 2{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell", for: indexPath) as! ScCVCell
            
            cell.nameLabel.text = countryData[indexPath.row].name
            
            if let selectedIndex = selectedCountryIndex{
                
                if selectedIndex == indexPath.row{
                    cell.bgView.layer.borderColor = UIColor.red.cgColor
                    cell.bgView.layer.borderWidth = 1.0
                    cell.nameLabel.textColor = UIColor.red
                }else{
                    cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
                    cell.bgView.layer.borderWidth = 0.5
                    cell.nameLabel.textColor = UIColor.darkGray
                }
            }else{
                cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
                cell.bgView.layer.borderWidth = 0.5
                cell.nameLabel.textColor = UIColor.darkGray
            }
            
            return cell
            
        }
        else if collectionView.tag == 3{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CVCell1", for: indexPath) as! ScCVCell
            
            cell.nameLabel.text = cities[indexPath.row].name
            
            cell.bgView.layer.borderColor = UIColor.gray.cgColor
            cell.bgView.layer.borderWidth = 0.5
            cell.nameLabel.textColor = UIColor.darkGray
            
            cell.removeButton.tag = indexPath.item
            cell.removeButton.addTarget(self, action: #selector(self.removeCityAction), for: .touchUpInside)

//            if let selectedIndex = selectedCityIndex{
//
//                if selectedIndex == indexPath.row{
//                    cell.bgView.layer.borderColor = UIColor.red.cgColor
//                    cell.bgView.layer.borderWidth = 1.0
//                    cell.nameLabel.textColor = UIColor.red
//                }else{
//                    cell.bgView.layer.borderColor = UIColor.lightGray.cgColor
//                    cell.bgView.layer.borderWidth = 0.5
//                    cell.nameLabel.textColor = UIColor.darkGray
//                }
//
//            }
            return cell
        }
        else if collectionView.tag == 4{
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "scCategoriesCVCell", for: indexPath) as! ScCVCell
            
            cell.nameLabel.text = subCategoriesArray[indexPath.row].name
            cell.bgView.layer.borderColor = UIColor.gray.cgColor
            cell.bgView.layer.borderWidth = 0.5
            cell.nameLabel.textColor = UIColor.darkGray
            
            cell.removeButton.tag = indexPath.item
            cell.removeButton.addTarget(self, action: #selector(self.removeSCAction), for: .touchUpInside)
            
            return cell
            
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView.tag == 1{
            selectedCategoryIndex = indexPath.row
            FilterOptions.shared.selectedCategoryId = selectedCategoryIndex
            
            let category = categories[indexPath.row]
            if let childCats = category.children{
                childrenData = childCats
            }
            categoriessCollectionView.reloadData()
            updatefilters(value: category.id!, key: "category_id")
            updatefilters(value: category.name!, key: "category_Name")

            //Removing previously added sub categories
            subCategoriesArray.removeAll()
            FilterOptions.shared.subCategoriesArray = subCategoriesArray

            subCategory2Button.isHidden = true
            
            subCategoryButton.setTitleColor(.red, for: .normal)
            let addImage = UIImage(named: "plus")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            subCategoryButton.setImage(addImage, for: .normal)
            
            scCategoriessCollectionView.snp.remakeConstraints { (make) in
                make.leading.equalTo(self.view).offset(10)
                make.trailing.equalTo(self.view).inset(10)
                make.height.equalTo(0)
                make.top.equalTo(subCategoryButton.snp.bottom)
            }
            
        }else if collectionView.tag == 2{
            selectedCountryIndex = indexPath.row
//            countriesCollectionView.reloadData()
            let country = countryData[indexPath.row]
           // cities = country.cities
            if cities.count>0{
                self.cityLabel.isHidden          = false
                self.cityCollectionView.isHidden = false
                self.cityCollectionView.reloadData()
                self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 850)

            }else{
                self.cityLabel.isHidden          = true
                self.cityCollectionView.isHidden = true
                self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 650)

            }


            if let countryId = country.id{
                self.countryId = countryId
                updatefilters(value: countryId, key: "country_id")
            }
        }
        else if collectionView.tag == 3{
//            selectedCityIndex = indexPath.row
//            cityCollectionView.reloadData()
//
//            if let cityId = cities[indexPath.row].id{
//                updatefilters(value: cityId, key: "city_id")
//            }
        }
        
    }
        
    
    @objc func removeCityAction(_ sender: UIButton){
        
        cities.remove(at: sender.tag)
        cityCollectionView.reloadData()
        
        if cities.count == 0{
            cityCollectionView.isHidden = true
        }
    }
    
    @objc func removeSCAction(_ sender: UIButton){
        
        subCategoriesArray.remove(at: sender.tag)
        FilterOptions.shared.subCategoriesArray = subCategoriesArray

        scCategoriessCollectionView.reloadData()
        
        if subCategoriesArray.count == 0{
            subCategory2Button.isHidden = true
            subCategoryButton.setTitleColor(.red, for: .normal)
            let addImage = UIImage(named: "plus")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            subCategoryButton.setImage(addImage, for: .normal)
            
            scCategoriessCollectionView.snp.remakeConstraints { (make) in
                make.leading.equalTo(self.view).offset(10)
                make.trailing.equalTo(self.view).inset(10)
                make.height.equalTo(0)
                make.top.equalTo(subCategoryButton.snp.bottom)
            }
        }
        
    }
    
    func updatefilters(value : Any, key :String){
        
        if let val = value as? Array<Int> {
            FilterOptions.shared.filters.setValue(val, forKey: key)
        }else if let val = value as? Float{
            FilterOptions.shared.filters.setValue(val, forKey: key)
        }else if let val = value as? Int{
            FilterOptions.shared.filters.setValue(val , forKey: key)
        }
        else if let val = value as? Double{
            FilterOptions.shared.filters.setValue(val , forKey: key)
        }
        else if let val = value as? String{
            FilterOptions.shared.filters.setValue(val , forKey: key)
        }
        
        
        clearButton.isHidden = false
                
    }
    
}

class CountryCityCVCell : UICollectionViewCell{
    
    var bgView : UIView!
    var nameLabel : UILabel!
 
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUI()
    }
    
    
    private func loadUI(){
        
        bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView)
        }
        
        bgView.layer.cornerRadius = 5.0
        bgView.clipsToBounds = true
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.borderWidth = 0.5
        
        bgView.layer.shadowColor = UIColor.darkGray.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 6
        
        
        
        nameLabel = UILabel()
        nameLabel.center = bgView.center
        nameLabel.textAlignment = .center
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        bgView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(self.contentView)
        }
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ScCVCell : UICollectionViewCell{
    
    var bgView : UIView!
    var nameLabel : UILabel!
    var removeButton : UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadUI()
    }
    
    
    private func loadUI(){
        
        bgView = UIView()
        bgView.backgroundColor = .white
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView).inset(25)
        }
        
        bgView.layer.cornerRadius = 5.0
        bgView.clipsToBounds = true
        bgView.layer.borderColor = UIColor.gray.cgColor
        bgView.layer.borderWidth = 2.0
        
        bgView.layer.shadowColor = UIColor.darkGray.cgColor
        bgView.layer.shadowOpacity = 0.3
        bgView.layer.shadowOffset = CGSize.zero
        bgView.layer.shadowRadius = 6
        
        
        
        nameLabel = UILabel()
        nameLabel.center = bgView.center
        nameLabel.textAlignment = .center
        nameLabel.textColor = .darkGray
        nameLabel.font = UIFont.systemFont(ofSize: 10)
        bgView.addSubview(nameLabel)
        
        nameLabel.snp.makeConstraints { (make) in
            make.leading.trailing.top.bottom.equalTo(bgView)
        }
        nameLabel.numberOfLines = 0
        
        let addImage = UIImage(named: "skip")//?.sd_resizedImage(with: CGSize(width: 10, height: 10), scaleMode: .aspectFit)
            
        removeButton = UIButton()
        removeButton.setTitle(NSLocalizedString(" Remove", comment: ""), for: .normal)
        removeButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        removeButton.setTitleColor(.gray, for: .normal)
        removeButton.setImage(addImage, for: .normal)
        self.contentView.addSubview(removeButton)
        
        removeButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(bgView)
            make.top.equalTo(bgView.snp.bottom).offset(05)
            make.height.equalTo(30)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


protocol SubcategoriesDelegate {
    func subCategories(_ array: Array<Children>)
}

extension ProfilesFilterViewController : SubcategoriesDelegate{
    func subCategories(_ array: Array<Children>) {
        
        subCategoriesArray = array
        FilterOptions.shared.subCategoriesArray = subCategoriesArray
        
        if array.count>0{
            subCategory2Button.isHidden = false
            subCategoryButton.setTitleColor(.black, for: .normal)
            subCategoryButton.setImage(UIImage(named: ""), for: .normal)
            
            scCategoriessCollectionView.snp.remakeConstraints { (make) in
                make.leading.equalTo(self.view).offset(10)
                make.trailing.equalTo(self.view).inset(10)
                make.height.equalTo(65)
                make.top.equalTo(subCategoryButton.snp.bottom)
            }
            scCategoriessCollectionView.reloadData()
            
            var ids = Array<Int>()
            
            for child in array{
                if let childId = child.id{
                    ids.append(childId)
                }
            }
                        
            updatefilters(value: ids, key: "child_category")

            
        }else{
            subCategory2Button.isHidden = true

            subCategoryButton.setTitleColor(.red, for: .normal)
            let addImage = UIImage(named: "plus")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            subCategoryButton.setImage(addImage, for: .normal)
            
            scCategoriessCollectionView.snp.remakeConstraints { (make) in
                make.leading.equalTo(self.view).offset(10)
                make.trailing.equalTo(self.view).inset(10)
                make.height.equalTo(0)
                make.top.equalTo(subCategoryButton.snp.bottom)
            }
            
            if (FilterOptions.shared.filters.allKeys as NSArray).contains("child_category"){
//                filters.removeObject(forKey: "child_category")
                updatefilters(value: Array<Int>(), key: "child_category")
            }
            
        }
    }
}

//country picker delegate
extension ProfilesFilterViewController : countryCodeProtocol{

    @objc func selectedCountry(countryName : String, countryId : Int){
        FilterOptions.shared.cities = nil
        self.cities = [City]()
        cityCollectionView.reloadData()
        countryNameLabel.text = "  \(countryName)  "
        FilterOptions.shared.countryId = countryId
        FilterOptions.shared.countryName = countryName
        updatefilters(value: countryId, key: "country_id")

        self.countryId = countryId
        countryNameLabel.isHidden = false
        removeButton.isHidden = false
        cityLabel.isHidden = false
        addCitiesButton.isHidden = false
        cityCollectionView.isHidden = false
        self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 850)
        let bottomOffset = CGPoint(x: 0, y: self.scrollView.contentSize.height - self.scrollView.bounds.height + self.scrollView.contentInset.bottom)
        self.scrollView.setContentOffset(bottomOffset, animated: true)

    }
    

}

extension ProfilesFilterViewController : MulticitiesProtocol{
    func selectedCities(_ cities: [City]) {
        print("cities \(cities)")
        FilterOptions.shared.cities = cities
        self.cities = cities
        self.cityCollectionView.isHidden = false
        self.cityCollectionView.reloadData()
        
        var cityId = [Int]()
        for i in cities{
            if let id = i.id{
                cityId.append(id)
            }
        }
        
        updatefilters(value: cityId, key: "city")

    }
    
}
