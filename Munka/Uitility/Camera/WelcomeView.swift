//
//  WelcomeView.swift
//  Munka
//
//  Created by Amit on 06/11/19.
//  Copyright © 2019 Harish Patidar. All rights reserved.
//

import UIKit

class WelcomeView: UIView {

   override func layoutSubviews() {
        super.layoutSubviews()
        roundCorners(corners: [.topLeft, .topRight], radius: 52.0)
    }
}
extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
