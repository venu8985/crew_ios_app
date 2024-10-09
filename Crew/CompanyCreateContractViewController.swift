//
//  CompanyCreateContractViewController.swift
//  Crew
//
//  Created by Rajeev on 14/04/21.
//

import UIKit
import DatePickerDialog

class CompanyCreateContractViewController: UIViewController {

    var agencyId : Int!
    
    var createNewButton : UIButton!
    var savedContractButton : UIButton!
    var contractNumbertextField : FloatingTextfield!
    var startDateTextfield : FloatingTextfield!
    var contractNametextField : FloatingTextfield!
    var endDateTextfield : FloatingTextfield!
    var locationTextfield : FloatingTextfield!
    var descriptionTextview : UITextView!
    var addSignatureButton : UIButton!
    
    var latitude : Double!
    var longitude : Double!
    
    var addSignature = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white
        self.title = NSLocalizedString("Create contract", comment: "")
        self.navigationBarItems()
        
        //MARK: BottomView UI
        let createButton = UIButton()
        createButton.setTitle(NSLocalizedString("Create contract", comment: ""), for: .normal)
        createButton.backgroundColor = Color.red
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13.0)
        createButton.addTarget(self, action: #selector(self.createButtonAction), for: .touchUpInside)
        self.view.addSubview(createButton)
        
        createButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        createButton.layer.cornerRadius = 5.0
        createButton.clipsToBounds = true

        
        
        let lineView = UIView()
        lineView.backgroundColor = UIColor.lightGray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(createButton.snp.top).offset(-10)
            make.height.equalTo(1)
        }
        
        
        
        
        //MARK: contract UI
        

        let emptyCircleImage = UIImage(named: "select")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        createNewButton = UIButton()
        createNewButton.setTitle(NSLocalizedString(" Create New", comment: ""), for: .normal)
        createNewButton.setImage(emptyCircleImage, for: .normal)
        createNewButton.setTitleColor(.black, for: .normal)
        createNewButton.tag = 0
        createNewButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        createNewButton.addTarget(self, action: #selector(self.contractButtonAction), for: .touchUpInside)
        self.view.addSubview(createNewButton)
        
        createNewButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(self.view).offset(20)
        }
        
        
        let filledCircleImage = UIImage(named: "create_new")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        savedContractButton = UIButton()
        savedContractButton.setTitle(NSLocalizedString(" From my saved contracts", comment: ""), for: .normal)
        savedContractButton.setImage(filledCircleImage, for: .normal)
        savedContractButton.setTitleColor(.black, for: .normal)
        savedContractButton.tag = 1
        savedContractButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        savedContractButton.addTarget(self, action: #selector(self.contractButtonAction), for: .touchUpInside)
        self.view.addSubview(savedContractButton)
        
        savedContractButton.snp.makeConstraints { (make) in
            make.leading.equalTo(createNewButton.snp.trailing).offset(20)
            make.top.equalTo(createNewButton)
        }
        

        
        contractNumbertextField = FloatingTextfield()
        contractNumbertextField.leftPadding = 10
        contractNumbertextField.rightPadding = 20
        contractNumbertextField.placeholder = NSLocalizedString("Contract Number", comment: "")
        self.view.addSubview(contractNumbertextField)
        
        contractNumbertextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(10)
            make.top.equalTo(createNewButton.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
        
        
        contractNametextField = FloatingTextfield()
        contractNametextField.leftPadding = 10
        contractNametextField.rightPadding = 20
        contractNametextField.placeholder = NSLocalizedString("Contract Name", comment: "")
        self.view.addSubview(contractNametextField)
        
        contractNametextField.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contractNumbertextField)
            make.top.equalTo(contractNumbertextField.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
        
        startDateTextfield = FloatingTextfield()
        startDateTextfield.leftPadding = 10
        startDateTextfield.rightPadding = 20
        startDateTextfield.placeholder = NSLocalizedString("Start Date", comment: "")
        self.view.addSubview(startDateTextfield)
        
        let imageView = UIImageView()
        let image = UIImage(named: "calendar")
        imageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        // create the view that would act as the padding
        let rightView = UIView(frame: CGRect(
                                x: 0, y: 0, // keep this as 0, 0
                                width: 30, // add the padding
                                height: 20))
        rightView.addSubview(imageView)
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            startDateTextfield.leftView = rightView
            startDateTextfield.leftViewMode = UITextField.ViewMode.always
        }else{
            startDateTextfield.rightViewMode = UITextField.ViewMode.always
            startDateTextfield.rightView = rightView
        }
        
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
        self.view.addSubview(endDateTextfield)
        
        endDateTextfield.snp.makeConstraints { (make) in
            make.trailing.equalTo(contractNametextField)
            make.top.equalTo(contractNametextField.snp.bottom).offset(15)
            make.width.equalTo((self.view.frame.size.width-65)/2)
            make.height.equalTo(45)
        }
        
//        endDateTextfield.rightViewMode = UITextField.ViewMode.always
        
        endDateTextfield.inputView = UIView()
        endDateTextfield.isUserInteractionEnabled = true
        endDateTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(endDateAction)))
        
        
        let calimageView = UIImageView()
        calimageView.frame = CGRect(x: 5, y: 0, width: 20, height: 20)
        calimageView.image = image
        calimageView.contentMode = .scaleAspectFit
        
        // create the view that would act as the padding
        let calRightView = UIView(frame: CGRect(
                                    x: 0, y: 0, // keep this as 0, 0
                                    width: 30, // add the padding
                                    height: 20))
        calRightView.addSubview(calimageView)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            endDateTextfield.leftView = calRightView
            endDateTextfield.leftViewMode = UITextField.ViewMode.always
        }else{
            endDateTextfield.rightViewMode = UITextField.ViewMode.always
            endDateTextfield.rightView = calRightView
        }
        
        
        
        locationTextfield = FloatingTextfield()
        locationTextfield.leftPadding = 10
        locationTextfield.rightPadding = 20
        locationTextfield.placeholder = NSLocalizedString("Location", comment: "")
        self.view.addSubview(locationTextfield)
        locationTextfield.inputView = UIView()
        locationTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contractNametextField)
            make.top.equalTo(startDateTextfield.snp.bottom).offset(15)
            make.height.equalTo(45)
        }
        
    
        
        
        let locationimageView = UIImageView()
        locationimageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        locationimageView.image = UIImage(named: "gps1")
        locationimageView.contentMode = .scaleAspectFit
        
        let locationRightView = UIView(frame: CGRect(
                                        x: 0, y: 0, // keep this as 0, 0
                                        width: 30, // add the padding
                                        height: 20))
        locationRightView.addSubview(locationimageView)
        
        
        locationTextfield.isUserInteractionEnabled = true
        locationimageView.isUserInteractionEnabled = true
        locationTextfield.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(locationAction)))
        locationimageView.addGestureRecognizer(UITapGestureRecognizer(target:self, action: #selector(locationAction)))
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            locationTextfield.leftViewMode = UITextField.ViewMode.always
            locationTextfield.leftView = locationRightView
        }else{
            locationTextfield.rightViewMode = UITextField.ViewMode.always
            locationTextfield.rightView = locationRightView
        }
        
        
        
        let descriptionview = UIView()
        descriptionview.backgroundColor = .white
        self.view.addSubview(descriptionview)
        
        
        descriptionview.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(contractNametextField)
            make.top.equalTo(locationTextfield.snp.bottom).offset(15)
            make.height.equalTo(180)
        }
        
        descriptionview.layer.cornerRadius = 10.0
        descriptionview.layer.borderWidth = 0.5
        descriptionview.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let descriptionLabel = UILabel()
        descriptionLabel.text = NSLocalizedString("  \(NSLocalizedString("Description", comment: ""))", comment: "")
        descriptionLabel.font = UIFont.boldSystemFont(ofSize: 14.0)
        descriptionview.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionview).offset(05)
            make.leading.trailing.equalTo(descriptionview)
        }
        
        descriptionTextview = UITextView()
        descriptionTextview.delegate = self
        descriptionTextview.textColor = UIColor.lightGray
        descriptionTextview.text = NSLocalizedString("Enter Description", comment: "")
        descriptionTextview.font = UIFont.systemFont(ofSize: 12.0)
        descriptionview.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom)
            make.leading.trailing.equalTo(descriptionview)
            make.height.equalTo(140)
        }
        
        
        let tick = UIImage(named: "tick")
            //?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        addSignatureButton = UIButton()
        addSignatureButton.setTitle(NSLocalizedString("  Add my signature", comment: ""), for: .normal)
        addSignatureButton.setImage(tick, for: .normal)
        addSignatureButton.setTitleColor(Color.red, for: .normal)
        addSignatureButton.tag = 0
        addSignatureButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
//        addSignatureButton.addTarget(self, action: #selector(self.addSignatureButtonAction), for: .touchUpInside)
        self.view.addSubview(addSignatureButton)
        
        addSignatureButton.snp.makeConstraints { (make) in
            make.leading.equalTo(self.view).offset(10)
            make.top.equalTo(descriptionTextview.snp.bottom).offset(30)
        }
        
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
           
            contractNametextField.textAlignment = .right
            contractNametextField.titleLabel.textAlignment = .right
            
            contractNumbertextField.textAlignment = .right
            contractNumbertextField.titleLabel.textAlignment = .right
            
            startDateTextfield.textAlignment = .right
            startDateTextfield.titleLabel.textAlignment = .right
            
            endDateTextfield.textAlignment = .right
            endDateTextfield.titleLabel.textAlignment = .right
            
            locationTextfield.textAlignment = .right
            locationTextfield.titleLabel.textAlignment = .right
            
            descriptionTextview.textAlignment = .right
        }else{
            
            
             contractNametextField.textAlignment = .left
             contractNametextField.titleLabel.textAlignment = .left
             
             contractNumbertextField.textAlignment = .left
             contractNumbertextField.titleLabel.textAlignment = .left
             
             startDateTextfield.textAlignment = .left
             startDateTextfield.titleLabel.textAlignment = .left
             
             endDateTextfield.textAlignment = .left
             endDateTextfield.titleLabel.textAlignment = .left
        }
        
    }
    @objc func contractButtonAction(_ sender: UIButton){
        
        let emptyCircleImage = UIImage(named: "create_new")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        let filledCircleImage = UIImage(named: "select")
            //?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        
        
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
    
    @objc func addSignatureButtonAction(){
        
        addSignature = !addSignature
        if addSignature{
            let tick = UIImage(named: "tick")//?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
            addSignatureButton.setImage(tick, for: .normal)
        }else{
            let tick = UIImage(named: "untick")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
            addSignatureButton.setImage(tick, for: .normal)
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
                        minimumDate: Date(),
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
    
    @objc func createButtonAction(){
        
        
        if contractNumbertextField.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid contract number to proceed", comment: ""))
        }
        else if contractNametextField.text == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select valid contract name to proceed", comment: ""))
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
            createContract()
        }
        
    }
    func createContract(){
        
        
        let parameters: [String: Any] = [
            "hire_agency_id"       : agencyId ?? "",
            "current_version"      : Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "",
            "locale"               : UserDefaults.standard.value(forKey: "Language") as? String ?? "",
            "device_id"            : UIDevice.current.identifierForVendor!.uuidString,
            "device_type"          : "ios",
            "contract_number"      : contractNumbertextField.text ?? "",
            "contract_name"        : contractNametextField.text ?? "",
            "contract_description" : descriptionTextview.text ?? "",
            "contract_start_at"    : startDateTextfield.text ?? "",
            "contract_end_at"      : endDateTextfield.text ?? "",
            "add_signature"        : addSignature ? "Yes":"No",
            "location"             : locationTextfield.text ?? "",
            "latitude"             : String(latitude),
            "longitude"            : String(longitude)
        ]
        
        WebServices.postRequest(url: Url.createContract, params: parameters, viewController: self) { success,data  in
            
            if success{
                Banner().displaySuccess(string: NSLocalizedString("Contract succesfully created.", comment: ""))
                if let nav = self.navigationController {
                    nav.popToViewController(nav.viewControllers[nav.viewControllers.count - 3], animated: true)
                }
            }else{
                Banner().displayValidationError(string: "Error")
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

extension CompanyCreateContractViewController : UITextViewDelegate{
    
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


extension CompanyCreateContractViewController : ContractDelegate{
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
        let emptyCircleImage = UIImage(named: "create_new")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        let filledCircleImage = UIImage(named: "select")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        
        
        contractNametextField.isUserInteractionEnabled     = !contractNametextField.isUserInteractionEnabled
        contractNumbertextField.isUserInteractionEnabled   = !contractNumbertextField.isUserInteractionEnabled
        descriptionTextview.isUserInteractionEnabled       = !descriptionTextview.isUserInteractionEnabled
        
        createNewButton.setImage(filledCircleImage, for: .normal)
        savedContractButton.setImage(emptyCircleImage, for: .normal)
        
    }
}

extension CompanyCreateContractViewController : LocationDelegate{
    
    func newLocation(address : String, latitude : Double , longitude : Double)
    {
        self.locationTextfield.text = address
        self.latitude = latitude
        self.longitude = longitude
    }
    
}
