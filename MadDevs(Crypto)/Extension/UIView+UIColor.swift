//
//  UIView + UIColor.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import UIKit

extension UIView {
  
  func setBlur(with effect: UIBlurEffect.Style) {
    let blurEffect = UIBlurEffect(style: effect)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    addSubview(blurEffectView)
  }
  
  func setCircleCorner(with radius: CGFloat = 0) {
    layer.cornerRadius = radius
    layer.masksToBounds = true
  }
  
  func addGradientBackground() {
    let random = UIColor.random().cgColor
    let random2 = UIColor.random().cgColor
    
    let gradient = CAGradientLayer()
    gradient.frame = bounds
    gradient.colors = [random, random2]
    
    layer.insertSublayer(gradient, at: 0)
  }
}

extension UIColor {
  static func random() -> UIColor {
    let red = CGFloat.random(in: 1/2...2/3)
    let green = CGFloat.random(in: 1/10...1/5)
    let blue = CGFloat.random(in: 0...2/3)
    return UIColor(red: red, green: green, blue: blue, alpha: 1)
  }
}
