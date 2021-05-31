//
//  Extensions.swift
//  LetsMeet
//
//  Created by John Hur on 2021/05/31.
//

import Foundation
import UIKit

extension Date {
    
    func longDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        return dateFormatter.string(from: self)
    }
    
    func stringDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMMyyyyHHmmss"
        return dateFormatter.string(from: self)
    }
}

// UIColor는 UIKit에 속해있음
extension UIColor {
    
    func primary() -> UIColor {
        return UIColor(red: 255/255, green: 45/255, blue: 85/255, alpha: 1)
    }
    
    func tapBarUnselected() -> UIColor {
        return UIColor(red: 255/255, green: 216/255, blue: 223/255, alpha: 1)
    }
    
}

