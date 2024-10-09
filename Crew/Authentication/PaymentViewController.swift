//
//  PaymentViewController.swift
//  Crew
//
//  Created by Rajeev Pulleti on 23/07/21.
//

import UIKit
import WebKit

class PaymentViewController: UIViewController ,WKNavigationDelegate,WKUIDelegate{
    
    private var webView = WKWebView(frame: .zero)

    var paymentUrl : String!
    var completionHandler:((Bool)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)

        self.webView = WKWebView(frame: frame, configuration: WKWebViewConfiguration())
        self.webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(self.webView)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        self.view.setNeedsLayout()
        let request = URLRequest(url: URL.init(string: paymentUrl)!)
        self.webView.load(request)
        
        navigationBarItems()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isHidden = false
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
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.popViewController(animated: true)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        GGProgress.shared.show(with: "")
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        GGProgress.shared.hide()
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        GGProgress.shared.hide()
    }
    func webViewDidStartLoad(_ : WKWebView) {
        GGProgress.shared.show(with: "")
    }
    func webViewDidFinishLoad(_ : WKWebView) {
        GGProgress.shared.hide()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if let urlStr = navigationAction.request.url?.absoluteString {
            //urlStr is what you want
            print("url ::\(urlStr)")
            
            if urlStr.lowercased().contains(Url.baseUrl+"/user/failed-") {
                GGProgress.shared.hide()
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.navigationBar.isHidden = true
                self.navigationController?.popViewController(animated: false)
                self.completionHandler?(false)
            }
            else if urlStr.lowercased().contains(Url.baseUrl+"/user/success-"){
                GGProgress.shared.hide()
                self.navigationController?.isNavigationBarHidden = true
                self.navigationController?.navigationBar.isHidden = true
                self.navigationController?.popViewController(animated: false)
                self.completionHandler?(true)
            }
        }
        decisionHandler(.allow)
    }
}

