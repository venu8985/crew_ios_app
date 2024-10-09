//
//  Banner.swift
//  Crew
//
//  Created by Rajeev on 10/03/21.
//

import Foundation
import NotificationBannerSwift
import UIKit

class Banner{
    
    func displayValidationError(string:String){
                
        let banner = NotificationBanner(title: NSLocalizedString("Error", comment: ""), subtitle: string, style: .danger)
        banner.autoDismiss = true
        banner.duration = 1.0
        banner.backgroundColor = #colorLiteral(red: 0.9921568627, green: 0.2078431373, blue: 0.3294117647, alpha: 1)
        banner.show()
        
    }
    
    func displaySuccess(string:String){
                
        let banner = NotificationBanner(title: NSLocalizedString("Success", comment: ""), subtitle: string, style: .danger)
        banner.autoDismiss = true
        banner.duration = 1.0
        banner.backgroundColor = .systemGreen
        banner.show()
        
    }

}

