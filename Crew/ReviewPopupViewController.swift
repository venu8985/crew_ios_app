//
//  ReviewPopupViewController.swift
//  Crew
//
//  Created by Rajeev on 03/05/21.
//

import UIKit
import Cosmos

class ReviewPopupViewController: UIViewController {

    var ratingsView           : CosmosView!
    var descriptionTextview   : UITextView!
    var reviewDelegate        : ReviewProtocol!
    var rating                : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.view.backgroundColor = UIColor.gray.withAlphaComponent(0.8)
        
     
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
        titleLabel.text = NSLocalizedString("Submit your feedback", comment: "")
        titleLabel.font = UIFont(name: "AvenirLTStd-Heavy", size: 20)
        bgView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(bgView).offset(5)
            make.leading.equalTo(bgView).offset(10)
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
        createButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 13)
        createButton.setTitle(NSLocalizedString("Submit review", comment: ""), for: .normal)
        createButton.addTarget(self, action: #selector(self.createButtonAction), for: .touchUpInside)
        bgView.addSubview(createButton)
        
        createButton.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalTo(bgView).inset(20)
            make.height.equalTo(40)
        }
        
        createButton.layer.cornerRadius = 5.0
        createButton.clipsToBounds = true
        
        
        ratingsView = CosmosView()
        ratingsView.rating = 0.0
//        ratingsView.settings.totalStars = 5
//        ratingsView.settings.starSize = 50
//        ratingsView.settings.filledColor = UIColor.red
        ratingsView.settings.totalStars = 5
        ratingsView.settings.starSize = 50
        ratingsView.settings.filledColor = .red
        ratingsView.settings.emptyBorderColor = .red
        ratingsView.didFinishTouchingCosmos = { rating in
            print("rating \(rating)")
            self.rating = String(rating)
        }
        self.view.addSubview(ratingsView)
        
        ratingsView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(55)
            make.top.equalTo(lineView.snp.bottom).offset(25)
        }
        
  
        descriptionTextview = UITextView()
        descriptionTextview.text = NSLocalizedString("Your comment", comment: "")
        descriptionTextview.textColor = UIColor.lightGray
        descriptionTextview.font = UIFont(name: "AvenirLTStd-Light", size: 14)
        descriptionTextview.text = NSLocalizedString("Enter description", comment: "")
        descriptionTextview.delegate = self
        bgView.addSubview(descriptionTextview)
        
        descriptionTextview.snp.makeConstraints { (make) in
            make.leading.equalTo(bgView).offset(15)
            make.trailing.equalTo(bgView).offset(-15)
            make.top.equalTo(ratingsView.snp.bottom).offset(10)
            make.bottom.equalTo(createButton.snp.top).offset(-10)
        }
        descriptionTextview.layer.cornerRadius = 10.0
        descriptionTextview.layer.borderWidth = 0.5
        descriptionTextview.layer.borderColor = Color.gray.cgColor
        descriptionTextview.clipsToBounds = true
        
    }
    @objc func dismissVC() {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func createButtonAction(){

        if rating == nil{
            Banner().displayValidationError(string: NSLocalizedString("Please give rating", comment: ""))
        }
        else if descriptionTextview.text.count == 0 || descriptionTextview.text == NSLocalizedString("Your comment", comment: ""){
            Banner().displayValidationError(string: NSLocalizedString("Please give comment", comment: ""))
        }else{
            reviewDelegate.submitReview(rating: rating, feedback: descriptionTextview.text)
            self.dismiss(animated: true, completion: nil)
        }
    }

}

extension ReviewPopupViewController : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = NSLocalizedString("Your comment", comment: "")
            textView.textColor = UIColor.lightGray
        }
    }
    
}
