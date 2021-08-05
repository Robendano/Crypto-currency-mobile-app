//
//  Realm_Request_Tests.swift
//  MadDevs(Crypto)Tests
//
//  Created by Рамазан Юсупов on 4/8/21.
//

import XCTest
import RealmSwift

@testable import MadDevs_Crypto_

class Realm_Request_Tests: XCTestCase {
  
  private let realm = try! Realm()

  public func createOrUpdateUser(in realm: Realm, with data: Data) {
    guard let object = try! JSONSerialization.jsonObject(with: data) as? [String: String] else {return}
    try! realm.write {
      realm.create(SaveModel.self, value: object, update: .modified)
    }
  }
  
  func testThatCurrencyUpdatedFromServer() {
    let config = Realm.Configuration(fileURL: realm.configuration.fileURL)
    let testRealm = try! Realm(configuration: config)
    let jsonData = "{\"symbol\": \"BTC\"}".data(using: .utf8)!
    createOrUpdateUser(in: testRealm, with: jsonData)
    XCTAssertEqual(testRealm.objects(SaveModel.self).first!.symbol, "BTC",
                   "Crypto Currency was not properly updated from server.")
  }
  
  func testRealmDefaults() throws {
    setUp()
  }
  
  override func setUp() {
    super.setUp()
    Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
  }
}
