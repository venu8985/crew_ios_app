//
//  Extensions.swift
//  Crew
//
//  Created by Rajeev on 04/03/21.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt64()
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension UITapGestureRecognizer {

    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)

        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize

        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        //let textContainerOffset = CGPointMake((labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x,
                                              //(labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y);
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
 
        //let locationOfTouchInTextContainer = CGPointMake(locationOfTouchInLabel.x - textContainerOffset.x,
                                                        // locationOfTouchInLabel.y - textContainerOffset.y);
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }

}


public func timeAgoSinceLast(_ date: Date) -> String {
    
    let calendar = Calendar.current
  //  calendar.locale = Locale(identifier: Bundle.main.preferredLocalizations[0])
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year) \(NSLocalizedString("years ago", comment: ""))"
    }
    
    if let year = components.year, year >= 1 {
        return NSLocalizedString("Last year", comment: "")
    }
    
    if let month = components.month, month >= 2 {
        return "\(month) \(NSLocalizedString("months ago", comment: ""))"
    }
    
    if let month = components.month, month >= 1 {
        return NSLocalizedString("Last month", comment: "")
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week) \(NSLocalizedString("weeks ago", comment: ""))"

    }
    
    if let week = components.weekOfYear, week >= 1 {
        return NSLocalizedString("Last week", comment: "")
    }
    
    if let day = components.day, day >= 2 {
        return "\(day) \(NSLocalizedString("days ago", comment: ""))"

    }
    
    if let day = components.day, day >= 1 {
        return NSLocalizedString("Yesterday", comment: "")

    }
    
    if let hour = components.hour, hour >= 2 {
        if let minute = components.minute, minute >= 30 {
           return String(hour + 1) + " \(NSLocalizedString("hours ago", comment: ""))"
        }
        
        return String(hour) + " \(NSLocalizedString("hours ago", comment: ""))"
    }
    
    if let hour = components.hour, hour >= 1 {
        return " \(NSLocalizedString("An hour ago", comment: ""))"
    }
    
    if let minute = components.minute, minute >= 2 {
        return String(minute)  + " \(NSLocalizedString("minutes ago", comment: ""))"
    }
    
    if let minute = components.minute, minute >= 1 {
        return " \(NSLocalizedString("A minute ago", comment: ""))"
    }
    
    if let second = components.second, second >= 3 {
        return (String(second)  + " \(NSLocalizedString("seconds ago", comment: ""))")
    }
    return " \(NSLocalizedString("Just now", comment: ""))"

}


extension String {
    func stringToDate() -> Date? {
        let dateFormatter = DateFormatter()
//          dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ" //Your date format
        if let date = dateFormatter.date(from: self) {
            return date.toLocalTime()
        }
        return nil
    }
    
}

extension Date {

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }
    func toLocalTimeCheck() -> Date {
         let timezone = TimeZone(abbreviation: "UTC")
        let seconds = TimeInterval(timezone!.secondsFromGMT(for: self))
         return Date(timeInterval: seconds, since: self)
     }
  
  //dateFormatter.timeZone =
}
extension UIButton{
    typealias ButtonAction = () -> Void
    
    private struct AssociatedKeys {
        static var ActionKey = "ActionKey"
    }
    
    private class ActionWrapper {
        let action: ButtonAction
        init(action: @escaping ButtonAction) {
            self.action = action
        }
    }
    
    var action: ButtonAction? {
        set(newValue) {
            if action != nil {
                fatalError("Action method is already assigned. Must be remove old action")
            }
            removeTarget(self, action: #selector(performAction), for: .touchUpInside)
            var wrapper: ActionWrapper? = nil
            if let newValue = newValue {
                wrapper = ActionWrapper(action: newValue)
                addTarget(self, action: #selector(performAction), for: .touchUpInside)
            }
            objc_setAssociatedObject(self, &AssociatedKeys.ActionKey, wrapper, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            guard let wrapper = objc_getAssociatedObject(self, &AssociatedKeys.ActionKey) as? ActionWrapper else {
                return nil
            }
            
            return wrapper.action
        }
    }
    
    private func defaultInit() {
    
    }
    
    @objc private func performAction() {
        
        if let vc = self.parentViewController {
            vc.view.endEditing(true)
        }

        guard let action = action else {
            return
        }

        action()
    }
    func applyUnderline(){
        let yourAttributes: [NSAttributedString.Key: Any] = [
             .underlineStyle: NSUnderlineStyle.single.rawValue
         ]
             
        let attributeString = NSMutableAttributedString(
            string: self.title(for: .normal) ?? "",
                attributes: yourAttributes
             )
        UIView.performWithoutAnimation {
            self.setAttributedTitle(attributeString, for: .normal)
            self.setAttributedTitle(attributeString, for: .highlighted)
        }
    }
}

extension UIView {
    @objc var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
extension Date {
    func toAgeDays() -> Int {
        let now = Date()
        let ageComponents = Calendar.current.dateComponents([.day], from: now, to: self)
        return ageComponents.day ?? 0
    }
}
extension UIViewController {

    var isModal: Bool {

        let presentingIsModal = presentingViewController != nil
        let presentingIsNavigation = navigationController?.presentingViewController?.presentedViewController == navigationController
        let presentingIsTabBar = tabBarController?.presentingViewController is UITabBarController

        return presentingIsModal || presentingIsNavigation || presentingIsTabBar
    }
}
