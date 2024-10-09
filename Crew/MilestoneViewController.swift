//
//  MilestoneViewController.swift
//  Crew
//
//  Created by Rajeev on 12/03/21.
//

import UIKit
import SnapKit
import SkyFloatingLabelTextField

class MilestoneViewController: UIViewController, UITextFieldDelegate {

    var amountTextfield : UITextField!
    var milestonesArray = NSMutableArray()
    var tableview : UITableView!
    var isEdit = false
    
    var editIndex        : Int!
    var totalAmount      : Int!
    var remainingAmount  : Int!
    
    var addButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .lightGray
        
        var backImage : UIImage!
        let backButton = UIButton()
        backButton.tintColor = UIColor.black
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            backButton.frame = CGRect(x: self.view.frame.size.width-54, y: 30, width: 44, height: 44)
            backImage = UIImage(named: "back-R")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        }else{
            backButton.frame = CGRect(x: 0, y: 30, width: 44, height: 44)
            backImage = UIImage(named: "back")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        }
        backButton.setImage(backImage, for: .normal)
        backButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        self.view.addSubview(backButton)
        
        let titleLabel = UILabel()
        titleLabel.text = NSLocalizedString("Create Milestones", comment: "")
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textAlignment = .center
        self.view.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview().inset(120)
            make.centerY.equalTo(backButton)
        }
        
        
        let addImage = UIImage(named: "add")//?.sd_resizedImage(with: CGSize(width: 18, height: 18), scaleMode: .aspectFit)
        addButton = UIButton()
        addButton.setTitle(NSLocalizedString(" Add ", comment: ""), for: .normal)
        addButton.setTitleColor(Color.red, for: .normal)
        addButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 14)
        addButton.setImage(addImage, for: .normal)
        addButton.addTarget(self, action: #selector(self.addAction), for: .touchUpInside)
        addButton.addTarget(self, action:#selector(self.popVC), for: .touchUpInside)
        self.view.addSubview(addButton)
        
        addButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(self.view).inset(10)
            make.centerY.equalTo(backButton)
            
        }
        
        addButton.isUserInteractionEnabled = false
        addButton.alpha = 0.5
        
        amountTextfield = UITextField()
        amountTextfield.placeholder = NSLocalizedString("Total amount ", comment: "")
//        amountTextfield.placeholder = "SAR 100000"
        amountTextfield.delegate = self
        amountTextfield.keyboardType = .numberPad
        amountTextfield.backgroundColor = .white
        self.view.addSubview(amountTextfield)
        amountTextfield.leftViewMode = UITextField.ViewMode.always

        amountTextfield.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view).inset(30)
            make.top.equalTo(backButton.snp.bottom).offset(10)
            make.height.equalTo(45)
        }
        amountTextfield.iq.toolbar.doneBarButton.setTarget(self, action: #selector(doneButtonAction))

        let amountImage = UIImage(named: "amount")//?.sd_resizedImage(with: CGSize(width: 25, height: 25), scaleMode: .aspectFit)
        let imageView = UIImageView();
        imageView.frame = CGRect(x: 05, y: 10, width: 25, height: 25)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        let image = amountImage
        imageView.image = image;
        
        // Adding imageview on left
        amountTextfield.leftView = UIView(frame: CGRect(x: 05, y: 0, width: 40, height: amountTextfield.frame.height))
        amountTextfield.addSubview(imageView)
        amountTextfield.leftView?.backgroundColor = .cyan
        amountTextfield.leftViewMode = .always
        amountTextfield.layer.cornerRadius = 10.0
        amountTextfield.clipsToBounds = true
        
//        let amountImage = UIImage(named: "amount")?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
//        let amountImageView = UIImageView()
//        amountImageView.backgroundColor = .clear
//        amountImageView.frame = CGRect(x: 0, y: 0, width: 30, height: 20)
//        amountImageView.image = amountImage
//        amountImageView.contentMode = .scaleAspectFit
//
//        let amounleftView = UIView(frame: CGRect(
//            x: 0, y: 0, // keep this as 0, 0
//            width: 30, // add the padding
//            height: 20))
//        amounleftView.addSubview(amountImageView)
//        amountTextfield.leftView = amounleftView
        
        amountTextfield.becomeFirstResponder()
        
        
        let submitButton = UIButton()
        submitButton.setTitle(NSLocalizedString("Create contract", comment: ""), for: .normal)
        submitButton.backgroundColor = Color.red
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        submitButton.addTarget(self, action: #selector(self.createContractAction), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        submitButton.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        
        
    
        tableview = UITableView()
        tableview.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        self.view.addSubview(tableview)
        tableview.register(MileStoneTVCell.self, forCellReuseIdentifier: "cell")
        
        tableview.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(amountTextfield.snp.bottom).offset(20)
            make.bottom.equalTo(submitButton.snp.top).offset(-10)
        }
                
    }
    
    @objc func doneButtonAction(){
        if amountTextfield.text!.count>1{
            amountTextfield.isUserInteractionEnabled = false
            amountTextfield.resignFirstResponder()
            CreateContract.shared.totalAmount = Int(amountTextfield.text ?? "0")
            totalAmount = Int(amountTextfield.text ?? "0")
            amountTextfield.text = "SAR \(amountTextfield.text ?? "")"
            
            addButton.isUserInteractionEnabled = true
            addButton.alpha = 1.0
            
        }else{
            Banner().displayValidationError(string: NSLocalizedString("Enter valid amount", comment: ""))
            amountTextfield.becomeFirstResponder()
        }
     }
    
    @objc func addAction(){
        
        var createdAmount = 0
        
        for i in milestonesArray{
            let mileStone = i as! [String:String]
            if let mileAmount = mileStone["Amount"] {
                createdAmount = createdAmount + (Int(mileAmount) ?? 0)
            }
        }
        
        
        let vc = MilestonePopupVC()
        vc.delegate = self
        vc.totalAmount = totalAmount
        vc.createdAmount = createdAmount
        vc.modalPresentationStyle = .custom
        vc.titleStr = "   \(NSLocalizedString("Create new milestone", comment: ""))"
        self.present(vc, animated: true, completion: nil)
        
    }
    
    @objc func createContractAction(){
        
        if milestonesArray.count == 0{
            Banner().displayValidationError(string: NSLocalizedString("Please create atleast 1 milestone", comment: ""))
            return
        }
        
        //Saving dates in shared class for create contract
        let vc = CreateContractViewController()
        vc.milestonesArray = self.milestonesArray
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        self.navigationController?.navigationBar.isHidden = false

    }

    
    @objc func popVC(){
        self.navigationController?.popViewController(animated: true)
    }
    

    
}

extension MilestoneViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 255
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return milestonesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MileStoneTVCell
        cell.selectionStyle = .none
        
        let mileStone = milestonesArray[indexPath.row] as! [String:String]
        cell.nameTextfield.text = mileStone["Name"]
        cell.amountTextfield.text = mileStone["Amount"]
        cell.descriptionTextview.text = mileStone["Desc"]
        cell.dateButton.setTitle(" \(mileStone["Date"] ?? "") ", for: .normal)
        
        
        cell.removeButton.tag = indexPath.row
        cell.removeButton.addTarget(self, action: #selector(self.removeAction), for: .touchUpInside)
        
        
        cell.editButton.tag = indexPath.row
        cell.editButton.addTarget(self, action: #selector(self.editAction), for: .touchUpInside)
        
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            cell.nameTextfield.textAlignment = .right
            cell.amountTextfield.textAlignment = .right
            cell.descriptionTextview.textAlignment = .right
        }else{
            cell.nameTextfield.textAlignment = .left
            cell.amountTextfield.textAlignment = .left
            cell.descriptionTextview.textAlignment = .left
        }
        
        return cell
        
    }
    
    @objc func removeAction(sender : UIButton){
        
        milestonesArray.removeObject(at: sender.tag)
        tableview.reloadData()
    }
    
    @objc func editAction(sender : UIButton){
        isEdit = true
        editIndex = sender.tag
        let vc = MilestonePopupVC()
        vc.delegate = self
        vc.totalAmount = totalAmount
        vc.details = milestonesArray[sender.tag] as? [String:String]
        vc.modalPresentationStyle = .custom
        vc.titleStr = "   \(NSLocalizedString("Edit new milestone", comment: ""))"
        self.present(vc, animated: true, completion: nil)

    }
    
}


class MileStoneTVCell : UITableViewCell {
    
    var bgView              : UIView!
    var dotView             : UIView!
    var lineView            : UIView!
    var addImageView        : UIImageView!
    var milestoneLabel      : UILabel!
    
    var nameTextfield       : UITextField!
    var amountTextfield     : UITextField!
    var descriptionTextview : UITextView!
    var dateButton          : UIButton!
    var removeButton        : UIButton!
    var editButton          : UIButton!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        bgView = UIView()
        self.contentView.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.height.equalTo(220)
            make.leading.equalTo(self.contentView).offset(35)
            make.trailing.equalTo(self.contentView).offset(-10)
            make.top.equalTo(self.contentView).offset(05)
        }
        bgView.layer.borderWidth = 0.5
        bgView.layer.borderColor = UIColor.lightGray.cgColor
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true

        
        editButton = UIButton()
        editButton.setTitleColor(Color.red, for: .normal)
        editButton.setTitle(NSLocalizedString(" \(NSLocalizedString("Edit", comment: "")) ", comment: ""), for: .normal)
        editButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        self.contentView.addSubview(editButton)
        
        editButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView).offset(-10)
            make.top.equalTo(bgView).offset(05)
            make.width.equalTo(44)
        }
        
        
        nameTextfield = UITextField()
        nameTextfield.isUserInteractionEnabled = false
        nameTextfield.placeholder = NSLocalizedString("Milestone Name", comment: "")
        bgView.addSubview(nameTextfield)
        
        nameTextfield.snp.makeConstraints { (make) in
            make.top.leading.equalTo(bgView)
            make.trailing.equalTo(editButton.snp.leading).offset(-10)
            make.height.equalTo(40)
        }
        
        nameTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        nameTextfield.leftViewMode = .always
        nameTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        nameTextfield.rightViewMode = .always
        
        

        
        let nameLineView = UIView()
        nameLineView.backgroundColor = .lightGray
        bgView.addSubview(nameLineView)

        nameLineView.snp.makeConstraints { (make) in
            make.top.equalTo(nameTextfield.snp.bottom).offset(2)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(0.5)
        }

        
        amountTextfield = UITextField()
        amountTextfield.isUserInteractionEnabled = false
        amountTextfield.placeholder = NSLocalizedString("Enter Amount", comment: "")
        bgView.addSubview(amountTextfield)
        
        amountTextfield.snp.makeConstraints { (make) in
            make.top.equalTo(nameLineView.snp.bottom)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(40)
        }
        
        amountTextfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        amountTextfield.leftViewMode = .always
        amountTextfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: nameTextfield.frame.height))
        amountTextfield.rightViewMode = .always
        
        let amountLineView = UIView()
        amountLineView.backgroundColor = .lightGray
        bgView.addSubview(amountLineView)

        amountLineView.snp.makeConstraints { (make) in
            make.top.equalTo(amountTextfield.snp.bottom).offset(2)
            make.leading.trailing.equalTo(amountTextfield)
            make.height.equalTo(0.5)
        }
        
        
        descriptionTextview = UITextView()
        descriptionTextview.font = UIFont.systemFont(ofSize: 14.0)
        descriptionTextview.isUserInteractionEnabled = false
        descriptionTextview.text = NSLocalizedString("Enter description", comment: "")
        bgView.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(15)
            make.trailing.equalTo(bgView)
            make.top.equalTo(amountLineView.snp.bottom).offset(2)
            make.height.equalTo(75)
        }

        
        let descLineView = UIView()
        descLineView.backgroundColor = .lightGray
        bgView.addSubview(descLineView)

        descLineView.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionTextview.snp.bottom).offset(2)
            make.leading.trailing.equalTo(amountTextfield)
            make.height.equalTo(0.5)
        }
        
        dotView = UIView()
        self.contentView.addSubview(dotView)

        dotView.snp.makeConstraints { (make) in
            make.trailing.equalTo(bgView.snp.leading).offset(-15)
            make.top.equalTo(bgView)
            make.width.height.equalTo(14)
        }
        dotView.layer.cornerRadius = 7.0
        dotView.clipsToBounds = true
        dotView.layer.borderWidth = 1.0
        dotView.layer.borderColor = UIColor.lightGray.cgColor


        lineView = UIView()
        lineView.backgroundColor = .lightGray
        self.contentView.addSubview(lineView)

        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(dotView.snp.bottom).offset(2)
            make.centerX.equalTo(dotView)
            make.height.equalTo(240)
            make.width.equalTo(1)
        }
        
        let calendarIcon = UIImage(named: "calendar")
            //?.sd_resizedImage(with: CGSize(width: 15, height: 15), scaleMode: .aspectFit)
        dateButton = UIButton()
        dateButton.setImage(calendarIcon, for: .normal)
        dateButton.backgroundColor = Color.liteWhite
        dateButton.setTitleColor(Color.liteBlack, for: .normal)
        dateButton.setTitle(NSLocalizedString("  \(NSLocalizedString("Start Date", comment: ""))  ", comment: ""), for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        self.contentView.addSubview(dateButton)
        
        dateButton.snp.makeConstraints { (make) in
            make.top.leading.equalTo(descLineView).offset(10)
            make.width.equalTo(140)
            make.height.equalTo(40)
        }
        dateButton.layer.cornerRadius = 5.0
        dateButton.clipsToBounds = true
        
        
        
        removeButton = UIButton()
        removeButton.setTitleColor(Color.red, for: .normal)
        removeButton.setTitle(NSLocalizedString(" X \(NSLocalizedString(" Remove", comment: "")) ", comment: ""), for: .normal)
        removeButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        self.contentView.addSubview(removeButton)
        
        removeButton.snp.makeConstraints { (make) in
            make.trailing.equalTo(descLineView).offset(-10)
            make.centerY.equalTo(dateButton)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}




protocol MilestoneDelegate {
    func newMileStone(name : String, amount : String, desc : String, date : String)
}

extension MilestoneViewController : MilestoneDelegate{
    func newMileStone(name: String, amount: String, desc: String, date: String) {
        let dict = ["Name" : name, "Amount" : amount, "Desc" : desc, "Date" : date]
        
        if isEdit{
            
            milestonesArray.replaceObject(at: editIndex, with: dict)
            
        }else{
            milestonesArray.add(dict)

        }
        tableview.reloadData()
        
        isEdit = false
        editIndex = nil
    }
    
}
