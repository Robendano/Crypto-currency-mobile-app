//
//  UIViewcontroller.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import UIKit

extension UIViewController {
  func setupTransparentNavigationBar() {
    navigationController?.navigationBar.barTintColor = .clear
    navigationController?.setNavigationBarHidden(false, animated: true)
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white,
                                                               NSAttributedString.Key.font: UIFont(name: "SFUIDisplay-Regular", size: 18) ?? UIFont.systemFont(ofSize: 18)]
    navigationController?.navigationBar.isTranslucent = true
  }
  func setRightButton() {
    let rightButton = UIButton()
    let config = UIImage.SymbolConfiguration(scale: .large)
    let image = UIImage(systemName: "gearshape", withConfiguration: config)
    rightButton.setImage(image, for: .normal)
    rightButton.tag = 1
    navigationController?.navigationBar.addSubview(rightButton)
    rightButton.frame = CGRect(x: self.view.frame.width, y: 0, width: 120, height: 40)
    let targetView = self.navigationController?.navigationBar
    
    let trailingContraint = NSLayoutConstraint(item: rightButton, attribute:
                                                .trailingMargin, relatedBy: .equal, toItem: targetView,
                                               attribute: .trailingMargin, multiplier: 1.0, constant: -10)
    let bottomConstraint = NSLayoutConstraint(item: rightButton, attribute: .bottom, relatedBy: .equal,
                                              toItem: targetView, attribute: .bottom, multiplier: 1.0, constant: -20)
    rightButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([trailingContraint, bottomConstraint])
  }
  func setBackButton(with image: String, title: String = " ") {
    let yourBackImage = UIImage(systemName: image)
    self.navigationController?.navigationBar.backIndicatorImage = yourBackImage
    self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = yourBackImage
    self.navigationController?.navigationBar.backItem?.title = title
  }
  func removeRightButton() {
    guard let subviews = self.navigationController?.navigationBar.subviews else{return}
    for view in subviews {
      if view.tag != 0 {
        view.removeFromSuperview()
      }
    }
  }
  func createAlert(with title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
    present(alert, animated: true)
  }
}


