//
//  RealmModel.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import Foundation
import RealmSwift

// model in local storage
class SaveModel: Object {
    
  @objc dynamic var id: Int = 0
  @objc dynamic var name: String = ""
  @objc dynamic var symbol: String = ""
  
  let currencies = List<Current>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
}

class Current: Object {
    
  @objc dynamic var price: Double = 0.0
  @objc dynamic var volume_24h: Double = 0.0
  @objc dynamic var percent_change_1h: Double = 0.0
  @objc dynamic var percent_change_24h: Double = 0.0
  @objc dynamic var percent_change_7d: Double = 0.0
  @objc dynamic var percent_change_30d: Double = 0.0
  @objc dynamic var percent_change_60d: Double = 0.0
  @objc dynamic var percent_change_90d: Double = 0.0
  @objc dynamic var market_cap: Double = 0.0
  @objc dynamic var last_updated: String = ""
}
