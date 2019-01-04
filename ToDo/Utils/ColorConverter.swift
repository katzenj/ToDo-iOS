//
//  ColorConverter.swift
//  ToDo
//
//  Created by Jordan  on 10/24/18.
//  Copyright © 2018 Jordan Katzen. All rights reserved.
//

import UIKit

func hexStringToUIColor (hex:String) -> UIColor {
    var hexString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (hexString.hasPrefix("#")) {
        hexString.remove(at: hexString.startIndex)
    }
    
    if ((hexString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: hexString).scanHexInt32(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
