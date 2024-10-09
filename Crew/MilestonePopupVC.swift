//
//  MilestonePopupVC.swift
//  Crew
//
//  Created by Rajeev on 31/03/21.
//

import UIKit
import SnapKit
import DatePickerDialog

class MilestonePopupVC: UIViewController {
    
    var titleStr: String!
    var name : String!
    var amount : String!
    var createdAmount : Int!
    var desc : String!
    var date : String!
    
    var totalAmount : Int!
    
    var tableView : UITableView!
    var delegate : MilestoneDelegate!
    
    var details : [String:String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        
        
        if details != nil{
            name   = details["Name"]
            amount = details["Amount"]
            desc   = details["Desc"]
            date   = details["Date"]
        }
        
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(dismissVC))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        
        
        let bgView = UIView()
        bgView.backgroundColor = .white
        self.view.addSubview(bgView)
        
        bgView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(self.view)
            make.height.equalTo(370)
        }
        
        let titleLabel = UILabel()
        titleLabel.text = titleStr
        titleLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 20)
        bgView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(5)
            make.leading.equalTo(bgView).inset(15)
            make.height.equalTo(44)
            make.trailing.equalTo(bgView).inset(50)
            
        }
        
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        bgView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.trailing.equalTo(bgView)
            make.height.equalTo(0.5)
        }
        
        
        let closeButton = UIButton()
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 25)
        closeButton.addTarget(self, action: #selector(self.dismissVC), for: .touchUpInside)
        bgView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.trailing.top.equalTo(bgView)
            make.leading.equalTo(titleLabel.snp.trailing)
            make.bottom.equalTo(titleLabel)
        }
        
        
        let createButton = UIButton()
        createButton.backgroundColor = Color.red
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        
        if details != nil{
            createButton.setTitle(NSLocalizedString("Update Milestone", comment: ""), for: .normal)
        }else{
            createButton.setTitle(NSLocalizedString("Create Milestone", comment: ""), for: .normal)
        }
        
        createButton.addTarget(self, action: #selector(self.createButtonAction), for: .touchUpInside)
        bgView.addSubview(createButton)
        
        createButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(bgView).inset(20)
            make.height.equalTo(40)
        }
        
        createButton.layer.cornerRadius = 5.0
        createButton.clipsToBounds = true
        
        tableView = UITableView()
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = .zero
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.tableFooterView = UIView()
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(createButton)
            make.bottom.equalTo(createButton.snp.top).offset(-10)
        }
        
        tableView.layer.borderWidth = 0.5
        tableView.layer.borderColor = Color.liteGray.cgColor
        tableView.layer.cornerRadius = 5.0
        
        print("totalAmount \(totalAmount ?? 0)")
        
    }
    
    @objc func dismissVC() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func createButtonAction(){
        
        print("totalAmount \(totalAmount ?? 0)")

        if name == nil{
            Banner().displayValidationError(string: NSLocalizedString("Name can not be empty", comment: ""))
        }
        else if amount == nil{
            Banner().displayValidationError(string: NSLocalizedString("Amount can not be empty", comment: ""))
        }
        else if desc == nil{
            Banner().displayValidationError(string: NSLocalizedString("Description can not be empty", comment: ""))
        }
        else if date == nil{
            Banner().displayValidationError(string: NSLocalizedString("Date can not be empty", comment: ""))
        }else {
            if let amountInt = Int(amount ?? "0"){
                if (createdAmount+amountInt)<=totalAmount{
                    delegate.newMileStone(name: name, amount: amount, desc: desc, date: date)
                    self.dismiss(animated: true, completion: nil)
                }else{
                    Banner().displayValidationError(string: NSLocalizedString("Total invidual milestones amount must be less than total milestone amount", comment: ""))
                }
            }
        }
    }
    
}


extension MilestonePopupVC : UITextViewDelegate{
    
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
    
    func textViewDidChange(_ textView: UITextView) {
        
        if textView.text.count>1{
            desc = textView.text
        }else{
            desc = nil
        }
        
    }
    
    
    
}

extension MilestonePopupVC : UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 2{
            return 70
        }else if indexPath.row == 3{
            return 70
        }else{
            return 50
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        
        cell?.selectionStyle = .none
        
        if indexPath.row == 0 || indexPath.row == 1{
            let textfield = UITextField()
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                textfield.textAlignment = .right
            }else{
                textfield.textAlignment = .left
            }
//            textfield.frame = cell!.bounds
            cell?.contentView.addSubview(textfield)
            textfield.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 05, height: textfield.frame.height))
            textfield.leftViewMode = .always
            
            
            textfield.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 05, height: textfield.frame.height))
            textfield.rightViewMode = .always
            
            textfield.snp.makeConstraints { (make) in
                make.leading.trailing.top.bottom.equalTo(cell?.contentView as! ConstraintRelatableTarget)
            }
            
            if indexPath.row == 0{
                textfield.tag = 0
                textfield.placeholder = NSLocalizedString("Milestone Name", comment: "")
                
                if details != nil{
                    textfield.text = details["Name"]
                }
                
            }
            else if indexPath.row == 1{
                textfield.tag = 1
                textfield.placeholder = NSLocalizedString("Enter Amount", comment: "")
                textfield.keyboardType = .numberPad

                if details != nil{
                    textfield.text = details["Amount"]
                }
            }
            
            textfield.addTarget(self, action: #selector(self.textfieldAction), for: .editingChanged)
            
            
            
        }else if indexPath.row == 2 {
            
            let descriptionTextview = UITextView()
            descriptionTextview.frame = cell!.bounds
            descriptionTextview.font = UIFont.systemFont(ofSize: 14.0)
            descriptionTextview.textColor = .lightGray
            descriptionTextview.delegate = self
            descriptionTextview.text = NSLocalizedString("Description", comment: "")

            cell!.contentView.addSubview(descriptionTextview)
            
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                descriptionTextview.textAlignment = .right
            }else{
                descriptionTextview.textAlignment = .left
            }
            
            if details != nil{
                descriptionTextview.text = details["Desc"]
                descriptionTextview.textColor = .black
            }
            
            
            descriptionTextview.snp.makeConstraints { (make) in
                make.leading.trailing.top.bottom.equalTo(cell?.contentView as! ConstraintRelatableTarget).inset(02)
            }
            
            
        }
        else if indexPath.row == 3{
            
            let dateButton = UIButton()
            dateButton.setImage(UIImage(named: "calendar"), for: .normal)
            dateButton.addTarget(self, action: #selector(self.dateButtonAction), for: .touchUpInside)
            dateButton.backgroundColor = Color.liteWhite
            dateButton.setTitleColor(Color.liteBlack, for: .normal)
            dateButton.setTitle(NSLocalizedString("  Start Date  ", comment: ""), for: .normal)
            dateButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
            cell!.contentView.addSubview(dateButton)
            
            dateButton.snp.makeConstraints { (make) in
                make.top.leading.equalToSuperview().inset(10)
                make.width.equalTo(140)
                make.height.equalTo(45)
            }
            dateButton.layer.cornerRadius = 5.0
            dateButton.clipsToBounds = true
            if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
                dateButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
            }
            if date != nil{
                dateButton.setTitle("  \(date ?? "")  ", for: .normal)
            }
            
            if details != nil{
                dateButton.setTitle(" \(details["Date"] ?? "")  ", for: .normal)
                dateButton.setTitleColor(.black, for: .normal)
            }
        }
        
        return cell!
        
    }
    
    @objc func textfieldAction(textField : UITextField){
        
        //name textfield
        if textField.tag == 0 {
            if textField.text!.count>0{
                name = textField.text
            }else{
                name = nil
            }
        }
        
        //Amount textfield
        else if textField.tag == 1 {
            if textField.text!.count>0{
                amount = textField.text
            }else{
                amount = nil
            }
        }
        
    }
    
    
    @objc func dateButtonAction(){
        
        
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
                self.date = formatter.string(from: date!)
                self.tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
                
            }
        }
        
    }
    
}
