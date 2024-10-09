//
//  DatesViewController.swift
//  Crew
//
//  Created by Rajeev on 09/03/21.
//

import UIKit
import FSCalendar
import SnapKit
import DatePickerDialog

class DatesViewController: UIViewController {

    var skipProjects : Bool!
    
    fileprivate weak var calendar: FSCalendar!

    let datePicker         = DatePickerDialog()
    var dateRangeArray     = [[String]]()

    var reservedDatesArray : [String]!
    var tableView          : UITableView!

    var startdateToValidate = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        dateRangeArray.append(["",""])
        
        self.navigationBarItems()
        
        // In loadView or viewDidLoad
        let calendar = FSCalendar()
        calendar.dataSource = self
        calendar.delegate = self
        calendar.backgroundColor = Color.litePink
        calendar.appearance.todayColor = nil
        calendar.appearance.titleTodayColor = calendar.appearance.titleDefaultColor
        calendar.allowsSelection = false
        calendar.placeholderType = .none
        
        calendar.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
        calendar.calendarWeekdayView.semanticContentAttribute = .forceLeftToRight
        calendar.collectionView.semanticContentAttribute = .forceLeftToRight
        
        self.view.addSubview(calendar)
        self.calendar = calendar

        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            let identifier = NSLocale(localeIdentifier: "ar_AE")
            calendar.locale = identifier as Locale
            calendar.calendarHeaderView.calendar.locale = Locale(identifier: "ar_AE")
            self.calendar.appearance.headerDateFormat = DateFormatter.dateFormat(fromTemplate: "MMMM yyyy", options: 0, locale: NSLocale(localeIdentifier: "ar_AE") as Locale)
            calendar.calendarHeaderView.collectionViewLayout.collectionView?.semanticContentAttribute = .forceLeftToRight
        }
        
        
        
        calendar.snp.makeConstraints { (make) in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        
        let chooseProject = UIButton()
        if skipProjects != nil{
            chooseProject.setTitle(NSLocalizedString("Create Milestone", comment: ""), for: .normal)
        }else{
            chooseProject.setTitle(NSLocalizedString("Choose Project", comment: ""), for: .normal)
        }

        chooseProject.backgroundColor = Color.red
        chooseProject.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        chooseProject.addTarget(self, action: #selector(self.chooseProjectAction), for: .touchUpInside)
        self.view.addSubview(chooseProject)
        
        chooseProject.snp.makeConstraints { (make) in
            make.height.equalTo(44)
            make.leading.trailing.bottom.equalTo(self.view).inset(20)
        }
        
        chooseProject.layer.cornerRadius = 5.0
        chooseProject.clipsToBounds = true
        
        
        let lineView = UIView()
        lineView.backgroundColor = Color.liteGray
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.leading.trailing.equalTo(self.view)
            make.height.equalTo(1)
            make.bottom.equalTo(chooseProject.snp.top).offset(-10)
        }
        

        let redImage = UIImage(named: "red")//?.sd_resizedImage(with: CGSize(width: 05, height: 05), scaleMode: .aspectFit)
        let reservedButton = UIButton()
        reservedButton.setImage(redImage, for: .normal)
        reservedButton.setTitle(NSLocalizedString("  Reserved", comment: ""), for: .normal)
        reservedButton.setTitleColor(UIColor.gray, for: .normal)
        reservedButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        self.view.addSubview(reservedButton)
        
        reservedButton.snp.makeConstraints { (make) in
            make.top.equalTo(self.calendar.snp.bottom).offset(10)
            make.height.equalTo(15)
            make.centerX.equalTo(self.view)
        }
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            shootingPlanButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            reservedButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        self.view.addSubview(tableView)
        tableView.register(DatesCell.self, forCellReuseIdentifier: "cell")

        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(reservedButton.snp.bottom).offset(10)
            make.bottom.equalTo(lineView.snp.top).offset(-20)
        }
        
        
//        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            calendar.transform =  CGAffineTransform(rotationAngle: .pi/4);
//            calendar.appearance.titleOffset = CGPoint.init(x: -50, y: 0.0)
//            calendar.appearance.eventOffset = CGPoint.init(x: -50, y: 0.0)
//        }
    }
    
    @objc func chooseProjectAction(){
        
        if self.dateRangeArray.last?[0] == "" ||  self.dateRangeArray.last?[1] == ""{
            Banner().displayValidationError(string: NSLocalizedString("Please select a valid date range to proceed", comment: ""))
            return
        }
        //Saving dates in shared class for create contract
        CreateContract.shared.dateRangeArray = self.dateRangeArray
        
        if skipProjects == nil{

            let vc = ProjectsListViewController()
            vc.isFromDatesVC = true
            self.navigationController?.pushViewController(vc, animated: true)
            
        }else{
            let vc = MilestoneViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.isTranslucent = true

    }
    
    func navigationBarItems() {
        
        self.title = NSLocalizedString("Select the dates", comment: "")
        
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

extension DatesViewController : FSCalendarDelegate,FSCalendarDataSource,FSCalendarDelegateAppearance{
    
    func calendar(_ calendar: FSCalendar, titleFor date: Date) -> String? {
        return (UserDefaults.standard.value(forKey: "Language") as? String == "ar")  ? self.showArabicSubTitle(date: date) : self.showEngSubTitle(date: date)
    }
    func showArabicSubTitle(date: Date!) -> String!
    {
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "dd"
        
        let calendarDate = dateFormater.string(from: date as Date)
        
        let characters = Array(calendarDate)
        
        let substituteArabic = ["0":"0", "1":"1", "2":"2", "3":"3", "4":"4", "5":"5", "6":"6", "7":"7", "8":"8", "9":"9"]
        var arabicDate =  ""
        
        for i in characters {
            if let subs = substituteArabic[String(i)] {
                arabicDate += subs
            } else {
                arabicDate += String(i)
            }
        }
        
        return arabicDate
    }
    func showEngSubTitle(date: Date!) -> String!
    {
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "en_US_POSIX")
        dateFormater.dateFormat = "dd"
        
        let calendarDate = dateFormater.string(from: date as Date)
        
        let characters = Array(calendarDate)
        
        let substituteArabic = ["0":"0", "1":"1", "2":"2", "3":"3", "4":"4", "5":"5", "6":"6", "7":"7", "8":"8", "9":"9"]
        var arabicDate =  ""
        
        for i in characters {
            if let subs = substituteArabic[String(i)] {
                arabicDate += subs
            } else {
                arabicDate += String(i)
            }
        }
        
        return arabicDate
    }
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendar.snp.updateConstraints { (make) in
            make.height.equalTo(bounds.height)
            // Do other updates
        }
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        
        if self.reservedDatesArray.contains(dateString) {
            return 1
        }
        return 1
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, eventDefaultColorsFor date: Date) -> [UIColor]? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateString = dateFormatter.string(from: date)
        
        if self.reservedDatesArray.contains(dateString) {
            return [UIColor.red]
        }
        return [UIColor.clear]
    }
    
    
}

extension DatesViewController : UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 40))
        returnedView.backgroundColor = .white
        
        let button = UIButton()
        button.frame = CGRect(x: 10, y: 7, width: view.frame.size.width-20, height: 35)
        button.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        button.setTitle(NSLocalizedString("  Add more dates", comment: ""), for: .normal)
        button.setImage(UIImage(named: "add_notes"), for: .normal)
        button.setTitleColor(Color.red, for: .normal)
        button.addTarget(self, action: #selector(self.addNewDateRow), for: .touchUpInside)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            shootingPlanButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            button.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 5)
        }
        
        returnedView.addSubview(button)
        
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.red.withAlphaComponent(0.5).cgColor
        button.layer.cornerRadius = 5.0
        button.clipsToBounds = true
        
        return returnedView
    }
    
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 45
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let returnedView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 25))
        returnedView.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: 7, width: view.frame.size.width-20, height: 25))
        label.text = NSLocalizedString("Select Dates", comment: "")
        label.font = UIFont(name: "AvenirLTStd-Heavy", size: 14.0)
        label.textColor = .black
        returnedView.addSubview(label)
        
        return returnedView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dateRangeArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DatesCell
        
        cell.selectionStyle = .none
        
        let startDate = dateRangeArray[indexPath.row][0]
        if startDate != ""{
            cell.startButton.setTitle("\(startDate)  ", for: .normal)
        }else{
            cell.startButton.setTitle(NSLocalizedString("Start Date  ", comment: ""), for: .normal)
        }
        
        let endDate = dateRangeArray[indexPath.row][1]
        if endDate != ""{
            cell.endButton.setTitle("\(endDate)  ", for: .normal)
        }else{
            cell.endButton.setTitle(NSLocalizedString("End Date  ", comment: ""), for: .normal)
        }
        
        cell.daysLabel.text = ""

        
        if startDate != "" && endDate != "" {
            let formatter = DateFormatter()
            let calendar = Calendar.current
            formatter.dateFormat = "yyyy-MM-dd"
            let startDate = formatter.date(from: startDate)
            let endDate = formatter.date(from: endDate)
            let diff = calendar.dateComponents([.day], from: startDate!, to: endDate!)
            
            if diff.day == 0{
                cell.daysLabel.text = "\(1)\n\(NSLocalizedString("Day", comment: ""))"
            }else{
                cell.daysLabel.text = "\(diff.day ?? 0)\n\(NSLocalizedString("Days", comment: ""))"
            }
        }
        
        cell.startButton.tag = indexPath.row
        cell.endButton.tag = indexPath.row
        cell.closeButton.tag = indexPath.row

        cell.startButton.addTarget(self, action: #selector(self.startDateAction), for: .touchUpInside)
        cell.endButton.addTarget(self, action: #selector(self.endDateAction), for: .touchUpInside)
        cell.closeButton.addTarget(self, action: #selector(self.closeAction), for: .touchUpInside)

        return cell
        
    }
    
    @objc func startDateAction(_ button : UIButton){
        datePopup(0, button.tag)
    }
    @objc func endDateAction(_ button : UIButton){
        datePopup(1, button.tag)
    }
    
    // Date index will be 0 or 1 which defines it start date or end date
    // date range index is the [start and end date] array index
    
    func datePopup(_ dateIndex:Int, _ dateRangeIndex:Int){
        
        var dateArray = dateRangeArray[dateRangeIndex]
        
        let minDate : Date!
        
        if dateIndex == 0{
            minDate = Date()
        }else{
            minDate = startdateToValidate
        }
        
        var dateComponents1 = DateComponents()
        dateComponents1.month = 12
        datePicker.show("",
                        doneButtonTitle: NSLocalizedString("Done", comment: ""),
                        cancelButtonTitle: NSLocalizedString("Cancel", comment: ""),
                        minimumDate: minDate,
                        maximumDate: nil,
                        datePickerMode: .date) { (date) in
            if let dt = date {
                let formatter = DateFormatter()
                formatter.locale = Locale(identifier: "en_US_POSIX")
                formatter.dateFormat = "yyyy-MM-dd"
                let date = formatter.string(from: dt)
                dateArray[dateIndex] = date
                
                if dateIndex == 1{

                    if let startDate = formatter.date(from:dateArray[0]) {
                        let endDate = formatter.date(from:date)!
                        
                        let startDateComparisionResult:ComparisonResult = startDate.compare(endDate)
                        if startDateComparisionResult == ComparisonResult.orderedDescending
                        {
                            print("future date is smaller")
                            Banner().displayValidationError(string: NSLocalizedString("Please enter valid future date", comment: ""))
                            return
                        }
                    }
                }else if dateIndex == 0{
                    
                    self.startdateToValidate = formatter.date(from:date)!

                    if dateArray[1] != ""{
                    let startDate = formatter.date(from:date)!
                    let endDate = formatter.date(from:dateArray[1])!
                    
                    let startDateComparisionResult:ComparisonResult = startDate.compare(endDate)
                    if startDateComparisionResult == ComparisonResult.orderedDescending
                    {
                        print("future date is smaller")
                        Banner().displayValidationError(string: NSLocalizedString("Please enter valid future date", comment: ""))
                        return
                    }
                        
                    }

                }
                
                self.dateRangeArray.remove(at: dateRangeIndex)
                self.dateRangeArray.append(dateArray)
                self.tableView.reloadData()
            }
        }
        
    }
    
    
    @objc func closeAction(_ button : UIButton){
        dateRangeArray.remove(at: button.tag)
        if dateRangeArray.count==0{
            dateRangeArray.append(["",""])
        }
        tableView.reloadData()
    }
    
    
    @objc func addNewDateRow(_ sender:UIButton){
        
        let startDates = dateRangeArray.last
        
        if startDates?.contains("") == false{
            dateRangeArray.append(["",""])
            tableView.reloadData()
        }

        let lastRow: Int = self.tableView.numberOfRows(inSection: 0) - 1
        let indexPath = IndexPath(row: lastRow, section: 0);
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        
    }
    
}

class DatesCell: UITableViewCell {
    
    var startButton : UIButton!
    var endButton : UIButton!
    var daysLabel : UILabel!
    var closeButton : UIButton!
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        startButton = UIButton()
        startButton.setImage(UIImage(named: "calendar"), for: .normal)
        startButton.backgroundColor = Color.liteWhite
        startButton.setTitleColor(Color.liteBlack, for: .normal)
        startButton.semanticContentAttribute = .forceRightToLeft
        startButton.setTitle(NSLocalizedString("Start Date  ", comment: ""), for: .normal)
        startButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        self.contentView.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview().inset(10)
            make.height.equalTo(30)
            make.width.equalTo(self.contentView.snp.width).dividedBy(3)
        }
        startButton.layer.cornerRadius = 5.0
        startButton.clipsToBounds = true
        
        endButton = UIButton()
        endButton.setImage(UIImage(named: "calendar"), for: .normal)
        endButton.backgroundColor = Color.liteWhite
        endButton.setTitleColor(Color.liteBlack, for: .normal)
        endButton.semanticContentAttribute = .forceRightToLeft
        endButton.setTitle(NSLocalizedString("End Date  ", comment: ""), for: .normal)
        endButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 14.0)
        self.contentView.addSubview(endButton)
        
        endButton.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(startButton.snp.trailing).offset(20)
            make.height.equalTo(50)
            make.width.equalTo(self.contentView.snp.width).dividedBy(3)
        }
        endButton.layer.cornerRadius = 5.0
        endButton.clipsToBounds = true
        
        daysLabel = UILabel()
//        daysLabel.backgroundColor = .red
        daysLabel.text = ""
        daysLabel.font = UIFont(name: "AvenirLTStd-Book", size: 12.0)
        self.contentView.addSubview(daysLabel)
        daysLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(endButton.snp.trailing).offset(10)
            make.centerY.equalTo(endButton)
            
        }
        daysLabel.numberOfLines = 0
        daysLabel.sizeToFit()
        
        
        closeButton = UIButton()
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(Color.red, for: .normal)
        closeButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Heavy", size: 16.0)
        self.contentView.addSubview(closeButton)
        
        closeButton.snp.makeConstraints { (make) in
            make.centerY.equalTo(daysLabel)
            make.leading.equalTo(daysLabel.snp.trailing)
//            make.trailing.equalTo(self.contentView)
            make.width.height.equalTo(50)
        }
        
//        closeButton.backgroundColor = .green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
