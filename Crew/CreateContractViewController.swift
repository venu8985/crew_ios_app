//
//  RequestSummaryViewController.swift
//  Crew
//
//  Created by Rajeev on 11/03/21.
//

import UIKit
import SkyFloatingLabelTextField
import DatePickerDialog

class CreateContractViewController: UIViewController {
    
    var addSignature = true
    var tickButton : UIButton!
    var datesCount = 0
    
    var datesTableView          : UITableView!
    var createNewButton         : UIButton!
    var savedContractButton     : UIButton!
    var contractNumbertextField : FloatingTextfield!
    var contractNametextField   : FloatingTextfield!
    var descriptionTextview     : UITextView!
    var startDateTextfield      : FloatingTextfield!
    var endDateTextfield        : FloatingTextfield!
    var locationTextfield       : FloatingTextfield!
    var milestonesArray         : NSMutableArray!
    
    var latitude : Double!
    var longitude : Double!
    var scrollView : UIScrollView!
    
    var startdateToValidate = Date()

    var totalDays = 0 {
        didSet{
            self.daysLabel.text = "\(totalDays) \(NSLocalizedString("Days", comment: ""))"
        }
    }
    var daysLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        datesCount = CreateContract.shared.dateRangeArray.count
        
        self.title = NSLocalizedString("Create contract", comment: "")
        self.view.backgroundColor = Color.litePink
        
        self.navigationBarItems()
        
        
        //MARK: BottomView UI
        let createButton = UIButton()
        createButton.setTitle(NSLocalizedString("Submit Request", comment: ""), for: .normal)
        createButton.backgroundColor = Color.red
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        createButton.addTarget(self, action: #selector(self.createButtonAction), for: .touchUpInside)
        self.view.addSubview(createButton)
        
        createButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        createButton.layer.cornerRadius = 5.0
        createButton.clipsToBounds = true
        
        
        
        
        let separtorLineView = UIView()
        separtorLineView.backgroundColor = Color.gray
        self.view.addSubview(separtorLineView)
        
        separtorLineView.snp.makeConstraints { (make) in
            make.width.equalTo(1.5)
            make.centerX.equalTo(createButton)
            make.height.equalTo(40)
            make.bottom.equalTo(createButton.snp.top).offset(-15)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = Color.gray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(separtorLineView.snp.top).offset(-5)
        }
        
        let charges = CreateContract.shared.charges ?? ""
        let chargesUnit = CreateContract.shared.chargesUnit ?? ""
        
        let perdayAmountLabel = UILabel()
        perdayAmountLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(charges)/\(chargesUnit)"
        perdayAmountLabel.font = UIFont.systemFont(ofSize: 14.0)
        perdayAmountLabel.textAlignment = .right
        self.view.addSubview(perdayAmountLabel)
        
        perdayAmountLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(separtorLineView).offset(-10)
            make.bottom.equalTo(separtorLineView)
        }
        
        daysLabel = UILabel()
        daysLabel.textAlignment = .right
        daysLabel.font = UIFont.systemFont(ofSize: 12.0)
        daysLabel.textColor = UIColor.lightGray
        self.view.addSubview(daysLabel)
        
        daysLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(perdayAmountLabel)
            make.bottom.equalTo(perdayAmountLabel.snp.top).offset(-5)
        }
        
        let totalAmountLabel = UILabel()
        totalAmountLabel.text = "\(NSLocalizedString("SAR", comment: "")) \(CreateContract.shared.totalAmount ?? 0)"
        totalAmountLabel.font = UIFont.systemFont(ofSize: 14.0)
        totalAmountLabel.textAlignment = .left
        self.view.addSubview(totalAmountLabel)
        
        totalAmountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(separtorLineView).offset(10)
            make.bottom.equalTo(separtorLineView)
        }
        
        let amountLabel = UILabel()
        amountLabel.textAlignment = .left
        amountLabel.text = NSLocalizedString("Total Amount", comment: "")
        amountLabel.font = UIFont.systemFont(ofSize: 12.0)
        amountLabel.textColor = UIColor.lightGray
        self.view.addSubview(amountLabel)
        
        amountLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(totalAmountLabel)
            make.bottom.equalTo(totalAmountLabel.snp.top).offset(-5)
        }
        
        
        tickButton = UIButton()
        let tickImage = UIImage(named: "tick")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFill)
        tickButton.setImage(tickImage, for: .normal)
//        tickButton.addTarget(self, action: #selector(addSignatureAction), for: .touchUpInside)
        self.view.addSubview(tickButton)
        
        tickButton.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.width.height.equalTo(40)
            make.bottom.equalTo(lineView.snp.top).offset(-05)
        }
        
        let addSignatureButton = UIButton()
        addSignatureButton.setTitle(NSLocalizedString("  Add my signature", comment: ""), for: .normal)
        addSignatureButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        addSignatureButton.setTitleColor(UIColor.black, for: .normal)
//        addSignatureButton.addTarget(self, action: #selector(addSignatureAction), for: .touchUpInside)
        self.view.addSubview(addSignatureButton)
        
        addSignatureButton.snp.makeConstraints { (make) in
            make.leading.equalTo(tickButton.snp.trailing)
            make.centerY.equalTo(tickButton)
        }
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            addSignatureButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        scrollView = UIScrollView()
        scrollView.backgroundColor = .clear //UIColor(hexString: Color.litePink)
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat((datesCount*40)+550))
        self.view.addSubview(scrollView)
        
        scrollView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.leading.trailing.top.equalTo(self.view).offset(10)
            make.bottom.equalTo(tickButton.snp.top).offset(-10)
        }
        
        //MARK: Dates tableview UI
        
        datesTableView = UITableView()
        datesTableView.frame = CGRect(x: 0, y: 0, width: Int(self.view.frame.size.width), height: (datesCount*40)+20)
        datesTableView.separatorStyle = .none
        datesTableView.delegate = self
        datesTableView.dataSource = self
        datesTableView.isScrollEnabled = false
        datesTableView.backgroundColor = Color.litePink
        scrollView.addSubview(datesTableView)
        datesTableView.register(DateRangeTVCell.self, forCellReuseIdentifier: "cell")
        
        
        let whiteLineView = UIView()
        whiteLineView.backgroundColor = .white
        scrollView.addSubview(whiteLineView)
        
        whiteLineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(datesTableView)
            make.top.equalTo(datesTableView.snp.bottom).offset(07)
            make.height.equalTo(07)
        }
        
        //MARK: contract UI
        
        let createContractLabel = UILabel()
        createContractLabel.text = NSLocalizedString("Create contract", comment: "")
        createContractLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        scrollView.addSubview(createContractLabel)
        
        createContractLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(datesTableView).offset(10)
            make.top.equalTo(whiteLineView.snp.bottom).offset(10)
        }
        
        
        let emptyCircleImage = UIImage(named: "select")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        createNewButton = UIButton()
        createNewButton.setTitle(NSLocalizedString(" Create New", comment: ""), for: .normal)
        createNewButton.setImage(emptyCircleImage, for: .normal)
        createNewButton.setTitleColor(.black, for: .normal)
        createNewButton.tag = 0
        createNewButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        createNewButton.addTarget(self, action: #selector(self.contractButtonAction), for: .touchUpInside)
        scrollView.addSubview(createNewButton)
        
        createNewButton.snp.makeConstraints { (make) in
            make.leading.equalTo(createContractLabel)
            make.top.equalTo(createContractLabel.snp.bottom).offset(10)
        }
        
        
        let filledCircleImage = UIImage(named: "create_new")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        savedContractButton = UIButton()
        savedContractButton.setTitle(NSLocalizedString(" From my saved contracts", comment: ""), for: .normal)
        savedContractButton.setImage(filledCircleImage, for: .normal)
        savedContractButton.setTitleColor(.black, for: .normal)
        savedContractButton.tag = 1
        savedContractButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        savedContractButton.addTarget(self, action: #selector(self.contractButtonAction), for: .touchUpInside)
        scrollView.addSubview(savedContractButton)
        
        savedContractButton.snp.makeConstraints { (make) in
            make.leading.equalTo(createNewButton.snp.trailing).offset(20)
            make.top.equalTo(createContractLabel.snp.bottom).offset(10)
        }
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            savedContractButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            createNewButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        
        contractNumbertextField = FloatingTextfield()
        contractNumbertextField.leftPadding = 10
        contractNumbertextField.rightPadding = 20
        contractNumbertextField.placeholder = NSLocalizedString("Contract Number", comment: "")
        scrollView.addSubview(contractNumbertextField)
        
        contractNumbertextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(10)
            make.top.equalTo(createNewButton.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
        
        
        contractNametextField = FloatingTextfield()
        contractNametextField.leftPadding = 10
        contractNametextField.rightPadding = 20
        contractNametextField.placeholder = NSLocalizedString("Contract Name", comment: "")
        scrollView.addSubview(contractNametextField)
        
        contractNametextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contractNumbertextField)
            make.top.equalTo(contractNumbertextField.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
        
    
        startDateTextfield = FloatingTextfield()
        startDateTextfield.leftPadding = 10
        startDateTextfield.rightPadding = 20
        startDateTextfield.placeholder = NSLocalizedString("Start Date", comment: "")
        scrollView.addSubview(startDateTextfield)
                
        startDateTextfield.snp.makeConstraints { (make) in
            make.leading.equalTo(contractNametextField)
            make.top.equalTo(contractNametextField.snp.bottom).offset(15)
            make.width.equalTo((self.view.frame.size.width-15)/2)
            make.height.equalTo(45)
        }
        
        startDateTextfield.inputView = UIView()
        startDateTextfield.isUserInteractionEnabled = true
        startDateTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(startDateAction)))
        
        
        endDateTextfield = FloatingTextfield()
        endDateTextfield.leftPadding = 10
        endDateTextfield.rightPadding = 20
        endDateTextfield.placeholder = NSLocalizedString("End Date", comment: "")
        scrollView.addSubview(endDateTextfield)
        
        endDateTextfield.snp.makeConstraints { (make) in
            make.trailing.equalTo(contractNametextField)
            make.top.equalTo(contractNametextField.snp.bottom).offset(15)
            make.width.equalTo((self.view.frame.size.width-65)/2)
            make.height.equalTo(45)
        }
        
        endDateTextfield.rightViewMode = UITextField.ViewMode.always
        
        endDateTextfield.inputView = UIView()
        endDateTextfield.isUserInteractionEnabled = true
        endDateTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(endDateAction)))
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
           
            startDateTextfield.textAlignment = .right
            startDateTextfield.titleLabel.textAlignment = .right
            endDateTextfield.textAlignment = .right
            endDateTextfield.titleLabel.textAlignment = .right
        }else{
            
            startDateTextfield.textAlignment = .left
            startDateTextfield.titleLabel.textAlignment = .left
            endDateTextfield.textAlignment = .left
            endDateTextfield.titleLabel.textAlignment = .left
        }
        

//        let calimageView = UIImageView()
//        calimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
//        calimageView.image = image
//        calimageView.contentMode = .scaleAspectFit
//
//        // create the view that would act as the padding
//        let calRightView = UIView(frame: CGRect(
//                                    x: 0, y: 0, // keep this as 0, 0
//                                    width: 30, // add the padding
//                                    height: 20))
//        calRightView.addSubview(calimageView)
//
//        endDateTextfield.rightView = calRightView
        
        

        locationTextfield = FloatingTextfield()
        locationTextfield.leftPadding = 10
        locationTextfield.rightPadding = 20
        locationTextfield.placeholder = NSLocalizedString("Location", comment: "")
        scrollView.addSubview(locationTextfield)
        locationTextfield.inputView = UIView()
        locationTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contractNametextField)
            make.top.equalTo(startDateTextfield.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
        

        let image = UIImage(named: "calendar")
        let locationimageView = UIImageView()
        locationTextfield.isUserInteractionEnabled = true
        locationimageView.isUserInteractionEnabled = true
        locationTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(locationAction)))
        locationimageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(locationAction)))
        descriptionTextview = UITextView()

        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            
            contractNumbertextField.textAlignment = .right
            contractNumbertextField.titleLabel.textAlignment = .right
            
            contractNametextField.textAlignment = .right
            contractNametextField.titleLabel.textAlignment = .right
            
//            startDateTextfield.textAlignment = .right
//            startDateTextfield.titleLabel.textAlignment = .right
            
            locationTextfield.textAlignment = .left
            locationTextfield.titleLabel.textAlignment = .left
            
            descriptionTextview.textAlignment = .right
            
            startDateTextfield.leftViewMode = UITextField.ViewMode.always
            
            let imageView = UIImageView()
            imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            // create the view that would act as the padding
            let rightView = UIView(frame: CGRect(
                                    x: 0, y: 0, // keep this as 0, 0
                                    width: 30, // add the padding
                                    height: 20))
            rightView.addSubview(imageView)
            
            startDateTextfield.leftView = rightView
            
            
            
            locationimageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
            locationimageView.image = UIImage(named: "gps1")
            locationimageView.contentMode = .scaleAspectFit
            
            let locationRightView = UIView(frame: CGRect(
                                            x: 0, y: 0, // keep this as 0, 0
                                            width: 30, // add the padding
                                            height: 20))
            locationRightView.addSubview(locationimageView)
           
            
            locationTextfield.leftViewMode = UITextField.ViewMode.always
            locationTextfield.leftView = locationRightView
            
            
            endDateTextfield.leftViewMode = UITextField.ViewMode.always
            let imageView1 = UIImageView()
            imageView1.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
            imageView1.image = image
            imageView1.contentMode = .scaleAspectFit
            
            // create the view that would act as the padding
            let rightView1 = UIView(frame: CGRect(
                                    x: 0, y: 0, // keep this as 0, 0
                                    width: 30, // add the padding
                                    height: 20))
            rightView1.addSubview(imageView1)
            
            endDateTextfield.leftView = rightView1
            
            
            
        }else{
            contractNumbertextField.textAlignment = .left
            contractNumbertextField.titleLabel.textAlignment = .left
            
            contractNametextField.textAlignment = .left
            contractNametextField.titleLabel.textAlignment = .left
            
//            startDateTextfield.textAlignment = .left
//            startDateTextfield.titleLabel.textAlignment = .left
            
            locationTextfield.textAlignment = .left
            locationTextfield.titleLabel.textAlignment = .left
            
            descriptionTextview.textAlignment = .left
            
            
            startDateTextfield.rightViewMode = UITextField.ViewMode.always
            
            let imageView = UIImageView()
            let image = UIImage(named: "calendar")
            imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            imageView.image = image
            imageView.contentMode = .scaleAspectFit
            
            // create the view that would act as the padding
            let rightView = UIView(frame: CGRect(
                                    x: 0, y: 0, // keep this as 0, 0
                                    width: 30, // add the padding
                                    height: 20))
            rightView.addSubview(imageView)
            
            startDateTextfield.rightView = rightView

            
            
            locationimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            locationimageView.image = UIImage(named: "gps1")
            locationimageView.contentMode = .scaleAspectFit
            
            let locationRightView = UIView(frame: CGRect(
                                            x: 0, y: 0, // keep this as 0, 0
                                            width: 30, // add the padding
                                            height: 20))
            locationRightView.addSubview(locationimageView)
            
            locationTextfield.rightViewMode = UITextField.ViewMode.always
            locationTextfield.rightView = locationRightView
            
            
            let imageView1 = UIImageView()
            imageView1.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            imageView1.image = image
            imageView1.contentMode = .scaleAspectFit
            
            // create the view that would act as the padding
            let rightView1 = UIView(frame: CGRect(
                                    x: 0, y: 0, // keep this as 0, 0
                                    width: 30, // add the padding
                                    height: 20))
            rightView1.addSubview(imageView1)
            
            endDateTextfield.rightView = rightView1
            
        }
        
        
        
        let descriptionview = UIView()
        descriptionview.backgroundColor = .white
        
        //        descriptionview.font = UIFont.systemFont(ofSize: 12)
        scrollView.addSubview(descriptionview)
        
        
        descriptionview.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contractNametextField)
            make.top.equalTo(locationTextfield.snp.bottom).offset(15)
            make.height.equalTo(180)
        }
        
        descriptionview.layer.cornerRadius = 10.0
        descriptionview.layer.borderWidth = 0.5
        descriptionview.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("Description", comment: "")
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        descriptionview.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionview).offset(05)
            make.leading.trailing.equalTo(descriptionview).inset(10)
        }
        
        descriptionTextview.delegate = self
        descriptionTextview.textColor = UIColor.lightGray
        descriptionTextview.text = NSLocalizedString("Enter Description", comment: "")
        descriptionTextview.font = UIFont.systemFont(ofSize: 12.0)
        descriptionview.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.trailing.equalTo(descriptionview).inset(05)
            make.height.equalTo(140)
        }
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            locationTextfield.textAlignment = .right
            locationTextfield.titleLabel.textAlignment = .right
        }else{
            locationTextfield.textAlignment = .left
            locationTextfield.titleLabel.textAlignment = .left
        }
            
        
    }
    
    //MARK: textfield actions
    
    @objc func locationAction(){
        let vc = LocationPickerController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc func startDateAction(){
        
        
        let datePicker = DatePickerDialog()
        
        let currentDate = Date()
        var dateComponents1 = DateComponents()
        dateComponents1.month = 12
        let twelveMonthsAfter = Calendar.current.date(byAdding: dateComponents1, to: currentDate)
        datePicker.show("",
                        doneButtonTitle: NSLocalizedString("Done", comment: ""),
                        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                        minimumDate: Date(),
                        maximumDate: twelveMonthsAfter,
                        datePickerMode: .date) { (date) in
            
            if date != nil{

                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                self.startDateTextfield.text = formatter.string(from: date!)
                self.startdateToValidate = date!

                
            }
        }
        
    }
    @objc func endDateAction(){
        
        
        let datePicker = DatePickerDialog()
        
        let currentDate = Date()
        var dateComponents1 = DateComponents()
        dateComponents1.month = 12
        let twelveMonthsAfter = Calendar.current.date(byAdding: dateComponents1, to: currentDate)
        datePicker.show("",
                        doneButtonTitle: NSLocalizedString("Done", comment: ""),
                        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                        minimumDate: startdateToValidate,
                        maximumDate: twelveMonthsAfter,
                        datePickerMode: .date) { (date) in
            
            if date != nil{
                
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                self.endDateTextfield.text = formatter.string(from: date!)
                
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true
        
    }
    
    @objc func contractButtonAction(_ sender: UIButton){
        
        let emptyCircleImage = UIImage(named: "create_new")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        let filledCircleImage = UIImage(named: "select")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        
        
        contractNametextField.isUserInteractionEnabled     = !contractNametextField.isUserInteractionEnabled
        contractNumbertextField.isUserInteractionEnabled   = !contractNumbertextField.isUserInteractionEnabled
        descriptionTextview.isUserInteractionEnabled       = !descriptionTextview.isUserInteractionEnabled
        
        if sender.tag == 0{
            createNewButton.setImage(filledCircleImage, for: .normal)
            savedContractButton.setImage(emptyCircleImage, for: .normal)
            
            contractNametextField.text     = ""
            contractNumbertextField.text   = ""
            descriptionTextview.text       = ""
        }
        else{
            createNewButton.setImage(emptyCircleImage, for: .normal)
            savedContractButton.setImage(filledCircleImage, for: .normal)
            
            let vc = MyContractsViewController()
            vc.delegate = self
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    @objc func createButtonAction(){
        
        if contractNametextField.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid contract name to proceed", comment: ""))
        }
        else if contractNumbertextField.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid contract number to proceed", comment: ""))
        }
        else if startDateTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid start date to proceed", comment: ""))
        }
        else if endDateTextfield.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid end date to proceed", comment: ""))
        }
        else if latitude == nil || longitude == nil{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid location to proceed", comment: ""))
        }
        else{
            hireResourceApiRequest()
        }
        
    }
    
    
    func hireResourceApiRequest(){
        // Modifying available slots to append in params
        var slots = Array<[String:String]>()
        for val in CreateContract.shared.dateRangeArray{
            slots.append(["start_at":val[0],"end_at":val[1]])
        }
        
        // Modifying Milestones to  append in params
        var mileStones = Array<[String:String]>()
        for val in milestonesArray{
            
            let mileStone = val as! [String:String]
            mileStones.append(["title":mileStone["Name"] ?? "",
                               "amount":mileStone["Amount"] ?? "",
                               "description":mileStone["Desc"] ?? "",
                               "date":mileStone["Date"] ?? ""])
        }
        
        let parameters: [String: Any] = [
            
            "current_version"      : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale"               : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id"            : UIDevice.current.identifierForVendor!.uuidString,
            "device_type"          : "ios",
            "provider_id"          : CreateContract.shared.provider_id ?? 0,
            "provider_profile_id"  : CreateContract.shared.provider_profile_id ?? 0,
            "project_id"           : CreateContract.shared.project_id ?? 0,
            "total_amount"         : CreateContract.shared.totalAmount ?? 0,
            "contract_number"      : contractNumbertextField.text ?? "",
            "contract_name"        : contractNametextField.text ?? "",
            "contract_description" : descriptionTextview.text ?? "",
            "contract_start_at"    : startDateTextfield.text ?? "",
            "contract_end_at"      : endDateTextfield.text ?? "",
            "add_signature"        : addSignature ? "Yes":"No",
            "location"             : locationTextfield.text ?? "",
            "latitude"             : String(latitude),
            "longitude"            : String(longitude),
            "slots"                : slots,
            "milestones"           : mileStones
            
        ]
        
        WebServices.postRequest(url: Url.hireResource, params: parameters, viewController: self) { success,data  in
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(HireResource.self, from: data)
                
                DispatchQueue.main.async {
                
                    let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let vc : ResponseViewController = storyboard.instantiateViewController(withIdentifier: "ResponseViewController") as! ResponseViewController
                    if let number = response.data?.contracts?.contract_number{
                        vc.requestNo = "\(number)"
                    }
                    vc.isSuccess = true
                    if let error = response.errors?.error?.first{
                        print("response")
                        vc.errorMessage = error
                        vc.isSuccess = false
                    }
                    
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
                print("response")
            }catch let error {
                print("error \(error.localizedDescription)")
            }
            
        }
        
    }
    
    
//    @objc func addSignatureAction(){
//        addSignature = !addSignature
//
//        if addSignature{
//            let tickImage = UIImage(named: "tick")?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
//            tickButton.setImage(tickImage, for: .normal)
//        }else{
//            let tickImage = UIImage(named: "untick")?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
//            tickButton.setImage(tickImage, for: .normal)
//        }
//    }
    
    
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


extension CreateContractViewController : UITableViewDelegate,UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = .clear
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width-20, height: 25))
        label.text = NSLocalizedString("Selected Dates", comment: "")
        label.font = UIFont.boldSystemFont(ofSize: 14.0)
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CreateContract.shared.dateRangeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DateRangeTVCell
        
        cell.selectionStyle = .none
        
        let startDate = CreateContract.shared.dateRangeArray[indexPath.row][0]
        let endDate = CreateContract.shared.dateRangeArray[indexPath.row][1]
        cell.rangeLabel.text = "\(startDate) - \(endDate)"
        
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(self.deleteAction), for: .touchUpInside)
        

        let formatter = DateFormatter()
        let calendar = Calendar.current
        formatter.dateFormat = "yyyy-MM-dd"
        let formatedStartDate = formatter.date(from: startDate)
        let formattedEndDate = formatter.date(from: endDate)
        let diff = calendar.dateComponents([.day], from: formatedStartDate!, to: formattedEndDate!)
        
        if let dateDiff = diff.day{
            if dateDiff == 0{
                totalDays += 1
                cell.daysLabel.text = "\(1) \(NSLocalizedString("Day", comment: ""))"
            }else{
                totalDays += dateDiff
                cell.daysLabel.text = "\(dateDiff) \(NSLocalizedString("Days", comment: ""))"
            }
        }
                
        
        if indexPath.row == datesCount{
            cell.lineView.isHidden = true
        }
        
        if datesCount == 1{
            cell.deleteButton.isHidden = true
        }
        
        return cell
    }
    
    @objc func deleteAction(_ sender: UIButton){
        
        datesCount -= 1
        CreateContract.shared.dateRangeArray.remove(at: sender.tag)
        datesTableView.reloadData()
        
        datesTableView.snp.remakeConstraints { (make) in
            make.leading.trailing.top.equalTo(self.view)
            make.height.equalTo((datesCount*40)+20) // 60 is for header ,40 for row, datescount is number of rows
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: CGFloat((datesCount*40)+550))

    }
    
}

class DateRangeTVCell: UITableViewCell {
    
    var rangeLabel : UILabel!
    var daysLabel : UILabel!
    var deleteButton : UIButton!
    var lineView : UIView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        
        rangeLabel = UILabel()
        //        rangeLabel.text = "20 jan, 2020 to 24 jan, 2020"
        rangeLabel.textColor = Color.liteBlack
        rangeLabel.font = UIFont(name: "AvenirLTStd-Book", size: 14)
        self.contentView.addSubview(rangeLabel)
        
        rangeLabel.snp.makeConstraints { (make) in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
        }
        
        
        deleteButton = UIButton()
        deleteButton.setTitle("X", for: .normal)
        deleteButton.setTitleColor(Color.red, for: .normal)
        deleteButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 16.0)
        self.contentView.addSubview(deleteButton)
        
        deleteButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().offset(-5)
            make.width.height.equalTo(50)
        }
        
        
        daysLabel = UILabel()
        daysLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        self.contentView.addSubview(daysLabel)
        daysLabel.snp.makeConstraints { (make) in
            make.trailing.equalTo(deleteButton.snp.leading).offset(-10)
            make.centerY.equalTo(deleteButton)
        }
        daysLabel.numberOfLines = 0
        daysLabel.sizeToFit()
        
        
        lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class SkyFloatingTextfield: SkyFloatingLabelTextField {
    
    public var leftPadding = CGFloat(30)
    public var rightPadding = CGFloat(60)
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        
        let rect = CGRect(
            x: leftPadding,
            y: titleHeight(),
            width: bounds.size.width - rightPadding,
            height: bounds.size.height - titleHeight() - selectedLineHeight
        )
        
        return rect
        
    }
    
    override func titleLabelRectForBounds(_ bounds: CGRect, editing: Bool) -> CGRect {
        
        if editing {
            return CGRect(x: leftPadding, y: 5, width: bounds.size.width - rightPadding, height: titleHeight())
        }
        
        return CGRect(x: leftPadding, y: titleHeight(), width: bounds.size.width - rightPadding, height: titleHeight())
    }
    
}


class FloatingTextfield: SkyFloatingTextfield{
    
    public var leftMargin : CGFloat!
    public var rightMargin : CGFloat!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.autocapitalizationType = .none
        self.titleFont = UIFont.systemFont(ofSize: 10.0)
        self.font = UIFont.boldSystemFont(ofSize: 14)
        self.backgroundColor = .white
        self.selectedTitleColor = UIColor.lightGray
        self.titleColor = UIColor.lightGray
        self.textColor = UIColor.black
        self.lineHeight = 0
        self.selectedLineHeight = 0
        self.titleFormatter = { $0 }
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.borderWidth = 0.5
        self.layer.cornerRadius = 10.0
        
        if leftMargin != nil{
            self.leftPadding = leftMargin
        }
        if leftMargin != nil{
            self.rightPadding = rightMargin
        }
//        self.leftPadding
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension CreateContractViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Enter Description", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
}


protocol LocationDelegate {
    func newLocation(address : String, latitude : Double , longitude : Double)
}

extension CreateContractViewController : LocationDelegate{
    
    func newLocation(address : String, latitude : Double , longitude : Double)
    {
        self.locationTextfield.text = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
}

protocol ContractDelegate {
    func savedContract(contract : Contract)
    func noContractSelected()
}

extension CreateContractViewController : ContractDelegate{
    func savedContract(contract: Contract) {
        
        if let name = contract.contract_name{
            contractNametextField.text = name
        }
        if let number = contract.contract_number{
            contractNumbertextField.text = number
        }
        if let desc = contract.contract_description{
            descriptionTextview.text = desc
            descriptionTextview.textColor = .black
        }
        
    }
    func noContractSelected(){
        
        let button = UIButton()
        button.tag = 0
        contractButtonAction(button)
        
    }
}
