//
//  UIColorExtension.swift
//  Attendance Connect
//
//  Created by Neel on 22/09/18.
//  Copyright © 2018 Neel Makhecha. All rights reserved.
//

import Foundation
import UIKit

extension UIColor{
    
    static func colorFromHex(hex:String) -> UIColor{
        
        var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if hexString.hasPrefix("#"){
            hexString.remove(at: hexString.startIndex)
        }
        
        if hexString.count != 6{
            return UIColor.black
        }
        
        var RGB:UInt32 = 0
        
        Scanner(string: hexString).scanHexInt32(&RGB)
        
        return (UIColor.init(red: CGFloat((RGB & 0xFF0000) >> 16)/255.0, green: CGFloat((RGB & 0x00FF00) >> 8)/255.0, blue: CGFloat(RGB & 0x0000FF)/255.0, alpha: 1.0))
    }
}
