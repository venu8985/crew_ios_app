//
//  SignatureViewController.swift
//  Crew
//
//  Created by Rajeev on 16/03/21.
//

import UIKit
import SignaturePad

class SignatureViewController: UIViewController {

    @IBOutlet var signaturePad : SignaturePad!
    @IBOutlet var signatureLabel : UILabel!
    var delegate : SignatureDelegate!
    @IBOutlet var submitButton : UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        signaturePad.delegate = self
        
        submitButton.layer.cornerRadius = 5.0
        submitButton.clipsToBounds = true
        
    }
    

    @IBAction func submitAction(_ sender : UIButton){

        
        if let signature = signaturePad.getSignature() {
            // Do Something
            if let image = signature.cgImage{
                delegate.userSignature(image: image)
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
 
    @IBAction func closeAction(_ sender : UIButton){

        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func clearAction(_ sender : UIButton){
        signatureLabel.isHidden = false
        signaturePad.clear()
    }
}

extension SignatureViewController : SignaturePadDelegate{
    func didStart() {
        signatureLabel.isHidden = true
    }
    
    func didFinish() {
        print("signature end")
    }
    
    
}
