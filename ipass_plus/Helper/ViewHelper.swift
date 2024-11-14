//
//  ViewHelper.swift
//  ipass_plus
//
//  Created by MOBILE on 31/01/24.
//

import UIKit
//
//    
//    extension UIView {
//        func addTopBorder(with color: UIColor, andWidth borderWidth: CGFloat) {
//            let border = CALayer()
//            border.backgroundColor = color.cgColor
//            border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width , height: borderWidth)
//            let cornerRadius: CGFloat = 20.0
//            self.layer.cornerRadius = cornerRadius
//            self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
//            
//            self.layer.addSublayer(border)
//            
//        }
//        
//    }
//
extension UIView {
    func topCornerRadius(with cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        self.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
}



