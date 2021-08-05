//
//  RealmDatabase.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 3/8/21.
//

import Foundation
import RealmSwift

class RealmDatabase {
  static let instance = RealmDatabase()
  
  private var realm = try! Realm()
  
  private init () {}
}

extension RealmDatabase {
  func save(_ object: Object) {
    do {
      try realm.write({
        realm.add(object)
      })
    } catch let err {
      print(err.localizedDescription)
    }
  }
  
  func save(_ objects: [Object]) {
    do {
      try realm.write({
        realm.add(objects)
      })
    } catch let err {
      print(err.localizedDescription)
    }
  }
  
}
