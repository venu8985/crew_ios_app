//
//  LanguageChange.swift
//  Mustajarati
//
//  Created by sanju on 09/03/21.
//

import Foundation
import UIKit


var bundleKey: UInt8 = 0

class AnyLanguageBundle: Bundle {
    
    override func localizedString(forKey key: String,value: String?,table tableName: String?) -> String {
        
        guard let path = objc_getAssociatedObject(self, &bundleKey) as? String,
            let bundle = Bundle(path: path) else {
            return super.localizedString(forKey: key, value: value, table: tableName)
        }
        return bundle.localizedString(forKey: key, value: value, table: tableName)
    }
}


extension Bundle {
    class func setLanguage(_ language: String) {
        defer {
            object_setClass(Bundle.main, AnyLanguageBundle.self)
        }
        objc_setAssociatedObject(Bundle.main, &bundleKey,    Bundle.main.path(forResource: language, ofType: "lproj"), .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}




class LanguageChange {
    //static var shared = GetNewLanguage()
    
    class var shared : LanguageChange{
        struct Singleton{
            static let instanse = LanguageChange()
        }
        return Singleton.instanse
    }
    
    func Change(chageLang: String){
          
            if chageLang == NSLocalizedString("English", comment: ""){
                //UserDefaults.standard.set("en", forKey: "language")
                Bundle.setLanguage("en")
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
            }
            else{
                //UserDefaults.standard.set("ar", forKey: "language")
                Bundle.setLanguage("ar")
                UIView.appearance().semanticContentAttribute = .forceRightToLeft
            }
//        deinit {
          NotificationCenter.default.removeObserver(self, name: Notification.logout, object: nil)
//        }
            let objStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
            let rootNav = objStoryboard.instantiateViewController(withIdentifier: "rootNav") as! UINavigationController
            //UIApplication.shared.keyWindow?.rootViewController = rootNav
            //UIApplication.shared.keyWindow?.makeKeyAndVisible()
            if let keyWindow = UIWindow.key {
                keyWindow.rootViewController = rootNav
            }
        
    }
    
}


extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
