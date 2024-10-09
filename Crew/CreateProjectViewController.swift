//
//  CreateProjectViewController.swift
//  Crew
//
//  Created by Rajeev on 11/03/21.
//

import UIKit
import DatePickerDialog
import SnapKit

class CreateProjectViewController: UIViewController {
    
    let datePicker = DatePickerDialog()
    var startButton : UIButton!
    var endButton : UIButton!
    
    var minEndDate = Date()
    var endDate : Date!
    
    var projectNameTextfield : UITextField!
    var descriptionTextview : UITextView!
    var budgetTextfield : FloatingTextfield!
    var countryTextfield : FloatingTextfield!
    var cityTextfield : FloatingTextfield!
    var scrollView : UIScrollView!
    
    
    var endDateStr : String!
    var startDateStr : String!
    
    var isCompany : Bool!
    var isAgency : Bool!
    
    var citiesArray : NSArray!
    var countryId : Int!
    var cityId : Int!
    var editProject : Bool!
    
    
    //Edit project
    var projectName : String!
    var projectDesc : String!
    var budget : String!
    var projectId : Int!
    var cityString : String!
    var countryString : String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white //UIColor(hexString: Color.litePink)
        
        //Setting default dates for api
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if !editProject{
            startDateStr = dateFormatter.string(from: Date())
            endDateStr = dateFormatter.string(from: Date())
        }
        
        
        scrollView = UIScrollView()
        self.view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view)
            make.bottom.equalTo(self.view).offset(-80)
        }
        
        if isCompany{
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 600)
        }
        else{
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 400)
        }
        
        
        
        let aboutLabel = UILabel()
        aboutLabel.text = NSLocalizedString("About Project", comment: "")
        aboutLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14.0)
        scrollView.addSubview(aboutLabel)
        
        aboutLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalTo(self.view).inset(20)
        }
        
       
        projectNameTextfield = UITextField()
        projectNameTextfield.placeholder = NSLocalizedString("Project Name", comment: "")
        projectNameTextfield.backgroundColor = .white
        projectNameTextfield.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(projectNameTextfield)
        
        projectNameTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(aboutLabel)
            make.top.equalTo(aboutLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
        }
        projectNameTextfield.layer.borderWidth = 0.5
        projectNameTextfield.layer.borderColor = UIColor.lightGray.cgColor
        projectNameTextfield.layer.cornerRadius = 10.0
        projectNameTextfield.clipsToBounds = true
        
        // Create a padding view for padding on left
        projectNameTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: projectNameTextfield.frame.height))
        projectNameTextfield.leftViewMode = .always

        // Create a padding view for padding on right
        projectNameTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: projectNameTextfield.frame.height))
        projectNameTextfield.rightViewMode = .always
        

        
        
        
        descriptionTextview = UITextView()
        descriptionTextview.delegate = self
//        descriptionTextview.isScrollEnabled = false
        descriptionTextview.text = NSLocalizedString("Description", comment: "")
        descriptionTextview.textColor = UIColor.lightGray
        descriptionTextview.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(projectNameTextfield)
            make.top.equalTo(projectNameTextfield.snp.bottom).offset(10)
            make.height.equalTo(100)
        }
        descriptionTextview.layer.borderWidth = 0.5
        descriptionTextview.layer.borderColor = UIColor.lightGray.cgColor
        descriptionTextview.layer.cornerRadius = 10.0
        descriptionTextview.clipsToBounds = true

        
  
        let aboutBGView = UIView()
        aboutBGView.backgroundColor = Color.litePink
        scrollView.addSubview(aboutBGView)
        
        aboutBGView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.leading.trailing.equalTo(self.view)
            make.bottom.equalTo(descriptionTextview.snp.bottom).offset(20)
        }
        scrollView.sendSubviewToBack(aboutBGView)
        
        
        let timelineLabel = UILabel()
        timelineLabel.text = NSLocalizedString("Project Timeline", comment: "")
        timelineLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14.0)
        scrollView.addSubview(timelineLabel)
        
        timelineLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(aboutBGView.snp.bottom).offset(20)
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd MMM, yyyy"
        let dateStr = formatter.string(from: Date())
            
        let startDateString = NSLocalizedString("Start Date", comment: "")
        let dateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(startDateString) \n\(dateStr)     .")
        let tcAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                          NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        dateString.addAttributes(tcAttributes, range: NSMakeRange(0, startDateString.count))
        let privacyAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        dateString.addAttributes(privacyAttributes, range: NSMakeRange(startDateString.count+1, dateStr.count-1))
        let dotAttr = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        dateString.addAttributes(dotAttr, range: NSMakeRange(dateString.length-1, 1))
        
        startButton = UIButton()
        startButton.backgroundColor = .white
        startButton.setImage(UIImage(named: "calendar"), for: .normal)
        startButton.backgroundColor = Color.liteWhite
        startButton.setTitleColor(Color.liteBlack, for: .normal)
        startButton.semanticContentAttribute = .forceRightToLeft
        startButton.setAttributedTitle(dateString, for: .normal)
        startButton.titleLabel?.numberOfLines = 0
        startButton.tag = 0
        startButton.addTarget(self, action: #selector(self.datePopup), for: .touchUpInside)
        startButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        scrollView.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.leading.equalTo(timelineLabel)
            make.top.equalTo(timelineLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.width.equalTo(self.view.frame.size.width/2.35)
        }
        startButton.layer.borderColor = UIColor.lightGray.cgColor
        startButton.layer.cornerRadius = 5.0
        startButton.layer.borderWidth = 0.5
        startButton.clipsToBounds = true
        
        
        let endDateString1 = NSLocalizedString("End Date", comment: "")
        let endDateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(endDateString1) \n\(dateStr)     .")
        let tcAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                          NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        endDateString.addAttributes(tcAttributes1, range: NSMakeRange(0, endDateString1.count))
        let privacyAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        endDateString.addAttributes(privacyAttributes1, range: NSMakeRange(endDateString1.count+1, dateStr.count-1))
        let dotAttr1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                          NSAttributedString.Key.foregroundColor: UIColor.black]
        endDateString.addAttributes(dotAttr1, range: NSMakeRange(endDateString.length-1, 1))
        
        endButton = UIButton()
        endButton.backgroundColor = .white
        endButton.setImage(UIImage(named: "calendar"), for: .normal)
        endButton.backgroundColor = Color.liteWhite
        endButton.setTitleColor(Color.liteBlack, for: .normal)
        endButton.semanticContentAttribute = .forceRightToLeft
        endButton.setAttributedTitle(endDateString, for: .normal)
        endButton.titleLabel?.numberOfLines = 0
        endButton.tag = 1
        endButton.addTarget(self, action: #selector(self.datePopup), for: .touchUpInside)
        endButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        scrollView.addSubview(endButton)
        
        endButton.snp.makeConstraints { (make) in
            make.leading.equalTo(startButton.snp.trailing).offset(20)
            make.top.equalTo(timelineLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.width.equalTo(self.view.frame.size.width/2.35)
        }
        
        endButton.layer.borderColor = UIColor.lightGray.cgColor
        endButton.layer.cornerRadius = 5.0
        endButton.layer.borderWidth = 0.5
        endButton.clipsToBounds = true
                
        let timelineView = UIView()
        timelineView.backgroundColor = Color.litePink
        scrollView.addSubview(timelineView)
        
        timelineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(aboutBGView.snp.bottom).offset(10)
            make.bottom.equalTo(startButton.snp.bottom).offset(20)
        }
        scrollView.sendSubviewToBack(timelineView)
        
        self.navigationBarItems()
       
        
        
        //Budget UI
        
        let budgetLabel = UILabel()
        budgetLabel.text = NSLocalizedString("Budget", comment: "")
        budgetLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14.0)
        scrollView.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(20)
            make.top.equalTo(timelineView.snp.bottom).offset(20)
        }
            
        //Budget textfield
        budgetTextfield = FloatingTextfield()
        budgetTextfield.placeholder = NSLocalizedString("Budget", comment: "")
        budgetTextfield.backgroundColor = .white
        budgetTextfield.leftPadding = 10
        budgetTextfield.rightPadding = 20
        budgetTextfield.keyboardType = .numberPad
        budgetTextfield.font = UIFont.systemFont(ofSize: 14.0)
        scrollView.addSubview(budgetTextfield)
        
        budgetTextfield.snp.makeConstraints { (make) in
            make.leading.equalTo(startButton)
            make.top.equalTo(budgetLabel.snp.bottom).offset(10)
            make.height.equalTo(44)
            make.trailing.equalTo(endButton)
        }
        
        budgetTextfield.layer.borderColor = UIColor.lightGray.cgColor
        budgetTextfield.layer.cornerRadius = 5.0
        budgetTextfield.layer.borderWidth = 0.5
        budgetTextfield.clipsToBounds = true
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            projectNameTextfield.textAlignment = .right
            descriptionTextview.textAlignment = .right
            budgetTextfield.textAlignment = .right
            budgetTextfield.titleLabel.textAlignment = .right
        }else{
            projectNameTextfield.textAlignment = .left
            descriptionTextview.textAlignment = .left
            budgetTextfield.textAlignment = .left
            budgetTextfield.titleLabel.textAlignment = .left
        }
        
        
        let budgetView = UIView()
        budgetView.backgroundColor = Color.litePink
        scrollView.addSubview(budgetView)
        
        budgetView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.top.equalTo(timelineView.snp.bottom).offset(10)
            make.bottom.equalTo(budgetTextfield.snp.bottom).offset(20)
        }
        scrollView.sendSubviewToBack(budgetView)
        
        if isCompany {
            //Location
            let LocationLabel = UILabel()
            LocationLabel.text = NSLocalizedString("Location", comment: "")
            LocationLabel.font = UIFont(name: "AvenirLTStd-Black", size: 14.0)
            scrollView.addSubview(LocationLabel)
            
            LocationLabel.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view).inset(20)
                make.top.equalTo(budgetView.snp.bottom).offset(20)
            }
            
            countryTextfield = FloatingTextfield()
            countryTextfield.leftPadding = 10
            countryTextfield.rightPadding = 20
            countryTextfield.placeholder = NSLocalizedString("Country", comment: "")
            countryTextfield.backgroundColor = .white
            countryTextfield.keyboardType = .numberPad
            countryTextfield.font = UIFont.systemFont(ofSize: 14.0)
            scrollView.addSubview(countryTextfield)
            
            countryTextfield.snp.makeConstraints { (make) in
                make.leading.equalTo(startButton)
                make.top.equalTo(LocationLabel.snp.bottom).offset(10)
                make.height.equalTo(44)
                make.trailing.equalTo(endButton)
            }
            countryTextfield.layer.borderColor = UIColor.lightGray.cgColor
            countryTextfield.layer.cornerRadius = 5.0
            countryTextfield.layer.borderWidth = 0.5
            countryTextfield.clipsToBounds = true
            countryTextfield.inputView = UIView()
            
            countryTextfield.isUserInteractionEnabled = true
            countryTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(countryPicker)))
            
//            let locimageView = UIImageView()
//            locimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//            locimageView.image = UIImage(named: "location_1")
//            locimageView.contentMode = .scaleAspectFit
//            let locLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 20))
//            locLeftView.addSubview(locimageView)
//            locationTextfield.leftView = locLeftView
//            locationTextfield.layer.borderWidth = 0
            
            let locimageView = UIImageView()
            locimageView.frame = CGRect(x: 5, y: 0, width: 10, height: 10)
            locimageView.image = UIImage(named: "dropdown")
            locimageView.contentMode = .scaleAspectFit
            let locLeftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            locLeftView.addSubview(locimageView)
            
            
            
            cityTextfield = FloatingTextfield()
            cityTextfield.leftPadding = 10
            cityTextfield.rightPadding = 20
            cityTextfield.placeholder = NSLocalizedString("City", comment: "")
            cityTextfield.backgroundColor = .white
            cityTextfield.keyboardType = .numberPad
            cityTextfield.font = UIFont.systemFont(ofSize: 14.0)
            scrollView.addSubview(cityTextfield)
            
            cityTextfield.snp.makeConstraints { (make) in
                make.leading.equalTo(startButton)
                make.top.equalTo(countryTextfield.snp.bottom).offset(10)
                make.height.equalTo(44)
                make.trailing.equalTo(endButton)
            }
            cityTextfield.layer.borderColor = UIColor.lightGray.cgColor
            cityTextfield.layer.cornerRadius = 5.0
            cityTextfield.layer.borderWidth = 0.5
            cityTextfield.clipsToBounds = true
            
            cityTextfield.isUserInteractionEnabled = true
            cityTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(cityPicker)))
            
            let locimageView1 = UIImageView()
            locimageView1.frame = CGRect(x: 5, y: 0, width: 10, height: 10)
            locimageView1.image = UIImage(named: "dropdown")
            locimageView1.contentMode = .scaleAspectFit
            let locLeftView1 = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 10))
            locLeftView1.addSubview(locimageView1)
            
            
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                cityTextfield.leftViewMode = .always
                cityTextfield.leftView = locLeftView1
                
                countryTextfield.leftViewMode = .always
                countryTextfield.leftView = locLeftView
            }else{
                cityTextfield.rightViewMode = .always
                cityTextfield.rightView = locLeftView1
                
                countryTextfield.rightViewMode = .always
                countryTextfield.rightView = locLeftView
            }
            
            let locationView = UIView()
            locationView.backgroundColor = Color.litePink
            scrollView.addSubview(locationView)
            
            locationView.snp.makeConstraints { (make) in
                make.leading.trailing.equalTo(self.view)
                make.top.equalTo(budgetView.snp.bottom).offset(10)
                make.bottom.equalTo(cityTextfield.snp.bottom).offset(20)
            }
            scrollView.sendSubviewToBack(locationView)
            
            
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
               
                countryTextfield.textAlignment = .right
                countryTextfield.titleLabel.textAlignment = .right
                
                cityTextfield.textAlignment = .right
                cityTextfield.titleLabel.textAlignment = .right
            }else{
                
                countryTextfield.textAlignment = .left
                countryTextfield.titleLabel.textAlignment = .left
                
                cityTextfield.textAlignment = .left
                cityTextfield.titleLabel.textAlignment = .left
            }
            
            
        }
        
        
        let saveButton = UIButton()
        if editProject{
            saveButton.setTitle(NSLocalizedString("Update Project", comment: ""), for: .normal)
        }else{
            saveButton.setTitle(NSLocalizedString("Save Project", comment: ""), for: .normal)
        }
        saveButton.backgroundColor = Color.red
        saveButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        saveButton.addTarget(self, action: #selector(self.saveButtonAction), for: .touchUpInside)
        self.view.addSubview(saveButton)
        
        saveButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.equalTo(self.view).inset(20)
            make.bottom.equalTo(self.view).inset(25)
        }
        
        saveButton.layer.cornerRadius = 5.0
        saveButton.clipsToBounds = true
        
        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(saveButton.snp.top).offset(-10)
        }
        
        
        //MARK: Auto fill details for Edit project
        
        if editProject{
            projectNameTextfield.text = projectName
            descriptionTextview.text = projectDesc
            
            let budgetFloat = Float(budget) ?? 0.00
            let budgetInt = Int(budgetFloat)
            budgetTextfield.text = String(budgetInt)
            self.title = NSLocalizedString("Edit Project", comment: "")
            descriptionTextview.textColor = UIColor.black
            
            if isCompany{
                self.cityTextfield.text = cityString
                self.countryTextfield.text = countryString
            }
    
            
            if let dateString = startDateStr{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let startDate = dateFormatter.string(from: dateObj!)
                
                let startDateStr = NSLocalizedString("Start Date", comment: "")
                let startDateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(startDateStr) \n\(startDate )     .")
                let tcAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                                  NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                startDateString.addAttributes(tcAttributes1, range: NSMakeRange(0, startDateStr.count+2))
                let privacyAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                                  NSAttributedString.Key.foregroundColor: UIColor.black]
                startDateString.addAttributes(privacyAttributes1, range: NSMakeRange(startDateStr.count+4, dateStr.count-1))
                let dotAttr1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                                  NSAttributedString.Key.foregroundColor: UIColor.black]
                startDateString.addAttributes(dotAttr1, range: NSMakeRange(startDateString.length-1, 1))
                self.startButton.setAttributedTitle(startDateString, for: .normal)

                
            }
            
            if let dateString = endDateStr{
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                dateFormatter.locale = Locale.init(identifier: "en_GB")
                
                let dateObj = dateFormatter.date(from: dateString)
                dateFormatter.dateFormat = "dd MMM, yyyy"
                let endDate = dateFormatter.string(from: dateObj!)
                
                let endDateStr = NSLocalizedString("End Date", comment: "")
                let endDateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(endDateStr) \n\(endDate )     .")
                let tcAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                                  NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                endDateString.addAttributes(tcAttributes1, range: NSMakeRange(0, endDateStr.count+2))
                let privacyAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                                  NSAttributedString.Key.foregroundColor: UIColor.black]
                endDateString.addAttributes(privacyAttributes1, range: NSMakeRange(endDateStr.count+4, dateStr.count-1))
                let dotAttr1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                                  NSAttributedString.Key.foregroundColor: UIColor.black]
                endDateString.addAttributes(dotAttr1, range: NSMakeRange(endDateString.length-1, 1))
                self.endButton.setAttributedTitle(endDateString, for: .normal)

            }
            
        }
    }
    
    @objc func countryPicker(){
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search country", comment: "")
        ccVC.countryCodeDelegate = self
        self.navigationController?.pushViewController(ccVC, animated: true)
//        present(ccVC, animated: true, completion: nil)
        
    }
    
    @objc func cityPicker(){
        
        if countryId == nil{
            Banner().displayValidationError(string: NSLocalizedString("Please select country to proceed", comment: ""))
            return
        }
        
        let ccVC = CountriesViewController()
        ccVC.titleString = NSLocalizedString("Search city", comment: "")
        ccVC.countryCodeDelegate = self
//        ccVC.citiesArray = citiesArray
        ccVC.countryId = countryId
        self.navigationController?.pushViewController(ccVC, animated: true)
    }
    
    @objc func saveButtonAction(){
            
        if projectNameTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please enter valid name", comment: ""))
        }else if descriptionTextview.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please enter valid description", comment: ""))
        }else if budgetTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please enter valid budget", comment: ""))
        }
        else if isCompany && countryTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid country Name", comment: ""))
        }
        else if isCompany && cityTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid city Name", comment: ""))
        }
        else{
            self.createProjectApi()
        }
        
    }
    
    func createProjectApi(){
        
        if editProject{
            
            let paramsDict = NSMutableDictionary()
            
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "name" : projectNameTextfield.text ?? "",
                "description" : descriptionTextview.text ?? "",
                "budget" : budgetTextfield.text ?? "",
                "start_at" : startDateStr ?? "",
                "end_at" : endDateStr ?? "",
                "project_id" : projectId ?? ""
            ]
            
            paramsDict.addEntries(from: parameters)
            
            if isCompany{
                
                let companyParams: [String: Any] = [
                    "country_id" : self.countryId ?? 0,
                    "city_id" : self.cityId ?? 0,
                ]
                
                paramsDict.addEntries(from: companyParams)
            }
            
            
            WebServices.postRequest(url: Url.updateProject, params: paramsDict as! [String : Any], viewController: self) { success,data  in
                
                if success{
                    Banner().displaySuccess(string: NSLocalizedString("Project Successfully updated", comment: ""))
                    
                    NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                    NotificationCenter.default.post(name: Notification.updateProject, object: nil)

                    self.navigationController?.popViewController(animated: true)
                }else{
                    
                }
                
            }
        }else{
            
            let paramsDict = NSMutableDictionary()
            
            let parameters: [String: Any] = [
                
                "current_version" : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
                "locale" : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
                "device_id": UIDevice.current.identifierForVendor!.uuidString,
                "device_type" : "ios",
                "name" : projectNameTextfield.text ?? "",
                "description" : descriptionTextview.text ?? "",
                "budget" : budgetTextfield.text ?? "",
                "start_at" : startDateStr ?? "",
                "end_at" : endDateStr ?? ""
            ]
            
            paramsDict.addEntries(from: parameters)
            
            if isCompany{
                
                let companyParams: [String: Any] = [
                    "country_id" : self.countryId ?? 0,
                    "city_id" : self.cityId ?? 0,
                ]
                
                paramsDict.addEntries(from: companyParams)
            }
            
            
            WebServices.postRequest(url: Url.createProject, params: paramsDict as! [String : Any], viewController: self) { success,data  in
                
                if success{
                    Banner().displaySuccess(string: NSLocalizedString("Project Successfully created", comment: ""))

                    NotificationCenter.default.post(name: Notification.dashboard, object: nil)
                    self.navigationController?.popViewController(animated: true)
                }
                else{
                    
                }
                
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Create Project", comment: "")
        
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
    
    
    @objc func datePopup(_ dateType:UIButton){

        let minDate = Date()
        if dateType.tag == 1{ // End date minimum validation
            if self.minEndDate == Date(){
                self.minEndDate = minDate
            }
        }else{
            self.minEndDate = minDate
        }
        
        
        let currentDate = Date()
        var dateComponents1 = DateComponents()
        dateComponents1.month = 12
//        let twelveMonthsAfter = Calendar.current.date(byAdding: dateComponents1, to: currentDate)
        datePicker.show("",
                        doneButtonTitle: NSLocalizedString("Done", comment: ""),
                        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                        minimumDate: self.minEndDate,
                        maximumDate: nil,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                self.minEndDate = dt
                
//                let formatter = DateFormatter()
//                formatter.locale = Locale(identifier: "en_US_POSIX")
//                formatter.dateFormat = "yyyy-MM-dd"
//                let date = formatter.string(from: dt)
                
                if dateType.tag == 0{
                    
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "dd MMM, yyyy"
                    let dateStr = formatter.string(from: dt)
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.startDateStr = formatter.string(from: dt)

                                            
                    let startDateString = NSLocalizedString("Start Date", comment: "")
                    let dateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(startDateString) \n\(dateStr)     .")
                    let tcAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                    dateString.addAttributes(tcAttributes, range: NSMakeRange(0, startDateString.count+1))
                    let privacyAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.black]
                    dateString.addAttributes(privacyAttributes, range: NSMakeRange(startDateString.count+2, dateStr.count-1))
                    let dotAttr = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.black]
                    dateString.addAttributes(dotAttr, range: NSMakeRange(dateString.length-1, 1))
                    self.startButton.setAttributedTitle(dateString, for: .normal)
                    
                    
                    if self.endDate == nil{
                        
                        self.endDateStr = formatter.string(from: dt)
                        let endDateString = NSLocalizedString("End Date", comment: "")

                        let dateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(endDateString) \n\(dateStr)     .")
                        let tcAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                                          NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                        dateString.addAttributes(tcAttributes, range: NSMakeRange(0, endDateString.count+1))
                        let privacyAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                                          NSAttributedString.Key.foregroundColor: UIColor.black]
                        dateString.addAttributes(privacyAttributes, range: NSMakeRange(endDateString.count+2, dateStr.count-1))
                        let dotAttr = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                                          NSAttributedString.Key.foregroundColor: UIColor.black]
                        dateString.addAttributes(dotAttr, range: NSMakeRange(dateString.length-1, 1))
                        self.endButton.setAttributedTitle(dateString, for: .normal)
                    }
                    
                    /*
                    if let startDate = formatter.date(from:dateArray[0]) {
                        let endDate = formatter.date(from:date)!
                        
                        let startDateComparisionResult:ComparisonResult = startDate.compare(endDate)
                        if startDateComparisionResult == ComparisonResult.orderedDescending
                        {
                            print("future date is smaller")
                            Banner().displayValidationError(string: "Future date is smaller")
                            return
                        }
                    }
                     */
                }else if dateType.tag == 1{
//                    self.endButton.setTitle(date, for: .normal)
                    
                    
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "dd MMM, yyyy"
                    let dateStr = formatter.string(from: dt)
                    
                    formatter.dateFormat = "yyyy-MM-dd"
                    self.endDateStr = formatter.string(from: dt)
                    let endDateString1 = NSLocalizedString("End Date", comment: "")
                    let endDateString: NSMutableAttributedString = NSMutableAttributedString(string: "\(endDateString1) \n\(dateStr)     .")
                    let tcAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 12)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.lightGray]
                    endDateString.addAttributes(tcAttributes1, range: NSMakeRange(0, endDateString1.count+1))
                    let privacyAttributes1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 14)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.black]
                    endDateString.addAttributes(privacyAttributes1, range: NSMakeRange(endDateString1.count+1, dateStr.count-1))
                    let dotAttr1 = [NSAttributedString.Key.font: UIFont(name: "AvenirLTStd-Book", size: 4)!,
                                      NSAttributedString.Key.foregroundColor: UIColor.black]
                    endDateString.addAttributes(dotAttr1, range: NSMakeRange(endDateString.length-1, 1))
                    
                    self.endButton.setAttributedTitle(endDateString, for: .normal)

                    /*
                    let startDate = formatter.date(from:date)!
                    let endDate = formatter.date(from:dateArray[1])!
                    
                    let startDateComparisionResult:ComparisonResult = startDate.compare(endDate)
                    if startDateComparisionResult == ComparisonResult.orderedDescending
                    {
                        print("future date is smaller")
                        Banner().displayValidationError(string: "Future date is smaller")
                        return
                    }
                     */
                }
                
            }
        }
        
    }
    
//    @objc func endButtonAction(){
//
//
//        let currentDate = Date()
//        var dateComponents1 = DateComponents()
//        dateComponents1.month = 12
//        let twelveMonthsAfter = Calendar.current.date(byAdding: dateComponents1, to: currentDate)
//        datePicker.show("DatePickerDialog",
//                        doneButtonTitle: "Done",
//                        cancelButtonTitle: "Cancel",
//                        minimumDate: Date(),
//                        maximumDate: twelveMonthsAfter,
//                        datePickerMode: .date) { (date) in
//            if let dt = date {
//                let formatter = DateFormatter()
//                formatter.locale = Locale(identifier: "en_US_POSIX")
//                formatter.dateFormat = "yyyy-MM-dd"
//                let date = formatter.string(from: dt)
//                dateArray[dateIndex] = date
//
//                if dateIndex == 1{
//
//                    if let startDate = formatter.date(from:dateArray[0]) {
//                        let endDate = formatter.date(from:date)!
//
//                        let startDateComparisionResult:ComparisonResult = startDate.compare(endDate)
//                        if startDateComparisionResult == ComparisonResult.orderedDescending
//                        {
//                            print("future date is smaller")
//                            Banner().displayValidationError(string: "Future date is smaller")
//                            return
//                        }
//                    }
//                }else if dateIndex == 0{
//
//                    if dateArray[1] != ""{
//
//                    let startDate = formatter.date(from:date)!
//                    let endDate = formatter.date(from:dateArray[1])!
//
//                    let startDateComparisionResult:ComparisonResult = startDate.compare(endDate)
//                    if startDateComparisionResult == ComparisonResult.orderedDescending
//                    {
//                        print("future date is smaller")
//                        Banner().displayValidationError(string: "Future date is smaller")
//                        return
//                    }
//
//                    }
//
//                }
//
//            }
//        }
//
//    }
    
}


extension CreateProjectViewController : UITextViewDelegate{
    
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText newText: String) -> Bool {
//
//        print("txt height \(redViewWidthConstraint?.layoutConstraints[0].constant)")
//
//            return true
//        }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Description", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
}


extension CreateProjectViewController : countryCodeProtocol{

    @objc func selectedCountry(countryName : String, countryId : Int){
        countryTextfield.text = countryName
//      self.citiesArray = cities
        self.countryId = countryId
        cityTextfield.text = ""
    }
    
    @objc func selectedCity(cityName: String, cityId: Int) {
        cityTextfield.text = cityName
        self.cityId = cityId
    }

}
