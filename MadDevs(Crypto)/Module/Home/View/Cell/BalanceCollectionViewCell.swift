//
//  BalanceCollectionViewCell.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import UIKit

class BalanceCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var currencyLabel: UILabel!
  @IBOutlet weak var amountLabel: UILabel!
  @IBOutlet weak var background: UIView!
  @IBOutlet weak var withDrawBtn: UIButton!
  @IBOutlet weak var depositBtn: UIButton!
  @IBOutlet weak var imageView: UIImageView!
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
    setCircleCorner(with: 16)
    withDrawBtn.setCircleCorner(with: 8)
    depositBtn.setCircleCorner(with: 8)
    
    withDrawBtn.setBlur(with: .systemUltraThinMaterialLight)
    depositBtn.setBlur(with: .systemUltraThinMaterialLight)
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
    background.backgroundColor = .clear
    currencyLabel.text = nil
    amountLabel.text = nil
    withDrawBtn = nil
    depositBtn = nil
  }
  
  func configureCell() {

    background.addGradientBackground()
    imageView.image = UIImage(named: "bitcoin")
    currencyLabel.text = "$"
    amountLabel.text = "43,434.30"
  }
}

extension UICollectionViewCell {
  static func identifier() -> String {
    String(describing: self)
  }
}
