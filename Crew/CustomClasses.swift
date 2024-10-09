//
//  Extensions.swift
//  Crew
//
//  Created by Rajeev on 01/03/21.
//

import Foundation
import UIKit


class StartStopButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setTitleColor(.lightGray, for: .normal)
        let dotImage = UIImage(named: "dots")?.sd_resizedImage(with: CGSize(width: 14, height: 14), scaleMode: .aspectFit)

        self.setImage(dotImage, for: .normal)
        self.semanticContentAttribute = .forceRightToLeft
        self.contentMode = .scaleAspectFit

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ProjectDetailsView : UIView{
    
    var statusButton : UIButton!
    var projectNameLabel : UILabel!
    var budgetLabel : UILabel!
    var costLabel : UILabel!
    var startLabel : UILabel!
    var stopLabel : UILabel!
    var ongoingProjectNameLabel : UILabel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
  


        self.layer.cornerRadius = 10.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.lightGray.cgColor
        
        
        let projectNameLabel = UILabel()
        projectNameLabel.text = NSLocalizedString("Project Name", comment: "")
        projectNameLabel.font = UIFont.systemFont(ofSize: 10.0)
        projectNameLabel.textColor = .lightGray
        self.addSubview(projectNameLabel)
        
        projectNameLabel.snp.makeConstraints { (make) in
            make.leading.top.equalTo(self).offset(10)
        }
        
        statusButton = UIButton()
//        statusButton.setTitle(NSLocalizedString(" Ongoing", comment: ""), for: .normal)
//        statusButton.setImage(UIImage(named: "green"), for: .normal)
        statusButton.titleLabel!.font = UIFont(name: "AvenirLTStd-Book", size: 10)
        statusButton.setTitleColor(.lightGray, for: .normal)
        self.addSubview(statusButton)
        
        statusButton.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(05)
            make.trailing.equalTo(self).inset(10)
        }
        
        
        ongoingProjectNameLabel = UILabel()
//        ongoingProjectNameLabel.text = "Movie about 3 billboards outside ebbing and mussourie"
        ongoingProjectNameLabel.font = UIFont.boldSystemFont(ofSize: 12.0)
        self.addSubview(ongoingProjectNameLabel)
        
        ongoingProjectNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(projectNameLabel.snp.bottom).offset(5)
            make.leading.equalTo(projectNameLabel)
            make.trailing.equalTo(self).inset(20)
        }
        
        
        let dashLineView = UIView()
        dashLineView.frame = CGRect(x: 10, y: 50, width: UIScreen.main.bounds.width-40, height: 0.25)
        self.addSubview(dashLineView)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            ongoingProjectNameLabel.textAlignment = .right
            projectNameLabel.textAlignment = .right
        }else{
            ongoingProjectNameLabel.textAlignment = .left
            projectNameLabel.textAlignment = .left
        }
        
        
//        dashLineView.snp.makeConstraints { (make) in
//            make.leading.trailing.equalTo(projectNameLabel)
//            make.trailing.equalTo(self).offset(-10)
//            make.top.equalTo(ongoingProjectNameLabel.snp.bottom).offset(5)
//            make.height.equalTo(0.5)
//        }
        
        drawDottedLine(start: CGPoint(x: dashLineView.bounds.minX, y: dashLineView.bounds.minY), end: CGPoint(x: dashLineView.bounds.maxX, y: dashLineView.bounds.minY), view: dashLineView)
        
//        lineView.frame = CGRect(x: 30, y: 55, width: self.view.frame.size.width-60, height: 0.25)
//        self.view.addSubview(lineView)
//        drawDottedLine(start: CGPoint(x: lineView.bounds.minX, y: lineView.bounds.minY), end: CGPoint(x: lineView.bounds.maxX, y: lineView.bounds.minY), view: lineView)
        
        let dateTimelineButton = UIButton()
        dateTimelineButton.setTitleColor(UIColor.red, for: .normal)
        dateTimelineButton.setTitle(NSLocalizedString("  Dates / Timeline ", comment: ""), for: .normal)
        dateTimelineButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        let dateTimelineImage = UIImage(named: "date_timeline")
            //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        dateTimelineButton.setImage(dateTimelineImage, for: .normal)
        dateTimelineButton.isUserInteractionEnabled = false
        self.addSubview(dateTimelineButton)
        
        dateTimelineButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dashLineView)
            make.top.equalTo(dashLineView.snp.bottom).offset(10)
            
        }
//        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            dateTimelineButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        }
        
        let startButton = StartStopButton()
//        startButton.backgroundColor = .orange
        startButton.isUserInteractionEnabled = false
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        startButton.setTitle(NSLocalizedString("Start   ", comment: ""), for: .normal)
        self.addSubview(startButton)
        
        startButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-15)
            make.top.equalTo(dateTimelineButton.snp.bottom).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
      
//        startButton.imageEdgeInsets = UIEdgeInsets(top: 04, left: 30, bottom: 04, right: 36)
        
        
        let stopButton = StartStopButton()
//        stopButton.backgroundColor = .green
        stopButton.isUserInteractionEnabled = false
        stopButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        stopButton.setTitle(NSLocalizedString("Stop    ", comment: ""), for: .normal)
        self.addSubview(stopButton)
        
        stopButton.snp.makeConstraints { (make) in
            make.leading.equalTo(dateTimelineButton).offset(-15)
            make.top.equalTo(startButton.snp.bottom).offset(10)
            make.width.equalTo(80)
            make.height.equalTo(20)
        }
        
//        if UserDefaults.standard.value(forKey: "Language") as? String != "en"{
//            stopButton.imageEdgeInsets = UIEdgeInsets(top: 05, left: 28, bottom: 03, right: 30);
//        }else{
//            stopButton.imageEdgeInsets = UIEdgeInsets(top: 05, left: 25, bottom: 03, right: 35);
//        }

        
        
        let lineView = UIView()
        lineView.backgroundColor = .lightGray
        self.addSubview(lineView)
        
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            lineView.snp.makeConstraints { (make) in
                make.top.equalTo(startButton.snp.bottom).inset(5)
                make.bottom.equalTo(stopButton.snp.top).offset(5)
                make.leading.equalTo(startButton).inset(19)
                make.width.equalTo(1)
            }
        }else{
            lineView.snp.makeConstraints { (make) in
                make.top.equalTo(startButton.snp.bottom).inset(5)
                make.bottom.equalTo(stopButton.snp.top).offset(5)
                make.trailing.equalTo(startButton).inset(19)
                make.width.equalTo(1)
            }
        }
        

        
        startLabel = UILabel()
        startLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.addSubview(startLabel)
        
        startLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(startButton)
            make.leading.equalTo(startButton.snp.trailing)
        }
        
        
        stopLabel = UILabel()
        stopLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.addSubview(stopLabel)
        
        stopLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(stopButton)
            make.leading.equalTo(stopButton.snp.trailing)
        }
        
        
        let BudgetButton = StartStopButton()
        BudgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        BudgetButton.setTitle(NSLocalizedString("Budget  ", comment: ""), for: .normal)
        BudgetButton.isUserInteractionEnabled = false
        self.addSubview(BudgetButton)
        
        BudgetButton.snp.makeConstraints { (make) in
            make.leading.equalTo(startLabel.snp.trailing).offset(20)
            make.centerY.equalTo(startButton)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
//        BudgetButton.imageEdgeInsets = UIEdgeInsets(top: 07, left: 36, bottom: 04, right: 43)
        
        
        
        
        budgetLabel = UILabel()
//        budgetLabel.text = "SAR 50,000"
        budgetLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.addSubview(budgetLabel)
        
        budgetLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(BudgetButton)
            make.leading.equalTo(BudgetButton.snp.trailing).offset(-10)
        }
        
        
        let costButton = StartStopButton()
        costButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        costButton.isUserInteractionEnabled = false
        costButton.setTitle(NSLocalizedString("Cost       ", comment: ""), for: .normal)
        self.addSubview(costButton)
        
        costButton.snp.makeConstraints { (make) in
            make.leading.equalTo(BudgetButton)
            make.centerY.equalTo(stopButton)
            make.width.equalTo(100)
            make.height.equalTo(25)
        }
//        costButton.imageEdgeInsets = UIEdgeInsets(top: 06, left: 44, bottom: 05, right: 22)
        
        
        costLabel = UILabel()
//        costLabel.text = "SAR 24,000"
        costLabel.font = UIFont.boldSystemFont(ofSize: 12)
        self.addSubview(costLabel)
        
        costLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(costButton)
            make.leading.equalTo(budgetLabel)
        }
        
        
        let lineView1 = UIView()
        lineView1.backgroundColor = .lightGray
        self.addSubview(lineView1)
        
      
        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(BudgetButton.snp.bottom).inset(5)
                make.bottom.equalTo(costButton.snp.top).offset(5)
                make.leading.equalTo(BudgetButton).inset(25)
                make.width.equalTo(1)
            }
        }else{
            lineView1.snp.makeConstraints { (make) in
                make.top.equalTo(BudgetButton.snp.bottom).inset(5)
                make.bottom.equalTo(costButton.snp.top).offset(5)
                make.trailing.equalTo(BudgetButton).inset(25)
                make.width.equalTo(1)
            }
        }
        
        
        let projectBudgetButton = UIButton()
        projectBudgetButton.setTitleColor(UIColor.red, for: .normal)
        projectBudgetButton.setTitle(NSLocalizedString("  Project Budget ", comment: ""), for: .normal)
        projectBudgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 12.0)
        projectBudgetButton.titleLabel?.font = UIFont(name: "AvenirLTStd-Book", size: 12)
        let projectBudgetImage = UIImage(named: "project_budget")
            //?.sd_resizedImage(with: CGSize(width: 12, height: 12), scaleMode: .aspectFit)
        projectBudgetButton.setImage(projectBudgetImage, for: .normal)
        projectBudgetButton.isUserInteractionEnabled = false
        self.addSubview(projectBudgetButton)
        
        projectBudgetButton.snp.makeConstraints { (make) in
            make.leading.equalTo(BudgetButton).offset(15)
            make.top.equalTo(dashLineView.snp.bottom).offset(10)
        }
//        if UserDefaults.standard.value(forKey: "Language") as? String == "ar"{
//            projectBudgetButton.transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
//        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func drawDottedLine(start p0: CGPoint, end p1: CGPoint, view: UIView) {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = Color.red.withAlphaComponent(0.25).cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.lineDashPattern = [7, 3] // 7 is the length of dash, 3 is length of the gap.

        let path = CGMutablePath()
        path.addLines(between: [p0, p1])
        shapeLayer.path = path
        view.layer.addSublayer(shapeLayer)
    }
    
}



