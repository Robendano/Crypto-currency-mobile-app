//
//  RealmDatabase.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import Foundation
import RealmSwift

// it is class for local storage
class RealmDatabase {
    //initializing
    private init () {}
    
    // it is Singlton
    static let shared = RealmDatabase()
    private var realm = try! Realm()
}

extension RealmDatabase {
    // method for saving object in local storage
    func save(_ object: Object) {
        do {
            try realm.write {
                realm.add(object)
            }
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
    // method for saving array of objects in local storage
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
