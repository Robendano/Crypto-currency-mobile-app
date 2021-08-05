//
//  AnimationView.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 2/8/21.
//

import UIKit

class AnimationView: UIView {
  
  private let image: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(named: "Icon")
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setUp()
  }
  
  private func setUp() {
    addSubview(image)
    
    NSLayoutConstraint.activate([
      image.centerXAnchor.constraint(equalTo: centerXAnchor),
      image.centerYAnchor.constraint(equalTo: centerYAnchor),
      image.widthAnchor.constraint(equalToConstant: 150),
      image.heightAnchor.constraint(equalToConstant: 150)
    ])
  }
  
  func animate() {
    UIView.animate(withDuration: 1) { [weak self] in
      guard let self = self else{return}
      self.image.transform = CGAffineTransform(scaleX: 5, y: 5)
    } completion: { _ in
      UIView.animate(withDuration: 0.5) { [weak self] in
        self?.alpha = 0
      } completion: { [weak self] _ in
        self?.removeFromSuperview()
      }
    }
  }
}
