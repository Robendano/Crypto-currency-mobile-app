//
//  CryptoModel.swift
//  Crypto Currency
//
//  Created by Aidar Bekturov on 13/12/21.
//

import Foundation

// JSON model to convert
struct CryptoModel: Codable {
  var data: [data]?
}

struct data: Codable {
  var id: Int?
  var name: String?
  var symbol: String?
  var quote: Quote?
  
  enum CodingKeys: String, CodingKey {
    case id
    case name
    case symbol
    case quote
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    id = try? values.decodeIfPresent(Int.self, forKey: .id)
    name = try? values.decodeIfPresent(String.self, forKey: .name)
    symbol = try? values.decodeIfPresent(String.self, forKey: .symbol)
    quote = try? values.decodeIfPresent(Quote.self, forKey: .quote)
  }
}

struct Quote: Codable {
    
  var uSD: USD?

  enum CodingKeys: String, CodingKey {
    case uSD = "USD"
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    uSD = try? values.decodeIfPresent(USD.self, forKey: .uSD)
  }
}

struct USD: Codable {
    
  var price: Double?
  var volume_24h: Double?
  var percent_change_1h: Double?
  var percent_change_24h: Double?
  var percent_change_7d: Double?
  var percent_change_30d: Double?
  var percent_change_60d: Double?
  var percent_change_90d: Double?
  var market_cap : Double?
  var last_updated : String?
  
  enum CodingKeys: String, CodingKey {
    case price
    case volume_24h
    case percent_change_1h
    case percent_change_24h
    case percent_change_7d
    case percent_change_30d
    case percent_change_60d
    case percent_change_90d
    case market_cap
    case last_updated
  }
  
  init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    price = try? values.decodeIfPresent(Double.self, forKey: .price)
    volume_24h = try? values.decodeIfPresent(Double.self, forKey: .volume_24h)
    percent_change_1h = try? values.decodeIfPresent(Double.self, forKey: .percent_change_1h)
    percent_change_24h = try? values.decodeIfPresent(Double.self, forKey: .percent_change_24h)
    percent_change_7d = try? values.decodeIfPresent(Double.self, forKey: .percent_change_7d)
    percent_change_30d = try? values.decodeIfPresent(Double.self, forKey: .percent_change_30d)
    percent_change_60d = try? values.decodeIfPresent(Double.self, forKey: .percent_change_60d)
    percent_change_90d = try? values.decodeIfPresent(Double.self, forKey: .percent_change_90d)
    market_cap = try? values.decodeIfPresent(Double.self, forKey: .market_cap)
    last_updated = try? values.decodeIfPresent(String.self, forKey: .last_updated)
  }
}
