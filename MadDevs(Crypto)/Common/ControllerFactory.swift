//
//  ControllerFactory.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import UIKit

extension UIViewController {
  static func identifier() -> String {
    String(describing: self)
  }
  static func getVC(storyboardName: StoryBoards) -> UIViewController {
    let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
    let controller = storyboard.instantiateViewController(withIdentifier: identifier())
    controller.modalPresentationStyle = .overFullScreen
    return controller
  }
}
enum StoryBoards: String {
  case Main
}
