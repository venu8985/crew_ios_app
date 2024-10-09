//
//  CRNViewController.swift
//  Crew
//
//  Created by Rajeev on 24/03/21.
//

import UIKit
import WebKit

class CRNViewController: UIViewController {

    var crnURLString : String!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .white

        let url = URL(string: crnURLString)
        
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.frame = self.view.bounds
        let targetURL = url
        let request = URLRequest(url: targetURL!)
        webView.load(request)

        view.addSubview(webView)
        
        
    }
    

}
