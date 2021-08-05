//
//  MadDevs_Crypto_Tests.swift
//  MadDevs(Crypto)Tests
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import XCTest
import Alamofire

@testable import MadDevs_Crypto_

class MadDevs_Crypto_Tests: XCTestCase {

  override func setUp() {
    super.setUp()
    
  }
  override func tearDown() {
    
  }
  
  
  func testStatusCode() {

    let expectation = XCTestExpectation(description: "Check status code")
    
    let url = URL(string: "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest")!
    
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("2790f485-8b4c-44fb-87b2-9be8df922e39", forHTTPHeaderField: "X-CMC_PRO_API_KEY")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let dataTask = URLSession.shared.dataTask(with: request) { (_, response, _) in
      guard let response = response as? HTTPURLResponse else {return}
      XCTAssert(response.statusCode == 200, "Request is \(response.statusCode)")
      expectation.fulfill()
    }
    
    dataTask.resume()
    
    wait(for: [expectation], timeout: 10.0)
  }
}
 
