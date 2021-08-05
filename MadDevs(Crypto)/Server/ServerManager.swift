//
//  ServerManager.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 30/7/21.
//

import Foundation
import Alamofire
import RealmSwift

protocol JSONConverter {
  func convertFromJSON<T: Codable>(model: T.Type,
                                   data: Data?) -> T?
}

protocol Requests {
  func sendRequest<T: Codable>(urlString: String,
                               complition: @escaping ((T?, String?) -> Void))
}

class ServerManager: HTTPRequest {
  static let instance = ServerManager()
  private override init (){}
  
  private var realm = try! Realm()
}


extension ServerManager {
  func getChange(completion: @escaping ((CryptoModel?, String?) -> Void)) {
    let urlString = "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest"
    
    let headers: HTTPHeaders = [
      "X-CMC_PRO_API_KEY": "2790f485-8b4c-44fb-87b2-9be8df922e39",
      "Content-Type" : "application/json"
    ]
    self.get(url: urlString, header: headers, complition: { [weak self] (data) in
      guard
        let data = data,
        let self = self
      else {return}
      do {
        let convertedData = try JSONDecoder().decode(CryptoModel.self, from: data)
        for i in 0..<(convertedData.data?.count ?? 0){
          guard let model = convertedData.data?[i] else {return}
          self.save(model: model)
        }
        completion(convertedData, nil)
      } catch let err {
        completion(nil, err.localizedDescription)
        print(err.localizedDescription)
      }
    }, error: { err in
      completion(nil, err)
    })
  }
}
extension ServerManager: JSONConverter {
  func convertFromJSON<T: Codable>(model: T.Type, data: Data?) -> T? {
    guard let data = data else {return nil}
    return try? JSONDecoder().decode(model.self, from: data)
  }
}

extension ServerManager {
  private func save(model: data) {
    let saveModel = SaveModel()
    let current = Current()
    do {
      try realm.write {
        current.market_cap = model.quote?.uSD?.market_cap ?? 0.0
        current.percent_change_1h = model.quote?.uSD?.percent_change_1h ?? 0.0
        current.percent_change_24h = model.quote?.uSD?.percent_change_24h ?? 0.0
        current.percent_change_7d = model.quote?.uSD?.percent_change_7d ?? 0.0
        current.percent_change_30d = model.quote?.uSD?.percent_change_30d ?? 0.0
        current.percent_change_60d = model.quote?.uSD?.percent_change_60d ?? 0.0
        current.volume_24h = model.quote?.uSD?.volume_24h ?? 0.0
        current.price = model.quote?.uSD?.price ?? 0.0
        current.last_updated = model.quote?.uSD?.last_updated ?? ""
        saveModel.id = model.id ?? 1
        saveModel.name = model.name ?? ""
        saveModel.symbol = model.symbol ?? ""
        saveModel.currencies.append(current)
        realm.create(SaveModel.self, value: saveModel, update: .modified)
      }
    } catch let rr {
      print(rr.localizedDescription)
    }
  }
}
