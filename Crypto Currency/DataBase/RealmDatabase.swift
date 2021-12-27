//
//  RealmDatabase.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import Foundation
import RealmSwift

class RealmDatabase {
    
    private init () {}
    
    static let shared = RealmDatabase()
    private var realm = try! Realm()
}

extension RealmDatabase {
    
    func save(_ object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    func save(_ objects: [Object]) {
        do {
            try realm.write {
                realm.add(objects)
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
}
