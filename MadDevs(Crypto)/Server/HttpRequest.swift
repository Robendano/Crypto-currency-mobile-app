//
//  HttpRequest.swift
//  MadDevs(Crypto)
//
//  Created by Рамазан Юсупов on 2/8/21.
//

import Foundation
import Alamofire
import SystemConfiguration

class HTTPRequest {
  
  typealias Success = (Data?) -> ()
  typealias Error = (String) -> ()
  
  private func request(method: HTTPMethod, url: String, parameters: Parameters?, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
    if !HTTPRequest.isConnectedToNetwork() {
      error(ServerConstants.ErrorMessage.NO_INTERNET_CONNECTION)
      return
    }
    AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseData(completionHandler: { (response) in
      guard response.response != nil else {
        error(ServerConstants.ErrorMessage.UNABLE_LOAD_DATA)
        return
      }
      guard let statusCode = response.response?.statusCode else {
        error(ServerConstants.ErrorMessage.NO_HTTP_STATUS_CODE)
        return
      }
      switch(statusCode) {
      
      case HTTPStatusCode.unauthorized.statusCode:
        error(ServerConstants.ErrorMessage.UNAUTHORIZED)
        break
        
      case HTTPStatusCode.notFound.statusCode:
        error(ServerConstants.ErrorMessage.NOT_FOUND)
        break
        
      case HTTPStatusCode.forbidden.statusCode:
        error(ServerConstants.ErrorMessage.FORBIDDEN)
        break
        
      case HTTPStatusCode.internalServerError.statusCode,
           HTTPStatusCode.serviceError.statusCode,
           HTTPStatusCode.serviceUnavailable.statusCode,
           HTTPStatusCode.serviceDowntime.statusCode:
        error(ServerConstants.ErrorMessage.SERVER_ERROR)
        break
        
      case HTTPStatusCode.badRequest.statusCode:
        error(ServerConstants.ErrorMessage.BAD_REQUEST)
        break
        
      case HTTPStatusCode.ok.statusCode,
           HTTPStatusCode.accepted.statusCode,
           HTTPStatusCode.done.statusCode,
           HTTPStatusCode.created.statusCode:
        guard let safeData = response.data else {return}
        complition(safeData)
        break
        
      default:
        error("")
      }
    })
  }
  
  internal func get(url: String, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
    request(method: .get, url: url, parameters: nil, header: header, complition: complition, error: error)
  }
  
  internal func post(url: String, parameters: Parameters, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
    request(method: .post, url: url, parameters: parameters, header: header, complition: complition, error: error)
  }
  internal func put(url: String, parameters: Parameters, header: HTTPHeaders, complition: @escaping Success, error: @escaping Error) {
    request(method: .put, url: url, parameters: parameters, header: header, complition: complition, error: error)
  }
  // MARK: - Internet Connectivity

  static func isConnectedToNetwork() -> Bool {
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
      $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
        SCNetworkReachabilityCreateWithAddress(nil, $0)
      }
    }) else {
      return false
    }
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
      return false
    }
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    return (isReachable && !needsConnection)
  }
}
